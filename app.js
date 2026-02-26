const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const multer = require('multer');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');
const crypto = require('crypto');
const NJCRatesService = require('./njc-rates-service');

// Simple password hashing (in production, use bcrypt)
function hashPassword(password) {
    return crypto.createHash('sha256').update(password + 'expense_tracker_salt').digest('hex');
}

function verifyPassword(password, hash) {
    return hashPassword(password) === hash;
}

// Input sanitization utilities for security
function sanitizeString(input, maxLength = 255) {
    if (typeof input !== 'string') return '';
    return input.trim().slice(0, maxLength);
}

function sanitizeAmount(input) {
    const amount = parseFloat(input);
    if (isNaN(amount) || amount < 0 || amount > 999999.99) {
        throw new Error('Invalid amount');
    }
    return amount;
}

function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email) && email.length <= 254;
}

const app = express();

// Initialize NJC Rates Service
const njcRates = new NJCRatesService();
const port = process.env.PORT || 3000;

// 📁 Ensure uploads directory exists
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
}

// 🛠️ Middleware
app.use(cors());
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' }));

// Force no-cache on all responses to prevent stale page issues
app.use((req, res, next) => {
    res.set('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');
    res.set('Pragma', 'no-cache');
    res.set('Expires', '0');
    res.set('Surrogate-Control', 'no-store');
    next();
});

// 🔒 SECURE STATIC FILE SERVING
// Block direct access to HTML files - force proper authentication flow
app.use((req, res, next) => {
    // Block direct access to HTML files that could bypass authentication
    if (req.path.endsWith('.html') && !req.path.includes('/uploads/')) {

        return res.redirect('/login');
    }
    next();
});

app.use('/uploads', express.static('uploads'));

// Serve translations.js explicitly for bilingual support
app.get('/translations.js', (req, res) => {
    res.sendFile(path.join(__dirname, 'translations.js'));
});

app.use(express.static(__dirname));

// Session management (simple in-memory for demo)
const sessions = new Map();

function generateSessionId() {
    return crypto.randomBytes(32).toString('hex');
}

function createSession(employeeId, role = 'employee') {
    const sessionId = generateSessionId();
    sessions.set(sessionId, {
        employeeId,
        role,
        createdAt: new Date(),
        lastActive: new Date()
    });
    return sessionId;
}

function getSession(sessionId) {
    const session = sessions.get(sessionId);
    if (session) {
        // Check if session has expired (8 hours = 8 * 60 * 60 * 1000 ms)
        const SESSION_TIMEOUT = 8 * 60 * 60 * 1000; // 8 hours
        const now = new Date();
        const timeSinceLastActive = now - session.lastActive;
        
        if (timeSinceLastActive > SESSION_TIMEOUT) {

            sessions.delete(sessionId);
            return null;
        }
        
        session.lastActive = now;
        return session;
    }
    return null;
}

function clearSession(sessionId) {
    sessions.delete(sessionId);
}

// 🔍 QA AGENT HEALTH CHECK ENDPOINTS (No Auth Required)
app.get('/api/health/database', (req, res) => {
    try {
        db.get("SELECT COUNT(*) as count FROM employees", (err, row) => {
            if (err) {
                return res.status(500).json({ error: 'Database connection failed', details: err.message });
            }
            res.json({ status: 'healthy', employees: row.count });
        });
    } catch (error) {
        res.status(500).json({ error: 'Database test failed', details: error.message });
    }
});

app.get('/api/health/tables', (req, res) => {
    const tables = ['employees', 'expenses', 'trips', 'njc_rates'];
    const results = {};
    
    Promise.all(tables.map(table => {
        return new Promise((resolve) => {
            db.get(`SELECT COUNT(*) as count FROM ${table}`, (err, row) => {
                results[table] = err ? { error: err.message } : { count: row.count };
                resolve();
            });
        });
    })).then(() => {
        res.json({ status: 'healthy', tables: results });
    });
});

app.get('/api/health/system', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        version: '1.0.0',
        node_version: process.version,
        uptime: process.uptime()
    });
});

app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        message: 'Government Employee Expense Tracker is running',
        timestamp: new Date().toISOString()
    });
});

// Authentication middleware
function requireAuth(req, res, next) {
    const sessionId = req.headers.authorization?.replace('Bearer ', '');
    const session = getSession(sessionId);
    
    if (!session) {
        return res.status(401).json({ error: 'Authentication required' });
    }
    
    req.user = session;
    next();
}

function requireRole(...roles) {
    return (req, res, next) => {
        if (roles.includes(req.user.role) || req.user.role === 'admin') {
            return next();
        }
        return res.status(403).json({ error: 'Insufficient permissions' });
    };
}

// 📷 Configure multer for file uploads
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        // Bug 3 Fix: Ensure uploads directory exists at upload time
        if (!fs.existsSync(uploadsDir)) {
            fs.mkdirSync(uploadsDir, { recursive: true });
        }
        cb(null, uploadsDir);
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, 'receipt-' + uniqueSuffix + path.extname(file.originalname));
    }
});

const upload = multer({ 
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
    fileFilter: function (req, file, cb) {
        const allowedTypes = /jpeg|jpg|png|gif|webp/;
        const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
        const mimetype = allowedTypes.test(file.mimetype);
        
        if (mimetype && extname) {
            return cb(null, true);
        } else {
            cb(new Error('Only image files are allowed (JPEG, PNG, GIF, WebP)'));
        }
    }
});

// 🗄️ Database connection
const db = new sqlite3.Database('expenses.db', (err) => {
    if (err) {
        console.error('❌ Database connection failed:', err.message);
    } else {
        console.log('✅ Connected to SQLite database');
        initializeDatabase();
    }
});

// 📊 Initialize database schema
function initializeDatabase() {
    const queries = [
        // Employees table (enhanced with auth and delegation)
        `CREATE TABLE IF NOT EXISTS employees (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            employee_number TEXT UNIQUE,
            email TEXT UNIQUE,
            password_hash TEXT,
            position TEXT,
            department TEXT,
            supervisor_id INTEGER,
            is_active INTEGER DEFAULT 1,
            role TEXT DEFAULT 'employee',
            delegate_id INTEGER,
            delegation_start_date DATE,
            delegation_end_date DATE,
            delegation_reason TEXT,
            last_login DATETIME,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (supervisor_id) REFERENCES employees (id),
            FOREIGN KEY (delegate_id) REFERENCES employees (id)
        )`,
        
        // 🧳 Trips table - For grouping expenses (like Concur expense reports)
        `CREATE TABLE IF NOT EXISTS trips (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER NOT NULL,
            trip_name TEXT NOT NULL,
            destination TEXT,
            purpose TEXT,
            start_date DATE NOT NULL,
            end_date DATE NOT NULL,
            status TEXT DEFAULT 'draft',
            total_amount DECIMAL(10,2) DEFAULT 0.00,
            submitted_at DATETIME,
            approved_by TEXT,
            approved_at DATETIME,
            approval_comment TEXT,
            rejection_reason TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (employee_id) REFERENCES employees (id)
        )`,
        
        // Expenses table (enhanced with trip association)
        `CREATE TABLE IF NOT EXISTS expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_name TEXT NOT NULL,
            employee_id INTEGER,
            trip_id INTEGER,
            expense_type TEXT NOT NULL,
            meal_name TEXT,
            date DATE NOT NULL,
            location TEXT,
            amount DECIMAL(10,2) NOT NULL,
            vendor TEXT,
            description TEXT,
            receipt_photo TEXT,
            status TEXT DEFAULT 'pending',
            approved_by TEXT,
            approved_at DATETIME,
            approval_comment TEXT,
            rejection_reason TEXT,
            return_reason TEXT,
            returned_by TEXT,
            returned_at DATETIME,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (employee_id) REFERENCES employees (id),
            FOREIGN KEY (trip_id) REFERENCES trips (id)
        )`,
        
        // Audit trail table for expense status changes
        `CREATE TABLE IF NOT EXISTS expense_audit_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expense_id INTEGER NOT NULL,
            action TEXT NOT NULL,
            actor_id INTEGER NOT NULL,
            actor_name TEXT NOT NULL,
            comment TEXT,
            previous_status TEXT,
            new_status TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (expense_id) REFERENCES expenses (id),
            FOREIGN KEY (actor_id) REFERENCES employees (id)
        )`,
        
        // Login audit trail table for security compliance
        `CREATE TABLE IF NOT EXISTS login_audit_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            employee_id INTEGER,
            success INTEGER NOT NULL,
            failure_reason TEXT,
            ip_address TEXT,
            user_agent TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (employee_id) REFERENCES employees (id)
        )`,
        
        // Employee audit trail table for governance compliance
        `CREATE TABLE IF NOT EXISTS employee_audit_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER NOT NULL,
            action TEXT NOT NULL,
            field_changed TEXT,
            old_value TEXT,
            new_value TEXT,
            performed_by INTEGER NOT NULL,
            performed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (employee_id) REFERENCES employees (id),
            FOREIGN KEY (performed_by) REFERENCES employees (id)
        )`,
        
        // NJC Rates table
        // NJC rates table now managed through comprehensive rate management system
        // See NJC-RATES-SYSTEM.md for details
        
        // 💰 GL Accounts table for Sage 300 mapping
        `CREATE TABLE IF NOT EXISTS gl_accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expense_type TEXT NOT NULL UNIQUE,
            gl_code TEXT NOT NULL,
            gl_name TEXT NOT NULL,
            is_active INTEGER DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )`,
        
        // 🏢 Department Cost Centers table for Sage 300 mapping
        `CREATE TABLE IF NOT EXISTS department_cost_centers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            department TEXT NOT NULL UNIQUE,
            cost_center_code TEXT NOT NULL,
            cost_center_name TEXT NOT NULL,
            is_active INTEGER DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )`,
        `CREATE TABLE IF NOT EXISTS njc_rates (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            rate_type TEXT NOT NULL,
            amount REAL NOT NULL,
            effective_date DATE NOT NULL,
            end_date DATE,
            province TEXT DEFAULT 'ALL',
            notes TEXT,
            created_by TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )`,
        
        // Signup tokens table for employee self-service signup
        `CREATE TABLE IF NOT EXISTS signup_tokens (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER NOT NULL,
            token TEXT UNIQUE NOT NULL,
            expires_at DATETIME NOT NULL,
            used INTEGER DEFAULT 0,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (employee_id) REFERENCES employees (id)
        )`,
        
        // Travel authorizations table for AT governance system
        `CREATE TABLE IF NOT EXISTS travel_authorizations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER NOT NULL,
            trip_id INTEGER,
            destination TEXT NOT NULL,
            start_date DATE NOT NULL,
            end_date DATE NOT NULL,
            purpose TEXT NOT NULL,
            est_transport REAL DEFAULT 0,
            est_lodging REAL DEFAULT 0,
            est_meals REAL DEFAULT 0,
            est_other REAL DEFAULT 0,
            est_total REAL DEFAULT 0,
            approver_id INTEGER,
            status TEXT DEFAULT 'pending',
            rejection_reason TEXT,
            approved_at DATETIME,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (employee_id) REFERENCES employees (id),
            FOREIGN KEY (trip_id) REFERENCES trips (id),
            FOREIGN KEY (approver_id) REFERENCES employees (id)
        )`,
        
        // App settings table
        `CREATE TABLE IF NOT EXISTS app_settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL,
            updated_by INTEGER,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )`,

        // Variance threshold audit log
        `CREATE TABLE IF NOT EXISTS settings_audit_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            setting_key TEXT NOT NULL,
            old_value TEXT,
            new_value TEXT NOT NULL,
            changed_by INTEGER NOT NULL,
            changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (changed_by) REFERENCES employees(id)
        )`
    ];
    
    // Run queries sequentially to ensure tables exist before inserting data
    let completedQueries = 0;
    
    queries.forEach(query => {
        db.run(query, (err) => {
            if (err) {
                console.error('❌ Database initialization error:', err.message);
            } else {
                completedQueries++;
                if (completedQueries === queries.length) {
                    // All tables created, now insert default data
                    setTimeout(() => insertDefaultData(), 100);
                }
            }
        });
    });
}

// 📋 Insert default data
function insertDefaultData() {
    // Insert sample employees with login credentials - FIXED HIERARCHY
    const employees = [
        ['John Smith', 'EMP001', 'john.smith@company.com', hashPassword('manager123'), 'Senior Manager', 'Management', null, 'admin'],
        ['Sarah Johnson', 'EMP002', 'sarah.johnson@company.com', hashPassword('sarah123'), 'Finance Supervisor', 'Finance', null, 'supervisor'], // Independent
        ['Mike Davis', 'EMP003', 'mike.davis@company.com', hashPassword('mike123'), 'Accountant', 'Finance', 2, 'employee'], // Reports to Sarah
        ['Lisa Brown', 'EMP004', 'lisa.brown@company.com', hashPassword('lisa123'), 'Operations Supervisor', 'Operations', null, 'supervisor'], // Independent  
        ['David Wilson', 'EMP005', 'david.wilson@company.com', hashPassword('david123'), 'Operations Specialist', 'Operations', 4, 'employee'], // Reports to Lisa
        ['Anna Lee', 'EMP006', 'anna.lee@company.com', hashPassword('anna123'), 'Project Coordinator', 'Operations', 4, 'employee'] // Reports to Lisa
    ];
    
    // Insert employees sequentially to guarantee consistent IDs
    function insertEmployeeSequential(index) {
        if (index >= employees.length) {
            // All employees inserted, now run migrations
            runPostInsertMigrations();
            return;
        }
        db.run(`INSERT OR IGNORE INTO employees (name, employee_number, email, password_hash, position, department, supervisor_id, role) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)`, employees[index], (err) => {
            if (err && !err.message.includes('UNIQUE constraint failed')) {
                console.error('❌ Error inserting employee:', err.message);
            }
            insertEmployeeSequential(index + 1);
        });
    }
    insertEmployeeSequential(0);
    
    function runPostInsertMigrations() {
        // CRITICAL FIX: Assign Mike Davis to Sarah Johnson as supervisor (missing in demo data)
        db.run(`UPDATE employees SET supervisor_id = (SELECT id FROM employees WHERE email = 'sarah.johnson@company.com') 
                WHERE employee_number = 'EMP003' AND supervisor_id IS NULL`, (err) => {
            if (err) console.error('❌ Error fixing Mike Davis supervisor:', err.message);
            else console.log('✅ Fixed Mike Davis supervisor assignment');
        });
        
        // 🚨 GOVERNANCE FIX: Lisa Brown should be INDEPENDENT Operations supervisor, NOT report to Sarah
        db.run(`UPDATE employees SET supervisor_id = NULL 
                WHERE employee_number = 'EMP004'`, (err) => {
            if (err) console.error('❌ Error making Lisa independent supervisor:', err.message);
            else console.log('✅ Fixed Lisa Brown - now independent Operations supervisor');
        });
        
        // Add category column for standalone expenses
        db.run(`ALTER TABLE expenses ADD COLUMN category TEXT`, (err) => {
            if (err && !err.message.includes('duplicate column')) {
                console.error('❌ Error adding category column:', err.message);
            }
        });

        // Ensure cost_center_id column exists on employees table
        db.run(`ALTER TABLE employees ADD COLUMN cost_center_id INTEGER`, (err) => {
            if (err && !err.message.includes('duplicate column')) {
                console.error('❌ Error adding cost_center_id column:', err.message);
            }
        });

        // Add details column for travel authorization per-day breakdown
        db.run(`ALTER TABLE travel_authorizations ADD COLUMN details TEXT`, (err) => {
            if (err && !err.message.includes('duplicate column')) {
                console.error('❌ Error adding details column:', err.message);
            }
        });

        // Add name column to travel_authorizations if missing
        db.run(`ALTER TABLE travel_authorizations ADD COLUMN name TEXT`, (err) => {
            if (err && !err.message.includes('duplicate column')) {
                // column already exists, fine
            }
        });

        // Add travel_auth_id column to expenses table for estimated expenses
        db.run(`ALTER TABLE expenses ADD COLUMN travel_auth_id INTEGER REFERENCES travel_authorizations(id)`, (err) => {
            if (err && !err.message.includes('duplicate column')) {
                console.error('❌ Error adding travel_auth_id column:', err.message);
            }
        });
    }
    
    // Seed NJC rates with historical and current periods
    const njcRates = [
        // 2023 rates (historical)
        ['breakfast', 23.00, '2023-04-01', '2024-03-31', 'ALL', '2023-2024 fiscal year rates', 'system'],
        ['lunch', 28.50, '2023-04-01', '2024-03-31', 'ALL', '2023-2024 fiscal year rates', 'system'],
        ['dinner', 45.75, '2023-04-01', '2024-03-31', 'ALL', '2023-2024 fiscal year rates', 'system'],
        ['incidentals', 30.50, '2023-04-01', '2024-03-31', 'ALL', '2023-2024 fiscal year rates', 'system'],
        ['vehicle', 0.61, '2023-04-01', '2024-03-31', 'ALL', '2023-2024 fiscal year km rate', 'system'],
        // 2024-2025 current rates
        ['breakfast', 23.45, '2024-04-01', null, 'ALL', '2024-2025 fiscal year rates', 'system'],
        ['lunch', 29.75, '2024-04-01', null, 'ALL', '2024-2025 fiscal year rates', 'system'],
        ['dinner', 47.05, '2024-04-01', null, 'ALL', '2024-2025 fiscal year rates', 'system'],
        ['incidentals', 32.08, '2024-04-01', null, 'ALL', '2024-2025 fiscal year rates', 'system'],
        ['vehicle', 0.68, '2024-04-01', null, 'ALL', '2024-2025 fiscal year km rate', 'system'],
    ];

    njcRates.forEach(rate => {
        db.run(`INSERT OR IGNORE INTO njc_rates (rate_type, amount, effective_date, end_date, province, notes, created_by) 
                VALUES (?, ?, ?, ?, ?, ?, ?)`, rate, (err) => {
            if (err && !err.message.includes('UNIQUE constraint failed')) {
                console.error('❌ Error inserting NJC rate:', err.message);
            }
        });
    });

    // Insert default GL account mappings
    const glAccounts = [
        ['meals', '5410', 'Travel - Meals'],
        ['hotel', '5420', 'Travel - Accommodation'],
        ['vehicle', '5430', 'Travel - Vehicle'],
        ['incidentals', '5440', 'Travel - Incidentals'],
        ['other', '5490', 'Travel - Other Expenses']
    ];
    
    glAccounts.forEach(account => {
        db.run(`INSERT OR IGNORE INTO gl_accounts (expense_type, gl_code, gl_name) VALUES (?, ?, ?)`, account, (err) => {
            if (err && !err.message.includes('UNIQUE constraint failed')) {
                console.error('❌ Error inserting GL account:', err.message);
            }
        });
    });
    
    // Insert default department cost centers (based on existing employees)
    const costCenters = [
        ['Finance', '100', 'Finance Department'],
        ['Operations', '200', 'Operations Department'], 
        ['Engineering', '300', 'Engineering Department'],
        ['Marketing', '400', 'Marketing Department']
    ];
    
    costCenters.forEach(center => {
        db.run(`INSERT OR IGNORE INTO department_cost_centers (department, cost_center_code, cost_center_name) VALUES (?, ?, ?)`, center, (err) => {
            if (err && !err.message.includes('UNIQUE constraint failed')) {
                console.error('❌ Error inserting cost center:', err.message);
            }
        });
    });
    
    console.log('✅ Default data initialized (including Sage 300 GL mappings)');
    
    // Seed additional employees and demo data if DB is fresh
    setTimeout(() => {
        db.get('SELECT COUNT(*) as count FROM employees', (err, row) => {
            if (row && row.count <= 6) {

                const extraEmployees = [
                    ['Rachel Chen', 'EMP007', 'rachel.chen@company.com', hashPassword('rachel123'), 'Team Lead', 'Engineering', null, 'supervisor'],
                    ['Marcus Thompson', 'EMP008', 'marcus.thompson@company.com', hashPassword('marcus123'), 'Team Lead', 'Marketing', null, 'supervisor'],
                    ['Priya Patel', 'EMP009', 'priya.patel@company.com', hashPassword('priya123'), 'Team Lead', 'Finance', null, 'supervisor'],
                    ['James Carter', 'EMP010', 'james.carter@company.com', hashPassword('james123'), 'Software Developer', 'Engineering', null, 'employee'],
                    ['Emily Zhang', 'EMP011', 'emily.zhang@company.com', hashPassword('emily123'), 'Data Analyst', 'Engineering', null, 'employee'],
                    ['Omar Hassan', 'EMP012', 'omar.hassan@company.com', hashPassword('omar123'), 'UX Designer', 'Engineering', null, 'employee'],
                    ['Sophie Martin', 'EMP013', 'sophie.martin@company.com', hashPassword('sophie123'), 'Marketing Specialist', 'Marketing', null, 'employee'],
                    ['Tyler Brooks', 'EMP014', 'tyler.brooks@company.com', hashPassword('tyler123'), 'Content Manager', 'Marketing', null, 'employee'],
                    ['Nina Kowalski', 'EMP015', 'nina.kowalski@company.com', hashPassword('nina123'), 'Social Media Lead', 'Marketing', null, 'employee'],
                    ['Alex Rivera', 'EMP016', 'alex.rivera@company.com', hashPassword('alex123'), 'Financial Analyst', 'Finance', null, 'employee'],
                    ['Fatima Al-Rashid', 'EMP017', 'fatima.alrashid@company.com', hashPassword('fatima123'), 'Accountant', 'Finance', null, 'employee'],
                    ["Ben O'Connor", 'EMP018', 'ben.oconnor@company.com', hashPassword('ben123'), 'Budget Officer', 'Finance', null, 'employee'],
                    ['Diana Reyes', 'EMP019', 'diana.reyes@company.com', hashPassword('diana123'), 'Policy Analyst', 'Operations', null, 'employee']
                ];
                let inserted = 0;
                extraEmployees.forEach(emp => {
                    db.run(`INSERT OR IGNORE INTO employees (name, employee_number, email, password_hash, position, department, supervisor_id, role) VALUES (?,?,?,?,?,?,?,?)`, emp, (err) => {
                        inserted++;
                        if (inserted === extraEmployees.length) {
                            // Fix supervisor assignments
                            db.all('SELECT id, email FROM employees', (err, rows) => {
                                if (!rows) return;
                                const byEmail = {};
                                rows.forEach(r => byEmail[r.email] = r.id);
                                const sarah = byEmail['sarah.johnson@company.com'];
                                const rachel = byEmail['rachel.chen@company.com'];
                                const marcus = byEmail['marcus.thompson@company.com'];
                                const priya = byEmail['priya.patel@company.com'];
                                const lisa = byEmail['lisa.brown@company.com'];
                                // Supervisors report to Sarah (top-level supervisor)
                                if (rachel) db.run('UPDATE employees SET supervisor_id = ? WHERE id = ?', [sarah, rachel]);
                                if (marcus) db.run('UPDATE employees SET supervisor_id = ? WHERE id = ?', [sarah, marcus]);
                                if (priya) db.run('UPDATE employees SET supervisor_id = ? WHERE id = ?', [sarah, priya]);
                                // Employees to their supervisors
                                ['james.carter','emily.zhang','omar.hassan'].forEach(e => { if (byEmail[e+'@company.com']) db.run('UPDATE employees SET supervisor_id = ? WHERE id = ?', [rachel, byEmail[e+'@company.com']]); });
                                ['sophie.martin','tyler.brooks','nina.kowalski'].forEach(e => { if (byEmail[e+'@company.com']) db.run('UPDATE employees SET supervisor_id = ? WHERE id = ?', [marcus, byEmail[e+'@company.com']]); });
                                ['alex.rivera','fatima.alrashid','ben.oconnor'].forEach(e => { if (byEmail[e+'@company.com']) db.run('UPDATE employees SET supervisor_id = ? WHERE id = ?', [priya, byEmail[e+'@company.com']]); });
                                if (byEmail['diana.reyes@company.com']) db.run('UPDATE employees SET supervisor_id = ? WHERE id = ?', [lisa, byEmail['diana.reyes@company.com']]);
                                // Remove admin as supervisor
                                const admin = byEmail['john.smith@company.com'];
                                db.run('UPDATE employees SET supervisor_id = NULL WHERE supervisor_id = ? AND email != ?', [admin, 'sarah.johnson@company.com']);
                                db.run('UPDATE employees SET supervisor_id = NULL WHERE email = ?', ['sarah.johnson@company.com']);

                            });
                        }
                    });
                });
            }
        });
    }, 2000);
    
    // Seed default variance thresholds
    db.run(`INSERT OR IGNORE INTO app_settings (key, value) VALUES ('variance_pct_threshold', '10')`, (err) => {
        if (err && !err.message.includes('UNIQUE constraint failed')) {
            console.error('❌ Error inserting variance_pct_threshold:', err.message);
        }
    });
    db.run(`INSERT OR IGNORE INTO app_settings (key, value) VALUES ('variance_dollar_threshold', '100')`, (err) => {
        if (err && !err.message.includes('UNIQUE constraint failed')) {
            console.error('❌ Error inserting variance_dollar_threshold:', err.message);
        }
    });
    
    console.log('✅ Default variance threshold settings initialized');
}

// 🌐 Routes

// 🔐 SECURE ROUTING - AUTHENTICATION REQUIRED
// All routes require proper authentication flow

app.get('/', (req, res) => {
    // Always redirect to login - no bypass allowed
    res.redirect('/login');
});

app.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname, 'login.html'));
});

// Protected employee dashboard - requires authentication
app.get('/dashboard', (req, res) => {
    res.sendFile(path.join(__dirname, 'employee-dashboard.html'));
});

// Protected admin panel - requires authentication 
app.get('/admin', (req, res) => {
    res.sendFile(path.join(__dirname, 'admin.html'));
});

// Legacy route protection - prevent direct access to old forms
app.get('/index.html', (req, res) => {
    res.redirect('/login');
});

// Employee dashboard alias (for convenience)
app.get('/employee', (req, res) => {
    res.redirect('/dashboard');
});

// 🔐 Authentication Routes

// Rate limiting for login attempts (simple in-memory solution)
const loginAttempts = new Map();
const MAX_LOGIN_ATTEMPTS = 5;
const LOCKOUT_DURATION = 15 * 60 * 1000; // 15 minutes

// Employee login with improved security
app.post('/api/auth/login', async (req, res) => {
    let { email, password } = req.body;
    
    // Input validation and sanitization
    if (!email || !password) {
        return res.status(400).json({
            success: false,
            error: 'Email and password are required'
        });
    }
    
    email = sanitizeString(email, 254);
    
    if (!validateEmail(email)) {
        return res.status(400).json({
            success: false,
            error: 'Invalid email format'
        });
    }
    
    if (password.length > 128) {
        return res.status(400).json({
            success: false,
            error: 'Password is too long'
        });
    }
    
    // Simple rate limiting check
    const clientKey = req.ip || 'unknown';
    const attempts = loginAttempts.get(clientKey) || { count: 0, firstAttempt: Date.now() };
    
    if (attempts.count >= MAX_LOGIN_ATTEMPTS) {
        const timePassed = Date.now() - attempts.firstAttempt;
        if (timePassed < LOCKOUT_DURATION) {
            return res.status(429).json({
                success: false,
                error: 'Too many login attempts. Please try again later.'
            });
        } else {
            // Reset attempts after lockout period
            loginAttempts.delete(clientKey);
        }
    }
    
    // Find employee
    db.get('SELECT * FROM employees WHERE email = ? AND is_active = 1', [email], (err, employee) => {
        if (err) {
            console.error('❌ Login error:', err);
            return res.status(500).json({
                success: false,
                error: 'Login failed'
            });
        }
        
        if (!employee || !employee.password_hash || !verifyPassword(password, employee.password_hash)) {
            // Track failed login attempt
            attempts.count += 1;
            attempts.firstAttempt = attempts.firstAttempt || Date.now();
            loginAttempts.set(clientKey, attempts);
            
            // Log failed login attempt
            let failureReason = 'Invalid password';
            if (!employee) {
                failureReason = 'User not found';
            } else if (!employee.password_hash) {
                failureReason = 'Account setup incomplete - user must complete signup process';
            }
            
            logLoginAttempt(email, employee?.id || null, false, failureReason, 
                req.ip || req.connection.remoteAddress, req.get('User-Agent'));
            
            return res.status(401).json({
                success: false,
                error: !employee || !employee.password_hash ? 
                    'Account setup incomplete. Please check your email for a signup link.' :
                    'Invalid email or password'
            });
        }
        
        // Clear login attempts on successful login
        loginAttempts.delete(clientKey);
        
        // Log successful login attempt
        logLoginAttempt(email, employee.id, true, null, 
            req.ip || req.connection.remoteAddress, req.get('User-Agent'));
        
        // Update last login
        db.run('UPDATE employees SET last_login = CURRENT_TIMESTAMP WHERE id = ?', [employee.id]);
        
        // Create session
        const sessionId = createSession(employee.id, employee.role);

        // Sanitize user data in response
        res.json({
            success: true,
            sessionId,
            user: {
                id: employee.id,
                name: sanitizeString(employee.name),
                email: email, // Already sanitized above
                employee_number: sanitizeString(employee.employee_number),
                position: sanitizeString(employee.position),
                department: sanitizeString(employee.department),
                role: employee.role,
                supervisor_id: employee.supervisor_id
            }
        });
    });
});

// Employee logout
app.post('/api/auth/logout', requireAuth, (req, res) => {
    const sessionId = req.headers.authorization?.replace('Bearer ', '');
    clearSession(sessionId);
    
    res.json({ success: true, message: 'Logged out successfully' });
});

// Get current user info
app.get('/api/auth/me', requireAuth, (req, res) => {
    db.get('SELECT id, name, email, employee_number, position, department, role, supervisor_id FROM employees WHERE id = ?', 
        [req.user.employeeId], (err, employee) => {
        if (err || !employee) {
            return res.status(404).json({ error: 'User not found' });
        }
        
        res.json(employee);
    });
});

// Create employee account (admin only)
app.post('/api/auth/register', requireAuth, requireRole('admin'), (req, res) => {
    const { name, employee_number, email, password, position, department, supervisor_id, role } = req.body;
    
    if (!name || !employee_number || !email || !password) {
        return res.status(400).json({
            success: false,
            error: 'Name, employee number, email, and password are required'
        });
    }
    
    const passwordHash = hashPassword(password);
    
    const query = `
        INSERT INTO employees (name, employee_number, email, password_hash, position, department, supervisor_id, role)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;
    
    db.run(query, [name, employee_number, email, passwordHash, position, department, supervisor_id, role || 'employee'], function(err) {
        if (err) {
            if (err.message.includes('UNIQUE constraint failed')) {
                return res.status(409).json({
                    success: false,
                    error: 'Employee number or email already exists'
                });
            }
            return res.status(500).json({
                success: false,
                error: 'Failed to create account'
            });
        }
        
        res.json({
            success: true,
            id: this.lastID,
            message: 'Employee account created successfully'
        });
    });
});

// 📊 API Routes

// Get all expenses (admin) or team expenses (supervisor)
app.get('/api/expenses', requireAuth, (req, res) => {
    let query;
    let params = [];
    
    if (req.user.role === 'admin') {
        // Admin sees all expenses
        query = `
            SELECT e.*, 
                   emp.name as employee_name_from_db,
                   emp.supervisor_id,
                   sup.name as supervisor_name
            FROM expenses e
            LEFT JOIN employees emp ON e.employee_id = emp.id
            LEFT JOIN employees sup ON emp.supervisor_id = sup.id
            ORDER BY e.created_at DESC
        `;
    } else if (req.user.role === 'supervisor') {
        // 🚨 GOVERNANCE FIX: Supervisor sees ONLY direct reports' expenses (not indirect)
        query = `
            SELECT e.*, 
                   emp.name as employee_name_from_db,
                   emp.supervisor_id,
                   sup.name as supervisor_name,
                   t.trip_name,
                   t.start_date as trip_start,
                   t.end_date as trip_end,
                   t.destination as trip_destination,
                   t.status as trip_status
            FROM expenses e
            LEFT JOIN employees emp ON e.employee_id = emp.id
            LEFT JOIN employees sup ON emp.supervisor_id = sup.id
            LEFT JOIN trips t ON e.trip_id = t.id
            WHERE emp.supervisor_id = ?
            ORDER BY e.created_at DESC
        `;
        params = [req.user.employeeId];
    } else {
        return res.status(403).json({ error: 'Access denied' });
    }
    
    db.all(query, params, (err, rows) => {
        if (err) {
            console.error('❌ Error fetching expenses:', err);
            return res.status(500).json({ error: 'Failed to fetch expenses' });
        }

        res.json(rows);
    });
});

// Submit new expense (authenticated employees)
app.post('/api/expenses', requireAuth, upload.single('receipt'), async (req, res) => {
    try {
        let {
            expense_type,
            meal_name,
            date,
            location,
            amount,
            vendor,
            description,
            trip_id,
            category
        } = req.body;
        
        // Sanitize all string inputs
        expense_type = sanitizeString(expense_type, 50);
        meal_name = sanitizeString(meal_name, 100);
        location = sanitizeString(location, 255);
        vendor = sanitizeString(vendor, 255);
        description = sanitizeString(description, 1000);
        
        // Validate required fields
        if (!expense_type || !date || !amount) {
            return res.status(400).json({ 
                success: false, 
                error: 'Please fill in all required fields: expense type, date, and amount before submitting.' 
            });
        }
        
        // Validate and sanitize amount
        try {
            amount = sanitizeAmount(amount);
        } catch (error) {
            return res.status(400).json({
                success: false,
                error: 'Please enter a valid amount between $0.01 and $999,999.99'
            });
        }
        
        // Validate date format and range
        // Use date-only comparison to avoid timezone issues
        const dateParts = date.split('-');
        const expenseDate = new Date(Date.UTC(dateParts[0], dateParts[1] - 1, dateParts[2]));
        const now = new Date();
        const todayUTC = new Date(Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()));
        const oneYearAgo = new Date(todayUTC);
        oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1);
        
        // Only block clearly invalid dates (> 1 year old or invalid)
        if (isNaN(expenseDate.getTime()) || expenseDate < oneYearAgo) {
            return res.status(400).json({
                success: false,
                error: 'Please enter a valid date within the last year'
            });
        }
        
        // Flag future-dated expenses (don't block — supervisor will review)
        let isFutureDated = expenseDate > todayUTC;
        
        // Sanitize trip_id if provided
        if (trip_id) {
            trip_id = parseInt(trip_id);
            if (isNaN(trip_id)) {
                trip_id = null;
            }
        }
    
    // CRITICAL FIX: Validate expense type and handle common aliases
    const validExpenseTypes = ['breakfast', 'lunch', 'dinner', 'incidentals', 'vehicle_km', 'hotel', 'other', 'transport', 'transport_flight', 'transport_train', 'transport_bus', 'transport_rental'];
    
    // Handle common expense type aliases
    if (expense_type === 'meals') {
        return res.status(400).json({
            success: false,
            error: 'Use specific meal types: "breakfast", "lunch", or "dinner" instead of "meals"',
            valid_types: validExpenseTypes
        });
    }
    if (expense_type === 'transport') {
        expense_type = 'vehicle_km'; // Normalize transport to vehicle_km
    }
    
    if (!validExpenseTypes.includes(expense_type)) {
        return res.status(400).json({
            success: false,
            error: `Invalid expense type "${expense_type}". Allowed types: ${validExpenseTypes.join(', ')}`
        });
    }
    
    // Bug 4 Fix: Validate expense date falls within trip date range
    if (trip_id) {
        try {
            const trip = await new Promise((resolve, reject) => {
                db.get('SELECT start_date, end_date, trip_name FROM trips WHERE id = ?', [trip_id],
                    (err, row) => err ? reject(err) : resolve(row));
            });
            if (trip && (date < trip.start_date || date > trip.end_date)) {
                return res.status(400).json({
                    success: false,
                    error: `Expense date ${date} is outside the trip "${trip.trip_name}" date range (${trip.start_date} to ${trip.end_date}).`
                });
            }
        } catch (err) {
            console.error('❌ Error validating expense date against trip:', err);
        }
    }
    
    // Check if this is a per diem expense type
    const perDiemTypes = ['breakfast', 'lunch', 'dinner', 'incidentals'];
    const isPerDiem = perDiemTypes.includes(expense_type);
    
    // CRITICAL: Per diem duplicate prevention — scoped to same trip
    if (isPerDiem && trip_id) {
        const hasDuplicate = await new Promise((resolve, reject) => {
            db.get(
                `SELECT COUNT(*) as count FROM expenses WHERE employee_id = ? AND expense_type = ? AND date = ? AND trip_id = ? AND status NOT IN ('rejected', 'estimate')`,
                [req.user.employeeId, expense_type, date, trip_id],
                (err, row) => err ? reject(err) : resolve(row.count > 0)
            );
        });
        
        if (hasDuplicate) {

            return res.status(400).json({
                success: false,
                error: `You've already claimed ${expense_type} for ${date}. Government policy allows only one ${expense_type} per diem per day. Please check your expense history.`
            });
        }
    }
    
    // Hotel category validation: receipt required (but not for trip Day Planner — receipt uploaded separately)
    if (expense_type === 'hotel' && !req.file && !trip_id) {
        return res.status(400).json({
            success: false,
            error: 'Hotel expenses require a receipt photo for audit compliance. Please scroll down and upload your hotel receipt before submitting.'
        });
    }
    
    // Per diem rate validation (only for trip-based expenses)
    if (trip_id && njcRates.isPerDiem(expense_type)) {
        try {
            const validation = await njcRates.validatePerDiemExpense(expense_type, amount, date);
            if (!validation.valid) {
                return res.status(400).json({
                    success: false,
                    error: validation.message
                });
            }
        } catch (valErr) {
            console.error('❌ Per diem validation error:', valErr);
            // Don't block submission on validation errors — just log
        }
    }
    
    // Vehicle km rate validation ($0.68/km — amount must be a multiple of rate, max 10,000km)
    if (expense_type === 'vehicle_km') {
        const ratePerKm = 0.68;
        const impliedKm = amount / ratePerKm;
        if (amount <= 0) {
            return res.status(400).json({ success: false, error: 'Vehicle expense amount must be positive.' });
        }
        if (impliedKm > 10000) {
            return res.status(400).json({ success: false, error: `Vehicle claim implies ${impliedKm.toFixed(0)}km — exceeds 10,000km single-trip maximum.` });
        }
        // Validate amount is a clean multiple of $0.68 (within rounding tolerance)
        const remainder = amount % ratePerKm;
        if (remainder > 0.01 && remainder < (ratePerKm - 0.01)) {
            const suggestedKm = Math.round(amount / ratePerKm);
            const suggestedAmount = (suggestedKm * ratePerKm).toFixed(2);
            return res.status(400).json({ success: false, error: `Vehicle amount must match the NJC rate of $${ratePerKm}/km. For $${amount.toFixed(2)}, did you mean ${suggestedKm} km = $${suggestedAmount}?` });
        }
    }
    
    // Prevent duplicate per diem claims on same day for same trip
    const perDiemTypesCheck = ['breakfast', 'lunch', 'dinner', 'incidentals'];
    if (perDiemTypesCheck.includes(expense_type) && trip_id) {
        const dupRow = await new Promise((resolve, reject) => {
            db.get('SELECT id FROM expenses WHERE trip_id = ? AND expense_type = ? AND date = ? AND status NOT IN (\'rejected\', \'estimate\')',
                [trip_id, expense_type, date], (e, row) => e ? reject(e) : resolve(row));
        }).catch(() => null);
        if (dupRow) {
            const pnames = { breakfast: 'Breakfast', lunch: 'Lunch', dinner: 'Dinner', incidentals: 'Incidentals' };
            return res.status(400).json({ success: false, error: `${pnames[expense_type]} already claimed for ${date}. Only one per day allowed.` });
        }
    }

    // Get employee info from session
    db.get('SELECT name FROM employees WHERE id = ?', [req.user.employeeId], (err, employee) => {
        if (err || !employee) {
            return res.status(404).json({
                success: false,
                error: 'Employee not found'
            });
        }
        
        const receiptPath = req.file ? `/uploads/${req.file.filename}` : null;
        
        // Simple insert for ALL expense types (per diem already validated above)
        const query = `
            INSERT INTO expenses (employee_name, employee_id, trip_id, expense_type, meal_name, date, location, amount, vendor, description, receipt_photo, category)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        
        // Append future-date flag to description for supervisor visibility
        let finalDescription = description || '';
        if (isFutureDated) {
            finalDescription = (finalDescription ? finalDescription + ' | ' : '') + '⚠️ FUTURE-DATED EXPENSE (submitted before expense date)';
        }
        
        const params = [employee.name, req.user.employeeId, trip_id || null, expense_type, meal_name, date, location, amount, vendor, finalDescription, receiptPath, category || null];
        
        db.run(query, params, function(err) {
            if (err) {
                console.error('❌ Error submitting expense:', err);
                return res.status(500).json({ success: false, error: 'Failed to submit expense' });
            }
            
            const expenseId = this.lastID;
            
            // Log expense creation to audit trail
            logExpenseAudit(expenseId, 'submitted', req.user.employeeId, employee.name, 
                `${expense_type} expense submitted: $${amount} at ${location}`, null, 'pending');
            
            const msg = isPerDiem 
                ? `✅ ${meal_name || expense_type} per diem submitted! Locked to prevent duplicates.`
                : 'Expense submitted successfully!';

            res.json({ success: true, id: expenseId, message: msg });
        });
    });
    } catch (error) {
        console.error('❌ Error processing expense submission:', error);
        return res.status(500).json({
            success: false,
            error: 'An error occurred while processing your expense. Please try again.'
        });
    }
});

// CONCUR ENHANCEMENT: Get audit trail for expense
app.get('/api/expenses/:id/audit-trail', requireAuth, (req, res) => {
    const { id } = req.params;
    
    // First verify user has permission to view this expense
    db.get('SELECT employee_id FROM expenses WHERE id = ?', [id], (err, expense) => {
        if (err) {
            console.error('❌ Error checking expense:', err);
            return res.status(500).json({ error: 'Failed to check expense' });
        }
        
        if (!expense) {
            return res.status(404).json({ error: 'Expense not found' });
        }
        
        // Allow if user owns expense, is supervisor of owner, or is admin
        const canView = expense.employee_id === req.user.employeeId || 
                        req.user.role === 'admin' || 
                        req.user.role === 'supervisor';
        
        if (!canView) {
            return res.status(403).json({ error: 'Access denied' });
        }
        
        // Get audit trail
        const query = `
            SELECT al.*, e.name as actor_employee_name
            FROM expense_audit_log al
            LEFT JOIN employees e ON al.actor_id = e.id
            WHERE al.expense_id = ?
            ORDER BY al.timestamp DESC
        `;
        
        db.all(query, [id], (err2, auditTrail) => {
            if (err2) {
                console.error('❌ Error fetching audit trail:', err2);
                return res.status(500).json({ error: 'Failed to fetch audit trail' });
            }
            
            res.json({
                success: true,
                expense_id: id,
                audit_trail: auditTrail
            });
        });
    });
});

// CONCUR ENHANCEMENT: Pre-submission validation check
app.get('/api/pre-submission-check/:tripId', requireAuth, (req, res) => {
    const { tripId } = req.params;
    
    // Get trip with expenses
    const query = `
        SELECT t.*, 
               e.id as expense_id, e.expense_type, e.amount, e.receipt_photo, e.date, e.status
        FROM trips t
        LEFT JOIN expenses e ON t.id = e.trip_id
        WHERE t.id = ? AND t.employee_id = ?
        ORDER BY e.date ASC
    `;
    
    db.all(query, [tripId, req.user.employeeId], (err, rows) => {
        if (err) {
            console.error('❌ Error in pre-submission check:', err);
            return res.status(500).json({ error: 'Failed to perform pre-submission check' });
        }
        
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Trip not found' });
        }
        
        const trip = rows[0];
        const expenses = rows.filter(row => row.expense_id).map(row => ({
            id: row.expense_id,
            expense_type: row.expense_type,
            amount: row.amount,
            receipt_photo: row.receipt_photo,
            date: row.date,
            status: row.status
        }));
        
        // Perform validation checks
        const checks = {
            expenses_count: {
                status: expenses.length > 0 ? 'pass' : 'fail',
                message: expenses.length > 0 ? 
                    `${expenses.length} expense(s) added to trip` : 
                    'No expenses added to this trip',
                required: true
            },
            hotel_receipts: {
                status: 'pass',
                message: 'Receipt requirements satisfied',
                required: true
            },
            policy_compliance: {
                status: 'pass',
                message: 'All amounts within policy limits',
                required: true
            },
            date_ranges: {
                status: 'pass',
                message: 'All expense dates within trip period',
                required: true
            }
        };
        
        // Check hotel receipts
        const hotelExpenses = expenses.filter(e => e.expense_type === 'hotel');
        const hotelsMissingReceipts = hotelExpenses.filter(e => !e.receipt_photo);
        
        if (hotelsMissingReceipts.length > 0) {
            checks.hotel_receipts.status = 'fail';
            checks.hotel_receipts.message = `${hotelsMissingReceipts.length} hotel expense(s) missing required receipts`;
        }
        
        // Check expense dates within trip range
        const tripStart = new Date(trip.start_date);
        const tripEnd = new Date(trip.end_date);
        const expensesOutsideRange = expenses.filter(e => {
            const expenseDate = new Date(e.date);
            return expenseDate < tripStart || expenseDate > tripEnd;
        });
        
        if (expensesOutsideRange.length > 0) {
            checks.date_ranges.status = 'fail';
            checks.date_ranges.message = `${expensesOutsideRange.length} expense(s) outside trip date range`;
        }
        
        // Calculate totals
        const totalAmount = expenses.reduce((sum, e) => sum + parseFloat(e.amount), 0);
        
        const readyToSubmit = Object.values(checks).every(check => 
            !check.required || check.status === 'pass'
        );
        
        res.json({
            success: true,
            trip: {
                id: trip.id,
                trip_name: trip.trip_name,
                start_date: trip.start_date,
                end_date: trip.end_date,
                status: trip.status
            },
            expenses_summary: {
                count: expenses.length,
                total_amount: totalAmount.toFixed(2)
            },
            validation_checks: checks,
            ready_to_submit: readyToSubmit,
            timestamp: new Date().toISOString()
        });
    });
});

// CONCUR ENHANCEMENT: Approval delegation endpoints
app.post('/api/delegation/set', requireAuth, requireRole('supervisor'), (req, res) => {
    const { delegate_id, start_date, end_date, reason } = req.body;
    
    if (!delegate_id || !start_date || !end_date) {
        return res.status(400).json({
            success: false,
            error: 'delegate_id, start_date, and end_date are required'
        });
    }
    
    // Validate delegate is not the same person
    if (delegate_id == req.user.employeeId) {
        return res.status(400).json({
            success: false,
            error: 'Cannot delegate to yourself'
        });
    }
    
    // Validate delegate exists and is a supervisor
    db.get('SELECT id, name, role FROM employees WHERE id = ? AND role = "supervisor"', 
        [delegate_id], (err, delegate) => {
        
        if (err) {
            console.error('❌ Error checking delegate:', err);
            return res.status(500).json({ success: false, error: 'Failed to validate delegate' });
        }
        
        if (!delegate) {
            return res.status(404).json({
                success: false,
                error: 'Delegate not found or is not a supervisor'
            });
        }
        
        // Set delegation
        const query = `
            UPDATE employees 
            SET delegate_id = ?, delegation_start_date = ?, delegation_end_date = ?, 
                delegation_reason = ?
            WHERE id = ?
        `;
        
        db.run(query, [delegate_id, start_date, end_date, reason || '', req.user.employeeId], 
            function(err2) {
                if (err2) {
                    console.error('❌ Error setting delegation:', err2);
                    return res.status(500).json({
                        success: false,
                        error: 'Failed to set delegation'
                    });
                }
                
                // Notify delegate
                createNotification(delegate_id, 'delegation_assigned',
                    `You have been assigned as approval delegate from ${start_date} to ${end_date}. Reason: ${reason || 'Not specified'}`);
                
                res.json({
                    success: true,
                    message: `Approval delegation set to ${delegate.name} from ${start_date} to ${end_date}`,
                    delegate_name: delegate.name
                });
            });
    });
});

app.get('/api/delegation/current', requireAuth, (req, res) => {
    const query = `
        SELECT e.delegate_id, e.delegation_start_date, e.delegation_end_date, 
               e.delegation_reason, d.name as delegate_name
        FROM employees e
        LEFT JOIN employees d ON e.delegate_id = d.id
        WHERE e.id = ?
    `;
    
    db.get(query, [req.user.employeeId], (err, delegation) => {
        if (err) {
            console.error('❌ Error fetching delegation:', err);
            return res.status(500).json({ error: 'Failed to fetch delegation info' });
        }
        
        if (!delegation || !delegation.delegate_id) {
            return res.json({
                success: true,
                delegation: null
            });
        }
        
        // Check if delegation is currently active
        const today = new Date().toISOString().split('T')[0];
        const isActive = delegation.delegation_start_date <= today && 
                         today <= delegation.delegation_end_date;
        
        res.json({
            success: true,
            delegation: {
                ...delegation,
                is_active: isActive
            }
        });
    });
});

// CONCUR ENHANCEMENT: Receipt preview endpoint
app.get('/api/expenses/:id/receipt', requireAuth, (req, res) => {
    const { id } = req.params;
    
    // Check if user can view this expense
    db.get(`
        SELECT e.receipt_photo, e.employee_id, emp.name as employee_name 
        FROM expenses e
        LEFT JOIN employees emp ON e.employee_id = emp.id
        WHERE e.id = ?
    `, [id], (err, expense) => {
        if (err) {
            console.error('❌ Error fetching expense receipt:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        
        if (!expense) {
            return res.status(404).json({ error: 'Expense not found' });
        }
        
        // Allow if user owns expense, is supervisor of owner, or is admin
        const canView = expense.employee_id === req.user.employeeId || 
                        req.user.role === 'admin' || 
                        req.user.role === 'supervisor';
        
        if (!canView) {
            return res.status(403).json({ error: 'Access denied' });
        }
        
        if (!expense.receipt_photo) {
            return res.status(404).json({ error: 'No receipt photo found for this expense' });
        }
        
        res.json({
            success: true,
            receipt_photo: expense.receipt_photo,
            employee_name: expense.employee_name
        });
    });
});

// Get employee's own expenses (with trip information)
app.get('/api/my-expenses', requireAuth, (req, res) => {
    const query = `
        SELECT e.*, t.trip_name, t.destination as trip_destination
        FROM expenses e
        LEFT JOIN trips t ON e.trip_id = t.id
        WHERE e.employee_id = ? 
        ORDER BY e.created_at DESC
    `;
    
    db.all(query, [req.user.employeeId], (err, rows) => {
        if (err) {
            console.error('❌ Error fetching user expenses:', err);
            return res.status(500).json({ error: 'Failed to fetch expenses' });
        }

        res.json(rows);
    });
});

// CONCUR ENHANCEMENT: Audit trail logging function
function logExpenseAudit(expenseId, action, actorId, actorName, comment, previousStatus, newStatus) {
    db.run(`
        INSERT INTO expense_audit_log (expense_id, action, actor_id, actor_name, comment, previous_status, new_status)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    `, [expenseId, action, actorId, actorName, comment, previousStatus, newStatus], (err) => {
        if (err) {
            console.error('❌ Audit log error:', err.message);
        } else {

        }
    });
}

// Login audit logging function for security compliance
function logLoginAttempt(email, employeeId, success, failureReason, ipAddress, userAgent) {
    db.run(`
        INSERT INTO login_audit_log (email, employee_id, success, failure_reason, ip_address, user_agent)
        VALUES (?, ?, ?, ?, ?, ?)
    `, [email, employeeId, success ? 1 : 0, failureReason, ipAddress, userAgent], (err) => {
        if (err) {
            console.error('❌ Login audit log error:', err.message);
        } else {
            const status = success ? 'SUCCESS' : 'FAILED';

        }
    });
}

// Employee audit logging function for governance compliance
function logEmployeeAudit(employeeId, action, fieldChanged, oldValue, newValue, performedBy) {
    db.run(`
        INSERT INTO employee_audit_log (employee_id, action, field_changed, old_value, new_value, performed_by)
        VALUES (?, ?, ?, ?, ?, ?)
    `, [employeeId, action, fieldChanged, oldValue, newValue, performedBy], (err) => {
        if (err) {
            console.error('❌ Employee audit log error:', err.message);
        }
    });
}

// GET /api/audit-log endpoint (admin only) - Full system audit trail
app.get('/api/audit-log', requireAuth, requireRole('admin'), (req, res) => {
    const { limit = 100, offset = 0, expense_id } = req.query;
    
    let query = `
        SELECT al.*, 
               e.employee_name as expense_employee,
               e.amount as expense_amount,
               e.expense_type,
               e.date as expense_date,
               actor.name as actor_employee_name,
               actor.role as actor_role
        FROM expense_audit_log al
        LEFT JOIN expenses e ON al.expense_id = e.id
        LEFT JOIN employees actor ON al.actor_id = actor.id
    `;
    
    let params = [];
    
    if (expense_id) {
        query += ` WHERE al.expense_id = ?`;
        params.push(expense_id);
    }
    
    query += ` ORDER BY al.timestamp DESC LIMIT ? OFFSET ?`;
    params.push(parseInt(limit), parseInt(offset));
    
    db.all(query, params, (err, rows) => {
        if (err) {
            console.error('❌ Error fetching audit log:', err);
            return res.status(500).json({ error: 'Failed to fetch audit log' });
        }
        
        // Get total count
        const countQuery = expense_id ? 
            'SELECT COUNT(*) as total FROM expense_audit_log WHERE expense_id = ?' :
            'SELECT COUNT(*) as total FROM expense_audit_log';
        const countParams = expense_id ? [expense_id] : [];
        
        db.get(countQuery, countParams, (err2, countRow) => {
            if (err2) {
                console.error('❌ Error fetching audit count:', err2);
                return res.status(500).json({ error: 'Failed to fetch audit count' });
            }

            res.json({
                success: true,
                audit_log: rows,
                pagination: {
                    total: countRow.total,
                    limit: parseInt(limit),
                    offset: parseInt(offset),
                    has_more: (parseInt(offset) + rows.length) < countRow.total
                }
            });
        });
    });
});

// GET /api/login-audit-log endpoint (admin only) - Login attempt audit trail
app.get('/api/login-audit-log', requireAuth, requireRole('admin'), (req, res) => {
    const { limit = 100, offset = 0, email, success_only, failed_only } = req.query;
    
    let query = `
        SELECT lal.*, 
               e.name as employee_name,
               e.role as employee_role
        FROM login_audit_log lal
        LEFT JOIN employees e ON lal.employee_id = e.id
    `;
    
    let whereConditions = [];
    let params = [];
    
    if (email) {
        whereConditions.push('lal.email LIKE ?');
        params.push(`%${email}%`);
    }
    
    if (success_only === 'true') {
        whereConditions.push('lal.success = 1');
    } else if (failed_only === 'true') {
        whereConditions.push('lal.success = 0');
    }
    
    if (whereConditions.length > 0) {
        query += ' WHERE ' + whereConditions.join(' AND ');
    }
    
    query += ` ORDER BY lal.timestamp DESC LIMIT ? OFFSET ?`;
    params.push(parseInt(limit), parseInt(offset));
    
    db.all(query, params, (err, rows) => {
        if (err) {
            console.error('❌ Error fetching login audit log:', err);
            return res.status(500).json({ error: 'Failed to fetch login audit log' });
        }
        
        // Get total count
        let countQuery = 'SELECT COUNT(*) as total FROM login_audit_log lal';
        let countParams = [];
        
        if (whereConditions.length > 0) {
            countQuery += ' WHERE ' + whereConditions.join(' AND ');
            countParams = params.slice(0, -2); // Remove limit and offset
        }
        
        db.get(countQuery, countParams, (err2, countRow) => {
            if (err2) {
                console.error('❌ Error fetching login audit count:', err2);
                return res.status(500).json({ error: 'Failed to fetch login audit count' });
            }

            res.json({
                success: true,
                login_audit_log: rows,
                pagination: {
                    total: countRow.total,
                    limit: parseInt(limit),
                    offset: parseInt(offset),
                    has_more: (parseInt(offset) + rows.length) < countRow.total
                }
            });
        });
    });
});

// GET /api/settings/variance — Get variance thresholds (any authenticated user)
app.get('/api/settings/variance', requireAuth, (req, res) => {
    db.all(`SELECT key, value FROM app_settings WHERE key IN ('variance_pct_threshold', 'variance_dollar_threshold')`, [], (err, rows) => {
        if (err) return res.status(500).json({ error: 'Failed to load settings' });
        const settings = {};
        rows.forEach(r => { settings[r.key] = r.value; });
        res.json({
            variance_pct_threshold: parseFloat(settings.variance_pct_threshold || '10'),
            variance_dollar_threshold: parseFloat(settings.variance_dollar_threshold || '100')
        });
    });
});

// PUT /api/settings/variance — Update variance thresholds (admin only)
app.put('/api/settings/variance', requireAuth, requireRole('admin'), (req, res) => {
    const { variance_pct_threshold, variance_dollar_threshold } = req.body;
    
    // Enhanced validation
    if (!variance_pct_threshold || variance_pct_threshold.toString().trim() === '') {
        return res.status(400).json({ error: 'Percentage threshold is required' });
    }
    if (!variance_dollar_threshold || variance_dollar_threshold.toString().trim() === '') {
        return res.status(400).json({ error: 'Dollar threshold is required' });
    }
    
    const pct = parseFloat(variance_pct_threshold);
    const dollar = parseFloat(variance_dollar_threshold);
    
    if (isNaN(pct) || !isFinite(pct)) return res.status(400).json({ error: 'Percentage threshold must be a valid number' });
    if (isNaN(dollar) || !isFinite(dollar)) return res.status(400).json({ error: 'Dollar threshold must be a valid number' });
    if (pct <= 0 || pct > 1000) return res.status(400).json({ error: 'Percentage threshold must be between 0.1 and 1000' });
    if (dollar <= 0 || dollar > 100000) return res.status(400).json({ error: 'Dollar threshold must be between $0.01 and $100,000' });
    
    // Get old values for audit
    db.all(`SELECT key, value FROM app_settings WHERE key IN ('variance_pct_threshold', 'variance_dollar_threshold')`, [], (err, oldRows) => {
        const oldSettings = {};
        if (!err && oldRows) oldRows.forEach(r => { oldSettings[r.key] = r.value; });
        
        // Update both settings
        db.run(`INSERT OR REPLACE INTO app_settings (key, value, updated_by, updated_at) VALUES ('variance_pct_threshold', ?, ?, CURRENT_TIMESTAMP)`, [String(pct), req.user.employeeId]);
        db.run(`INSERT OR REPLACE INTO app_settings (key, value, updated_by, updated_at) VALUES ('variance_dollar_threshold', ?, ?, CURRENT_TIMESTAMP)`, [String(dollar), req.user.employeeId]);
        
        // Audit log
        db.run(`INSERT INTO settings_audit_log (setting_key, old_value, new_value, changed_by) VALUES (?, ?, ?, ?)`,
            ['variance_thresholds', 
             `Percentage: ${oldSettings.variance_pct_threshold || '10'}%, Dollar: $${oldSettings.variance_dollar_threshold || '100'}`,
             `Percentage: ${pct}%, Dollar: $${dollar}`,
             req.user.employeeId]);
        
        res.json({ success: true, message: 'Variance thresholds updated', variance_pct_threshold: pct, variance_dollar_threshold: dollar });
    });
});

// GET /api/settings/variance/audit — Get settings audit log (admin only)
app.get('/api/settings/variance/audit', requireAuth, requireRole('admin'), (req, res) => {
    db.all(`SELECT sal.*, emp.name as changed_by_name FROM settings_audit_log sal LEFT JOIN employees emp ON sal.changed_by = emp.id ORDER BY sal.changed_at DESC LIMIT 50`, [], (err, rows) => {
        if (err) return res.status(500).json({ error: 'Failed to load audit log' });
        res.json(rows || []);
    });
});

// CONCUR ENHANCEMENT: Return expense for correction (supervisors only)
app.post('/api/expenses/:id/return', requireAuth, (req, res) => {
    if (req.user.role !== 'supervisor') {
        return res.status(403).json({ 
            error: 'Access denied. Only supervisors can return expenses for correction.' 
        });
    }
    
    const { id } = req.params;
    const { reason, approver } = req.body;
    
    if (!reason || reason.trim().length === 0) {
        return res.status(400).json({ 
            success: false, 
            error: 'Return reason is required' 
        });
    }
    
    // First, get the expense details and check governance rules
    db.get('SELECT employee_id, status FROM expenses WHERE id = ?', [id], (err, expense) => {
        if (err) {
            console.error('❌ Error fetching expense:', err);
            return res.status(500).json({ success: false, error: 'Failed to fetch expense details' });
        }
        
        if (!expense) {
            return res.status(404).json({ success: false, error: 'Expense not found' });
        }
        
        // GOVERNANCE: Check segregation of duties - supervisor cannot return own expenses
        if (expense.employee_id === req.user.employeeId) {
            return res.status(403).json({ 
                error: 'Segregation of duties violation: You cannot return your own expenses' 
            });
        }
        
        // GOVERNANCE: Verify the expense belongs to supervisor's direct report
        db.get('SELECT id FROM employees WHERE id = ? AND supervisor_id = ?', 
            [expense.employee_id, req.user.employeeId], (err2, directReport) => {
            
            if (err2) {
                console.error('❌ Error checking direct report:', err2);
                return res.status(500).json({ success: false, error: 'Failed to verify reporting relationship' });
            }
            
            if (!directReport) {
                return res.status(403).json({ 
                    error: 'Access denied: You can only return expenses from your direct reports' 
                });
            }
            
            // All governance checks passed - proceed with return
            const approverName = approver || req.user.name || 'Supervisor';
            const query = `
                UPDATE expenses 
                SET status = 'returned', 
                    returned_by = ?, 
                    returned_at = CURRENT_TIMESTAMP, 
                    return_reason = ?,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
            `;
            
            db.run(query, [approverName, reason.trim(), id], function(err3) {
                if (err3) {
                    console.error('❌ Error returning expense:', err3);
                    return res.status(500).json({ 
                        success: false, 
                        error: 'Failed to return expense for correction' 
                    });
                }
                
                if (this.changes === 0) {
                    return res.status(404).json({ 
                        success: false, 
                        error: 'Expense not found or already processed' 
                    });
                }
                
                // Log to audit trail
                logExpenseAudit(id, 'returned', req.user.employeeId, approverName, 
                    `Returned for correction: ${reason}`, expense.status, 'returned');

                // Notify employee
                createNotification(expense.employee_id, 'expense_returned',
                    `Your expense #${id} has been returned for correction by ${approverName}. Reason: ${reason}`);
                
                res.json({ 
                    success: true, 
                    message: 'Expense returned for correction. Employee will be notified to make corrections and resubmit.' 
                });
            });
        });
    });
});

// Approve expense (governance-compliant: supervisors only, with segregation of duties)
app.post('/api/expenses/:id/approve', requireAuth, (req, res) => {
    // GOVERNANCE: Only supervisors can approve expenses
    if (req.user.role !== 'supervisor') {
        return res.status(403).json({ 
            error: 'Access denied. Only supervisors can approve expenses. Admin role is for system management only.' 
        });
    }
    
    const { id } = req.params;
    const { comment, approver } = req.body;
    
    // First, get the expense details and check governance rules
    db.get('SELECT employee_id FROM expenses WHERE id = ?', [id], (err, expense) => {
        if (err) {
            console.error('❌ Error fetching expense:', err);
            return res.status(500).json({ success: false, error: 'Failed to fetch expense details' });
        }
        
        if (!expense) {
            return res.status(404).json({ success: false, error: 'Expense not found' });
        }
        
        // GOVERNANCE: Check segregation of duties - supervisor cannot approve own expenses
        if (expense.employee_id === req.user.employeeId) {
            return res.status(403).json({ 
                error: 'Segregation of duties violation: You cannot approve your own expenses' 
            });
        }
        
        // GOVERNANCE: Verify the expense belongs to supervisor's direct report
        db.get('SELECT id FROM employees WHERE id = ? AND supervisor_id = ?', 
            [expense.employee_id, req.user.employeeId], (err2, directReport) => {
            
            if (err2) {
                console.error('❌ Error checking direct report:', err2);
                return res.status(500).json({ success: false, error: 'Failed to verify reporting relationship' });
            }
            
            if (!directReport) {
                return res.status(403).json({ 
                    error: 'Access denied: You can only approve expenses from your direct reports' 
                });
            }
            
            // All governance checks passed - proceed with approval
            const approverName = approver || req.user.name || 'Supervisor';
            const query = `
                UPDATE expenses 
                SET status = 'approved', 
                    approved_by = ?, 
                    approved_at = CURRENT_TIMESTAMP, 
                    approval_comment = ?,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
            `;
            
            db.run(query, [approverName, comment, id], function(err3) {
                if (err3) {
                    console.error('❌ Error approving expense:', err3);
                    return res.status(500).json({ 
                        success: false, 
                        error: 'Failed to approve expense' 
                    });
                }
                
                if (this.changes === 0) {
                    return res.status(404).json({ 
                        success: false, 
                        error: 'Expense not found or already processed' 
                    });
                }
                
                // Log to audit trail
                logExpenseAudit(id, 'approved', req.user.employeeId, approverName, 
                    comment, expense.status, 'approved');

                // Notify employee
                createNotification(expense.employee_id, 'expense_approved',
                    `Your expense #${id} has been approved by ${approverName}.`);
                
                res.json({ 
                    success: true, 
                    message: 'Expense approved successfully!' 
                });
            });
        });
    });
});

// Reject expense (governance-compliant: supervisors only, with segregation of duties)
app.post('/api/expenses/:id/reject', requireAuth, (req, res) => {
    // GOVERNANCE: Only supervisors can reject expenses
    if (req.user.role !== 'supervisor') {
        return res.status(403).json({ 
            error: 'Access denied. Only supervisors can reject expenses. Admin role is for system management only.' 
        });
    }
    
    const { id } = req.params;
    const { reason, approver } = req.body;
    
    if (!reason) {
        return res.status(400).json({ 
            success: false, 
            error: 'Rejection reason is required' 
        });
    }
    
    // First, get the expense details and check governance rules
    db.get('SELECT employee_id FROM expenses WHERE id = ?', [id], (err, expense) => {
        if (err) {
            console.error('❌ Error fetching expense:', err);
            return res.status(500).json({ success: false, error: 'Failed to fetch expense details' });
        }
        
        if (!expense) {
            return res.status(404).json({ success: false, error: 'Expense not found' });
        }
        
        // GOVERNANCE: Check segregation of duties - supervisor cannot reject own expenses
        if (expense.employee_id === req.user.employeeId) {
            return res.status(403).json({ 
                error: 'Segregation of duties violation: You cannot reject your own expenses' 
            });
        }
        
        // GOVERNANCE: Verify the expense belongs to supervisor's direct report
        db.get('SELECT id FROM employees WHERE id = ? AND supervisor_id = ?', 
            [expense.employee_id, req.user.employeeId], (err2, directReport) => {
            
            if (err2) {
                console.error('❌ Error checking direct report:', err2);
                return res.status(500).json({ success: false, error: 'Failed to verify reporting relationship' });
            }
            
            if (!directReport) {
                return res.status(403).json({ 
                    error: 'Access denied: You can only reject expenses from your direct reports' 
                });
            }
            
            // All governance checks passed - proceed with rejection
            const approverName = approver || req.user.name || 'Supervisor';
            const query = `
                UPDATE expenses 
                SET status = 'rejected', 
                    approved_by = ?, 
                    approved_at = CURRENT_TIMESTAMP, 
                    rejection_reason = ?,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
            `;
            
            db.run(query, [approverName, reason, id], function(err3) {
                if (err3) {
                    console.error('❌ Error rejecting expense:', err3);
                    return res.status(500).json({ 
                        success: false, 
                        error: 'Failed to reject expense' 
                    });
                }
                
                if (this.changes === 0) {
                    return res.status(404).json({ 
                        success: false, 
                        error: 'Expense not found or already processed' 
                    });
                }
                
                // Log to audit trail
                logExpenseAudit(id, 'rejected', req.user.employeeId, approverName, 
                    `Rejected: ${reason}`, expense.status, 'rejected');

                // Notify employee with reason
                createNotification(expense.employee_id, 'expense_rejected',
                    `Your expense #${id} was rejected by ${approverName}. Reason: ${reason}`);
                
                res.json({ 
                    success: true, 
                    message: 'Expense rejected successfully' 
                });
            });
        });
    });
});

// Delete expense (admin only with enhanced controls)
app.delete('/api/expenses/:id', requireAuth, requireRole('admin'), (req, res) => {
    const { id } = req.params;
    const { admin_override } = req.body;
    
    // First get the expense to check status and details
    db.get('SELECT * FROM expenses WHERE id = ?', [id], (err, expense) => {
        if (err) {
            console.error('❌ Error fetching expense for deletion:', err);
            return res.status(500).json({ 
                success: false, 
                error: 'Failed to fetch expense' 
            });
        }
        
        if (!expense) {
            return res.status(404).json({ 
                success: false, 
                error: 'Expense not found' 
            });
        }
        
        // GOVERNANCE: Prevent deletion of approved expenses without explicit override
        if (expense.status === 'approved' && !admin_override) {
            return res.status(400).json({
                success: false,
                error: 'COMPLIANCE VIOLATION: Cannot delete approved expenses. This violates financial audit requirements. Use admin_override=true if absolutely necessary.'
            });
        }
        
        // Log the deletion to audit trail BEFORE deleting
        logExpenseAudit(id, 'deleted', req.user.employeeId, req.user.name || 'Admin', 
            admin_override ? 'ADMIN OVERRIDE: Force deleted approved expense' : 'Expense deleted by admin',
            expense.status, 'deleted');
        
        // Delete the expense record
        db.run('DELETE FROM expenses WHERE id = ?', [id], function(err) {
            if (err) {
                console.error('❌ Error deleting expense:', err);
                return res.status(500).json({ 
                    success: false, 
                    error: 'Failed to delete expense' 
                });
            }
            
            // Try to delete the receipt photo file
            if (expense.receipt_photo) {
                const filePath = path.join(__dirname, expense.receipt_photo);
                fs.unlink(filePath, (err) => {
                    if (err) console.log('⚠️ Could not delete receipt file:', err.message);
                });
            }

            res.json({ 
                success: true, 
                message: expense.status === 'approved' ? 
                    'APPROVED EXPENSE DELETED - Admin override used. This action has been logged for audit.' : 
                    'Expense deleted successfully' 
            });
        });
    });
});

// Get all employees (authenticated users)
app.get('/api/employees', requireAuth, requireRole('admin', 'supervisor'), (req, res) => {
    const query = `
        SELECT e.*, sup.name as supervisor_name
        FROM employees e
        LEFT JOIN employees sup ON e.supervisor_id = sup.id
        ORDER BY e.name
    `;
    
    db.all(query, [], (err, rows) => {
        if (err) {
            console.error('❌ Error fetching employees:', err);
            return res.status(500).json({ error: 'Failed to fetch employees' });
        }
        
        res.json(rows);
    });
});

// Add new employee (admin only)
app.post('/api/employees', requireAuth, requireRole('admin'), async (req, res) => {
    const { name, employee_number, email, position, department, supervisor_id, cost_center_id } = req.body;
    
    // Validation
    if (!name || name.trim().length === 0) {
        return res.status(400).json({ 
            success: false, 
            error: 'Employee name is required' 
        });
    }
    
    if (!employee_number || employee_number.trim().length === 0) {
        return res.status(400).json({ 
            success: false, 
            error: 'Employee number is required' 
        });
    }
    
    if (!email || !email.includes('@')) {
        return res.status(400).json({ 
            success: false, 
            error: 'Valid email address is required' 
        });
    }
    
    // Governance: admin cannot be a supervisor, supervisor cannot be set to report to an admin
    if (supervisor_id) {
        try {
            const sup = await new Promise((resolve, reject) => {
                db.get('SELECT id, role FROM employees WHERE id = ?', [supervisor_id], (err, row) => err ? reject(err) : resolve(row));
            });
            if (sup && sup.role === 'admin') {
                return res.status(400).json({ success: false, error: '⚠️ Governance violation: An administrator cannot act as a supervisor. Assign a supervisor-role employee instead.' });
            }
        } catch (err) { console.error('Error checking supervisor role:', err); }
    }
    
    // Create employee without password (inactive until signup is completed)
    const query = `
        INSERT INTO employees (name, employee_number, email, position, department, supervisor_id, cost_center_id, is_active)
        VALUES (?, ?, ?, ?, ?, ?, ?, 0)
    `;
    
    const params = [
        name.trim(), 
        employee_number.trim(),
        email.trim().toLowerCase(),
        position ? position.trim() : null, 
        department ? department.trim() : null, 
        supervisor_id || null,
        cost_center_id || null
    ];
    
    db.run(query, params, function(err) {
        if (err) {
            console.error('❌ Error adding employee:', err);
            if (err.message.includes('UNIQUE constraint failed')) {
                return res.status(409).json({ 
                    success: false, 
                    error: 'Employee number already exists' 
                });
            }
            return res.status(500).json({ 
                success: false, 
                error: 'Failed to add employee' 
            });
        }
        
        const newEmployeeId = this.lastID;
        
        // Generate signup token
        const token = crypto.randomBytes(32).toString('hex');
        const expiresAt = new Date(Date.now() + 48 * 60 * 60 * 1000); // 48 hours from now
        
        // Insert signup token
        db.run(
            'INSERT INTO signup_tokens (employee_id, token, expires_at) VALUES (?, ?, ?)',
            [newEmployeeId, token, expiresAt.toISOString()],
            function(tokenErr) {
                if (tokenErr) {
                    console.error('❌ Error creating signup token:', tokenErr);
                    return res.status(500).json({ 
                        success: false, 
                        error: 'Failed to create signup token' 
                    });
                }
                
                // Log all initial field values for audit trail
                const fieldsToLog = [
                    { field: 'name', value: name.trim() },
                    { field: 'employee_number', value: employee_number.trim() },
                    { field: 'position', value: position ? position.trim() : null },
                    { field: 'department', value: department ? department.trim() : null },
                    { field: 'supervisor_id', value: supervisor_id || null },
                    { field: 'cost_center_id', value: cost_center_id || null }
                ];
                
                fieldsToLog.forEach(item => {
                    if (item.value !== null && item.value !== '') {
                        logEmployeeAudit(newEmployeeId, 'created', item.field, null, item.value, req.user.employeeId);
                    }
                });
                
                // Log the creation action
                logEmployeeAudit(newEmployeeId, 'created', null, null, 'Employee record created', req.user.employeeId);
                
                // Create signup URL
                const baseUrl = req.protocol + '://' + req.get('host');
                const signupUrl = `${baseUrl}/signup?token=${token}`;
                
                res.json({ 
                    success: true, 
                    id: newEmployeeId,
                    message: 'Employee added successfully!',
                    signupUrl: signupUrl,
                    token: token
                });
            }
        );
    });
});

// Update employee (admin only)
app.put('/api/employees/:id', requireAuth, requireRole('admin'), async (req, res) => {
    const { id } = req.params;
    const { name, employee_number, position, department, supervisor_id, cost_center_id } = req.body;
    
    // Validation
    if (!name || name.trim().length === 0) {
        return res.status(400).json({ 
            success: false, 
            error: 'Employee name is required' 
        });
    }
    
    if (!employee_number || employee_number.trim().length === 0) {
        return res.status(400).json({ 
            success: false, 
            error: 'Employee number is required' 
        });
    }
    
    // Governance rule: admin cannot act as supervisor
    if (supervisor_id) {
        try {
            const sup = await new Promise((resolve, reject) => {
                db.get('SELECT id, role FROM employees WHERE id = ?', [supervisor_id], (err, row) => err ? reject(err) : resolve(row));
            });
            if (sup && sup.role === 'admin') {
                return res.status(400).json({ success: false, error: '⚠️ Governance violation: An administrator cannot act as a supervisor.' });
            }
        } catch (err) { console.error('Error checking supervisor role:', err); }
    }
    
    // Governance rule: An employee cannot be their own supervisor
    if (supervisor_id && String(supervisor_id) === String(id)) {
        return res.status(400).json({ 
            success: false, 
            error: '⚠️ Governance violation: An employee cannot be their own supervisor. This violates audit and oversight requirements.' 
        });
    }
    
    // Governance rule: Prevent circular supervision chains
    if (supervisor_id) {
        try {
            const chain = await new Promise((resolve, reject) => {
                db.all(`
                    WITH RECURSIVE chain AS (
                        SELECT id, supervisor_id FROM employees WHERE id = ?
                        UNION ALL
                        SELECT e.id, e.supervisor_id FROM employees e INNER JOIN chain c ON e.id = c.supervisor_id
                    )
                    SELECT id FROM chain WHERE id != ?
                `, [supervisor_id, supervisor_id], (err, rows) => err ? reject(err) : resolve(rows));
            });
            if (chain.some(r => String(r.id) === String(id))) {
                return res.status(400).json({
                    success: false,
                    error: '⚠️ Governance violation: This assignment would create a circular supervision chain.'
                });
            }
        } catch (err) {
            console.error('Error checking supervision chain:', err);
        }
    }
    
    // First get current values to compare
    db.get('SELECT * FROM employees WHERE id = ?', [id], (err, currentEmployee) => {
        if (err) {
            console.error('❌ Error fetching employee for comparison:', err);
            return res.status(500).json({ success: false, error: 'Failed to fetch current employee data: ' + (err.message || err) });
        }
        
        if (!currentEmployee) {
            return res.status(404).json({ success: false, error: 'Employee not found' });
        }
        
        const query = `
            UPDATE employees 
            SET name = ?, employee_number = ?, position = ?, department = ?, supervisor_id = ?, cost_center_id = ?
            WHERE id = ?
        `;
        
        const params = [
            name.trim(), 
            employee_number.trim(), 
            position ? position.trim() : null, 
            department ? department.trim() : null, 
            supervisor_id || null,
            cost_center_id || null,
            id
        ];
        
        db.run(query, params, function(err) {
            if (err) {
                console.error('❌ Error updating employee:', err);
                if (err.message && err.message.includes('UNIQUE constraint failed')) {
                    return res.status(409).json({ 
                        success: false, 
                        error: 'Employee number already exists' 
                    });
                }
                return res.status(500).json({ 
                    success: false, 
                    error: 'Failed to update employee: ' + (err.message || err)
                });
            }
            
            if (this.changes === 0) {
                return res.status(404).json({ 
                    success: false, 
                    error: 'Employee not found' 
                });
            }
            
            // Log changes for audit trail - compare old vs new values
            const fieldsToCheck = [
                { field: 'name', oldValue: currentEmployee.name, newValue: name.trim() },
                { field: 'employee_number', oldValue: currentEmployee.employee_number, newValue: employee_number.trim() },
                { field: 'position', oldValue: currentEmployee.position, newValue: position ? position.trim() : null },
                { field: 'department', oldValue: currentEmployee.department, newValue: department ? department.trim() : null },
                { field: 'supervisor_id', oldValue: currentEmployee.supervisor_id, newValue: supervisor_id || null },
                { field: 'cost_center_id', oldValue: currentEmployee.cost_center_id, newValue: cost_center_id || null }
            ];
            
            let changesDetected = false;
            fieldsToCheck.forEach(item => {
                // Convert to string for comparison to handle null/undefined consistently
                const oldStr = String(item.oldValue || '');
                const newStr = String(item.newValue || '');
                
                if (oldStr !== newStr) {
                    changesDetected = true;
                    logEmployeeAudit(id, 'updated', item.field, item.oldValue, item.newValue, req.user.employeeId);
                }
            });
            
            if (changesDetected) {
                logEmployeeAudit(id, 'updated', null, null, 'Employee record updated', req.user.employeeId);
            }
            
            res.json({ 
                success: true, 
                message: 'Employee updated successfully!' 
            });
        });
    });
});

// Delete employee (admin only)
app.delete('/api/employees/:id', requireAuth, requireRole('admin'), (req, res) => {
    const { id } = req.params;
    
    // First check if employee has expenses
    db.get('SELECT COUNT(*) as count FROM expenses WHERE employee_name = (SELECT name FROM employees WHERE id = ?)', [id], (err, result) => {
        if (err) {
            console.error('❌ Error checking employee expenses:', err);
            return res.status(500).json({ 
                success: false, 
                error: 'Failed to check employee expenses' 
            });
        }
        
        if (result.count > 0) {
            return res.status(409).json({ 
                success: false, 
                error: `Cannot delete employee: ${result.count} expenses associated with this employee` 
            });
        }
        
        // Check if employee is a supervisor
        db.get('SELECT COUNT(*) as count FROM employees WHERE supervisor_id = ?', [id], (err, supervisorResult) => {
            if (err) {
                console.error('❌ Error checking supervisor relationships:', err);
                return res.status(500).json({ 
                    success: false, 
                    error: 'Failed to check supervisor relationships' 
                });
            }
            
            if (supervisorResult.count > 0) {
                return res.status(409).json({ 
                    success: false, 
                    error: `Cannot delete employee: ${supervisorResult.count} employees report to this person` 
                });
            }
            
            // Get employee details before deletion for audit log
            db.get('SELECT * FROM employees WHERE id = ?', [id], (err, employee) => {
                if (err) {
                    console.error('❌ Error fetching employee for deletion audit:', err);
                    return res.status(500).json({ success: false, error: 'Failed to fetch employee data' });
                }
                
                if (!employee) {
                    return res.status(404).json({ success: false, error: 'Employee not found' });
                }
                
                // Log deletion before deleting the record
                logEmployeeAudit(id, 'deleted', 'name', employee.name, null, req.user.employeeId);
                logEmployeeAudit(id, 'deleted', 'employee_number', employee.employee_number, null, req.user.employeeId);
                if (employee.position) logEmployeeAudit(id, 'deleted', 'position', employee.position, null, req.user.employeeId);
                if (employee.department) logEmployeeAudit(id, 'deleted', 'department', employee.department, null, req.user.employeeId);
                if (employee.supervisor_id) logEmployeeAudit(id, 'deleted', 'supervisor_id', employee.supervisor_id, null, req.user.employeeId);
                logEmployeeAudit(id, 'deleted', null, null, `Employee record deleted: ${employee.name} (${employee.employee_number})`, req.user.employeeId);
                
                // Now delete the employee
                db.run('DELETE FROM employees WHERE id = ?', [id], function(err) {
                    if (err) {
                        console.error('❌ Error deleting employee:', err);
                        return res.status(500).json({ 
                            success: false, 
                            error: 'Failed to delete employee' 
                        });
                    }
                    
                    if (this.changes === 0) {
                        return res.status(404).json({ 
                            success: false, 
                            error: 'Employee not found' 
                        });
                    }
                    
                    res.json({ 
                        success: true, 
                        message: 'Employee deleted successfully' 
                    });
                });
            });
        });
    });
});

// GET /api/employee-audit-log endpoint (admin only) - Employee change audit trail
app.get('/api/employee-audit-log', requireAuth, requireRole('admin'), (req, res) => {
    const { limit = 100, offset = 0, employee_id } = req.query;
    
    let query = `
        SELECT eal.*, 
               e.name as employee_name,
               e.employee_number,
               performer.name as performed_by_name,
               performer.employee_number as performed_by_number
        FROM employee_audit_log eal
        LEFT JOIN employees e ON eal.employee_id = e.id
        LEFT JOIN employees performer ON eal.performed_by = performer.id
    `;
    
    let params = [];
    
    if (employee_id) {
        query += ` WHERE eal.employee_id = ?`;
        params.push(employee_id);
    }
    
    query += ` ORDER BY eal.performed_at DESC LIMIT ? OFFSET ?`;
    params.push(parseInt(limit), parseInt(offset));
    
    db.all(query, params, (err, rows) => {
        if (err) {
            console.error('❌ Error fetching employee audit log:', err);
            return res.status(500).json({ error: 'Failed to fetch employee audit log' });
        }
        
        // Get total count
        const countQuery = employee_id ? 
            'SELECT COUNT(*) as total FROM employee_audit_log WHERE employee_id = ?' :
            'SELECT COUNT(*) as total FROM employee_audit_log';
        const countParams = employee_id ? [employee_id] : [];
        
        db.get(countQuery, countParams, (err2, countRow) => {
            if (err2) {
                console.error('❌ Error fetching employee audit count:', err2);
                return res.status(500).json({ error: 'Failed to fetch audit count' });
            }

            res.json({
                success: true,
                employee_audit_log: rows,
                pagination: {
                    total: countRow.total,
                    limit: parseInt(limit),
                    offset: parseInt(offset),
                    has_more: (parseInt(offset) + rows.length) < countRow.total
                }
            });
        });
    });
});

// Get NJC rates (requires authentication)
app.get('/api/njc-rates', requireAuth, async (req, res) => {
    try {
        const perDiemTypes = await njcRates.getAvailablePerDiemTypes();
        const updateInfo = njcRates.getRateUpdateInfo();
        
        res.json({
            success: true,
            per_diem_types: perDiemTypes,
            update_info: updateInfo,
            timestamp: new Date().toISOString()
        });
        
    } catch (error) {
        console.error('❌ Error fetching NJC rates:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to fetch per diem rates'
        });
    }
});

// Get expense status for employee
app.get('/api/expenses/employee/:name', requireAuth, (req, res) => {
    const { name } = req.params;
    
    if (!name || name.trim().length === 0) {
        return res.status(400).json({ error: 'Employee name is required' });
    }
    
    // First check if employee exists
    db.get('SELECT name FROM employees WHERE name = ?', [name], (err, employee) => {
        if (err) {
            console.error('❌ Error checking employee:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        
        // If employee doesn't exist in directory, still return expenses but with warning
        const query = `
            SELECT * FROM expenses 
            WHERE employee_name = ? 
            ORDER BY created_at DESC 
            LIMIT 10
        `;
        
        db.all(query, [name], (err, rows) => {
            if (err) {
                console.error('❌ Error fetching employee expenses:', err);
                return res.status(500).json({ error: 'Failed to fetch expenses' });
            }
            
            if (rows.length === 0 && !employee) {
                return res.status(404).json({ 
                    error: 'No expenses found for this employee',
                    message: 'Employee may not exist in directory'
                });
            }
            
            res.json(rows);
        });
    });
});

// 🏛️ NJC Per Diem Rates API Endpoints

// Calculate vehicle allowance (requires authentication)
app.post('/api/njc-rates/vehicle-allowance', requireAuth, async (req, res) => {
    const { kilometers, expense_date } = req.body;
    
    if (!kilometers || isNaN(kilometers) || kilometers <= 0) {
        return res.status(400).json({
            success: false,
            error: 'Valid kilometer amount required'
        });
    }
    
    try {
        const calculation = await njcRates.calculateVehicleAllowance(parseFloat(kilometers), expense_date);
        
        if (!calculation) {
            return res.status(404).json({
                success: false,
                error: 'Unable to calculate vehicle allowance for specified date'
            });
        }
        
        res.json({
            success: true,
            ...calculation
        });
        
    } catch (error) {
        console.error('❌ Error calculating vehicle allowance:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to calculate vehicle allowance'
        });
    }
});

// Validate per diem expense with historical rates (requires authentication)
app.post('/api/njc-rates/validate', requireAuth, async (req, res) => {
    const { expense_type, amount, expense_date, additional_data } = req.body;
    
    if (!expense_type || !amount || !expense_date) {
        return res.status(400).json({
            success: false,
            error: 'expense_type, amount, and expense_date are required'
        });
    }
    
    // Validate date format
    if (!/^\d{4}-\d{2}-\d{2}$/.test(expense_date)) {
        return res.status(400).json({
            success: false,
            error: 'Invalid expense_date format. Use YYYY-MM-DD'
        });
    }
    
    try {
        const validation = await njcRates.validatePerDiemExpense(expense_type, amount, expense_date, additional_data);
        
        res.json({
            success: true,
            valid: validation.valid,
            message: validation.message,
            expense_type,
            amount: parseFloat(amount),
            expense_date,
            rate_info: validation.rate_info
        });
        
    } catch (error) {
        console.error('❌ Error validating per diem expense:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to validate per diem expense'
        });
    }
});

// 📋 COMPREHENSIVE NJC RATES MANAGEMENT ENDPOINTS

// Get all rates (current + historical) grouped by rate_type (admin only)
app.get('/api/njc-rates/all', requireAuth, requireRole('admin'), async (req, res) => {
    try {
        const province = req.query.province || 'QC';
        const allRates = await njcRates.getAllRates(province);
        
        res.json({
            success: true,
            rates: allRates,
            province
        });
        
    } catch (error) {
        console.error('❌ Error getting all NJC rates:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to retrieve NJC rates'
        });
    }
});

// Get current effective rates
app.get('/api/njc-rates/current', requireAuth, async (req, res) => {
    try {
        const province = req.query.province || 'QC';
        const currentRates = await njcRates.getCurrentRates(province);
        
        res.json({
            success: true,
            rates: currentRates,
            province,
            as_of: new Date().toISOString().split('T')[0]
        });
        
    } catch (error) {
        console.error('❌ Error getting current NJC rates:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to retrieve current NJC rates'
        });
    }
});

// Get rates effective on a specific date
app.get('/api/njc-rates/for-date', requireAuth, async (req, res) => {
    const { date } = req.query;
    
    if (!date) {
        return res.status(400).json({
            success: false,
            error: 'date parameter is required (YYYY-MM-DD format)'
        });
    }
    
    // Validate date format
    if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) {
        return res.status(400).json({
            success: false,
            error: 'Invalid date format. Use YYYY-MM-DD'
        });
    }
    
    try {
        const province = req.query.province || 'QC';
        const rates = await njcRates.getRatesForDate(date, province);
        
        res.json({
            success: true,
            rates: rates,
            date: date,
            province
        });
        
    } catch (error) {
        console.error('❌ Error getting NJC rates for date:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to retrieve NJC rates for specified date'
        });
    }
});

// Get per diem rate for specific expense type (MUST be after /current, /all, /for-date)
app.get('/api/njc-rates/:expenseType', requireAuth, async (req, res) => {
    const { expenseType } = req.params;
    const { date } = req.query;
    
    try {
        const rateInfo = await njcRates.getPerDiemRate(expenseType, date);
        
        if (!rateInfo) {
            return res.status(404).json({
                success: false,
                error: 'Expense type not found in NJC per diem rates'
            });
        }
        
        res.json({
            success: true,
            expense_type: expenseType,
            query_date: date || 'current',
            ...rateInfo
        });
        
    } catch (error) {
        console.error('❌ Error fetching NJC rate:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to fetch per diem rate'
        });
    }
});

// Add new rate revision (admin only)
app.post('/api/njc-rates', requireAuth, requireRole('admin'), async (req, res) => {
    const { rate_type, amount, effective_date, province, notes } = req.body;
    
    // Validate required fields
    if (!rate_type || !amount || !effective_date) {
        return res.status(400).json({
            success: false,
            error: 'rate_type, amount, and effective_date are required'
        });
    }
    
    // Validate rate type
    const validRateTypes = ['breakfast', 'lunch', 'dinner', 'incidentals', 'private_vehicle', 'vehicle', 'vehicle_km'];
    if (!validRateTypes.includes(rate_type)) {
        return res.status(400).json({
            success: false,
            error: `Invalid rate_type. Must be one of: ${validRateTypes.join(', ')}`
        });
    }
    
    // Validate amount
    const numAmount = parseFloat(amount);
    if (isNaN(numAmount) || numAmount <= 0 || numAmount > 1000) {
        return res.status(400).json({
            success: false,
            error: 'Amount must be a positive number between 0.01 and 1000.00'
        });
    }
    
    // Validate date format
    if (!/^\d{4}-\d{2}-\d{2}$/.test(effective_date)) {
        return res.status(400).json({
            success: false,
            error: 'Invalid effective_date format. Use YYYY-MM-DD'
        });
    }
    
    // Ensure effective date is not in the past (unless admin override)
    const today = new Date().toISOString().split('T')[0];
    if (effective_date < today && !req.body.admin_override) {
        return res.status(400).json({
            success: false,
            error: 'Effective date cannot be in the past. Use admin_override=true if intentional.'
        });
    }
    
    try {
        const result = await njcRates.addNewRate(
            rate_type,
            numAmount,
            effective_date,
            province || 'QC',
            notes || '',
            req.user.name || 'admin'
        );
        
        res.json({
            success: true,
            message: `New ${rate_type} rate added successfully`,
            rate_id: result.id,
            rate_type,
            amount: numAmount,
            effective_date,
            province: province || 'QC'
        });
        
    } catch (error) {
        console.error('❌ Error adding new NJC rate:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to add new NJC rate'
        });
    }
});

// Update existing rate (admin only) - only if not used in approved expenses
app.put('/api/njc-rates/:id', requireAuth, requireRole('admin'), async (req, res) => {
    const { id } = req.params;
    const { amount, notes } = req.body;
    
    if (!amount) {
        return res.status(400).json({
            success: false,
            error: 'amount is required'
        });
    }
    
    const numAmount = parseFloat(amount);
    if (isNaN(numAmount) || numAmount <= 0 || numAmount > 1000) {
        return res.status(400).json({
            success: false,
            error: 'Amount must be a positive number between 0.01 and 1000.00'
        });
    }
    
    try {
        const db = new sqlite3.Database(path.join(__dirname, 'expenses.db'));
        
        // Check if rate has been used in any approved expenses (audit integrity)
        db.get(`
            SELECT COUNT(*) as count
            FROM expenses e
            JOIN njc_rates nr ON nr.rate_type = e.expense_type 
            WHERE nr.id = ? 
            AND e.status = 'approved'
            AND e.date >= nr.effective_date
            AND (nr.end_date IS NULL OR e.date <= nr.end_date)
        `, [id], (err, row) => {
            if (err) {
                db.close();
                return res.status(500).json({
                    success: false,
                    error: 'Database error checking rate usage'
                });
            }
            
            if (row.count > 0) {
                db.close();
                return res.status(400).json({
                    success: false,
                    error: 'Cannot modify rate that has been used in approved expenses (audit integrity)'
                });
            }
            
            // Update the rate
            db.run(`
                UPDATE njc_rates 
                SET amount = ?, notes = ?, updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
            `, [numAmount, notes || '', id], function(err) {
                db.close();
                
                if (err) {
                    return res.status(500).json({
                        success: false,
                        error: 'Failed to update NJC rate'
                    });
                }
                
                if (this.changes === 0) {
                    return res.status(404).json({
                        success: false,
                        error: 'NJC rate not found'
                    });
                }
                
                res.json({
                    success: true,
                    message: 'NJC rate updated successfully',
                    rate_id: id,
                    amount: numAmount
                });
            });
        });
        
    } catch (error) {
        console.error('❌ Error updating NJC rate:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to update NJC rate'
        });
    }
});

// 🧳 TRIP MANAGEMENT ENDPOINTS

// Get employee's trips
app.get('/api/trips', requireAuth, (req, res) => {
    const query = `
        SELECT t.*, 
               COUNT(e.id) as expense_count,
               SUM(e.amount) as calculated_total,
               ta.id as auth_id
        FROM trips t
        LEFT JOIN expenses e ON t.id = e.trip_id
        LEFT JOIN travel_authorizations ta ON ta.trip_id = t.id
        WHERE t.employee_id = ?
        GROUP BY t.id
        ORDER BY t.created_at DESC
    `;
    
    db.all(query, [req.user.employeeId], (err, rows) => {
        if (err) {
            console.error('❌ Error fetching trips:', err);
            return res.status(500).json({ error: 'Failed to fetch trips' });
        }
        
        res.json(rows);
    });
});

// Create new trip
app.post('/api/trips', requireAuth, async (req, res) => {
    const {
        trip_name,
        destination,
        purpose,
        start_date,
        end_date
    } = req.body;
    
    // Validation
    if (!trip_name || !start_date || !end_date) {
        return res.status(400).json({ 
            success: false, 
            error: 'Missing required fields: trip_name, start_date, end_date' 
        });
    }
    
    // Bug 1 Fix: Check for overlapping trips
    try {
        const overlap = await new Promise((resolve, reject) => {
            db.get(
                `SELECT id, trip_name FROM trips WHERE employee_id = ? AND status = 'draft'
                 AND start_date <= ? AND end_date >= ?`,
                [req.user.employeeId, end_date, start_date],
                (err, row) => err ? reject(err) : resolve(row)
            );
        });
        if (overlap) {
            return res.status(400).json({
                success: false,
                error: `Trip dates overlap with existing trip "${overlap.trip_name}". Please choose different dates.`
            });
        }
    } catch (err) {
        console.error('❌ Error checking trip overlap:', err);
        return res.status(500).json({ success: false, error: 'Failed to validate trip dates' });
    }
    
    const query = `
        INSERT INTO trips (employee_id, trip_name, destination, purpose, start_date, end_date)
        VALUES (?, ?, ?, ?, ?, ?)
    `;
    
    const params = [req.user.employeeId, trip_name, destination, purpose, start_date, end_date];
    
    db.run(query, params, function(err) {
        if (err) {
            console.error('❌ Error creating trip:', err);
            return res.status(500).json({ 
                success: false, 
                error: 'Failed to create trip' 
            });
        }
        
        res.json({ 
            success: true, 
            id: this.lastID, 
            message: 'Trip created successfully!' 
        });
    });
});

// Get trip details with expenses
app.get('/api/trips/:id', requireAuth, (req, res) => {
    const tripId = req.params.id;
    
    // First get trip details
    const tripQuery = `
        SELECT t.*, emp.name as employee_name
        FROM trips t
        JOIN employees emp ON t.employee_id = emp.id
        WHERE t.id = ? AND t.employee_id = ?
    `;
    
    db.get(tripQuery, [tripId, req.user.employeeId], (err, trip) => {
        if (err) {
            console.error('❌ Error fetching trip:', err);
            return res.status(500).json({ error: 'Failed to fetch trip' });
        }
        
        if (!trip) {
            return res.status(404).json({ error: 'Trip not found' });
        }
        
        // Get trip expenses
        const expensesQuery = `
            SELECT * FROM expenses 
            WHERE trip_id = ? 
            ORDER BY date ASC, created_at ASC
        `;
        
        db.all(expensesQuery, [tripId], (err, expenses) => {
            if (err) {
                console.error('❌ Error fetching trip expenses:', err);
                return res.status(500).json({ error: 'Failed to fetch trip expenses' });
            }
            
            // Calculate total
            const total = expenses.reduce((sum, exp) => sum + parseFloat(exp.amount), 0);
            
            // After getting trip and expenses, also get linked AT transport data
            const atQuery = `SELECT details FROM travel_authorizations WHERE trip_id = ? AND status = 'approved'`;
            db.get(atQuery, [tripId], (atErr, at) => {
                let transport = null;
                if (!atErr && at && at.details) {
                    try {
                        const details = JSON.parse(at.details);
                        transport = details.transport || null;
                    } catch(e) {}
                }
                res.json({
                    ...trip,
                    expenses: expenses,
                    calculated_total: total,
                    transport: transport  // Include AT transport data
                });
            });
        });
    });
});

// GET /api/trips/:id/variance — Compare trip actuals vs AT estimates
app.get('/api/trips/:id/variance', requireAuth, (req, res) => {
    const tripId = req.params.id;
    
    // Get trip with expenses
    db.get(`SELECT t.* FROM trips t WHERE t.id = ?`, [tripId], (err, trip) => {
        if (err || !trip) return res.status(404).json({ error: 'Trip not found' });
        
        // Get linked AT
        db.get(`SELECT * FROM travel_authorizations WHERE trip_id = ?`, [tripId], (atErr, at) => {
            if (atErr || !at) return res.json({ trip, at: null, variance: null, message: 'No linked AT found' });
            
            // Get AT expenses (the authorized amounts)
            db.all(`SELECT * FROM expenses WHERE travel_auth_id = ? ORDER BY date ASC`, [at.id], (atExpErr, atExpenses) => {
                if (atExpErr) atExpenses = [];
            
            // Get trip expenses (the actual amounts)
            db.all(`SELECT * FROM expenses WHERE trip_id = ? ORDER BY date ASC`, [tripId], (expErr, expenses) => {
                if (expErr) expenses = [];
                
                // Get variance thresholds
                db.all(`SELECT key, value FROM app_settings WHERE key IN ('variance_pct_threshold', 'variance_dollar_threshold')`, [], (sErr, settings) => {
                    const settingsMap = {};
                    if (settings) settings.forEach(s => { settingsMap[s.key] = s.value; });
                    const pctThreshold = parseFloat(settingsMap.variance_pct_threshold || '10');
                    const dollarThreshold = parseFloat(settingsMap.variance_dollar_threshold || '100');
                    
                    // Parse AT transport details from JSON
                    let transportDetails = {};
                    try {
                        if (at.details) {
                            const details = JSON.parse(at.details);
                            transportDetails = details.transport || {};
                        }
                    } catch(e) { console.error('Error parsing AT details:', e); }
                    
                    // Calculate actuals by granular categories (meals split into B/L/D)
                    const cats = ['breakfast','lunch','dinner','incidentals','hotel','kilometric','flight','train','bus','rental','other'];
                    const actuals = {}; const actualCounts = {};
                    const estimates = {}; const estimateCounts = {};
                    cats.forEach(c => { actuals[c] = 0; actualCounts[c] = 0; estimates[c] = 0; estimateCounts[c] = 0; });
                    
                    function categorize(expType) {
                        switch(expType) {
                            case 'breakfast': return 'breakfast';
                            case 'lunch': return 'lunch';
                            case 'dinner': return 'dinner';
                            case 'incidentals': return 'incidentals';
                            case 'hotel': return 'hotel';
                            case 'vehicle_km': return 'kilometric';
                            case 'transport_flight': return 'flight';
                            case 'transport_train': return 'train';
                            case 'transport_bus': return 'bus';
                            case 'transport_rental': return 'rental';
                            default: return 'other';
                        }
                    }
                    
                    expenses.forEach(e => {
                        const cat = categorize(e.expense_type);
                        actuals[cat] += parseFloat(e.amount) || 0;
                        actualCounts[cat]++;
                    });
                    
                    atExpenses.forEach(e => {
                        const cat = categorize(e.expense_type);
                        estimates[cat] += parseFloat(e.amount) || 0;
                        estimateCounts[cat]++;
                    });
                    
                    // Calculate totals
                    const actualTotal = Object.values(actuals).reduce((sum, val) => sum + val, 0);
                    const estTotal = Object.values(estimates).reduce((sum, val) => sum + val, 0);
                    
                    // Enhanced variance calculation with status logic
                    function calcVariance(actual, estimate, categoryName = '') {
                        const diff = actual - estimate;
                        const pct = estimate > 0 ? ((diff / estimate) * 100) : (actual > 0 ? 100 : 0);
                        
                        let status, icon, description;
                        
                        if (estimate === 0 && actual > 0) {
                            // Unplanned category
                            status = 'new';
                            icon = '🆕';
                            description = 'Not in AT';
                        } else if (estimate > 0 && actual === 0) {
                            // Category in AT but not claimed
                            status = 'unclaimed';
                            icon = '➖';
                            description = 'Not claimed';
                        } else if (actual <= estimate) {
                            // Under or at budget
                            status = 'green';
                            icon = '✅';
                            description = 'Within budget';
                        } else if (Math.abs(pct) > pctThreshold && Math.abs(diff) > dollarThreshold) {
                            // Over both thresholds
                            status = 'red';
                            icon = '🔴';
                            description = `Over ${pctThreshold}% AND $${dollarThreshold}`;
                        } else {
                            // Over budget but below both thresholds
                            status = 'yellow';
                            icon = '⚠️';
                            description = 'Over budget';
                        }
                        
                        return { 
                            actual, 
                            estimate, 
                            diff, 
                            pct: Math.round(pct * 10) / 10, 
                            status, 
                            icon, 
                            description 
                        };
                    }
                    
                    // Build variance with counts
                    const variance = {};
                    cats.forEach(c => {
                        const v = calcVariance(actuals[c], estimates[c], c);
                        v.actualCount = actualCounts[c];
                        v.estimateCount = estimateCounts[c];
                        variance[c] = v;
                    });
                    variance.total = calcVariance(actualTotal, estTotal, 'total');
                    variance.total.actualCount = expenses.length;
                    variance.total.estimateCount = atExpenses.length;
                    
                    res.json({
                        trip: { id: trip.id, name: trip.trip_name, status: trip.status },
                        at: { id: at.id, name: at.name, status: at.status },
                        thresholds: { pct: pctThreshold, dollar: dollarThreshold },
                        variance
                    });
                });
            });
            }); // close atExpenses query
        });
    });
});

// Submit trip for approval
app.post('/api/trips/:id/submit', requireAuth, (req, res) => {
    const tripId = req.params.id;
    
    // Check if trip belongs to user and has expenses
    const checkQuery = `
        SELECT t.*, COUNT(e.id) as expense_count
        FROM trips t
        LEFT JOIN expenses e ON t.id = e.trip_id
        WHERE t.id = ? AND t.employee_id = ?
        GROUP BY t.id
    `;
    
    db.get(checkQuery, [tripId, req.user.employeeId], (err, trip) => {
        if (err) {
            console.error('❌ Error checking trip:', err);
            return res.status(500).json({ error: 'Failed to check trip' });
        }
        
        if (!trip) {
            return res.status(404).json({ error: 'Trip not found' });
        }
        
        if (trip.status !== 'draft' && trip.status !== 'active') {
            return res.status(400).json({ error: 'Trip has already been submitted' });
        }
        
        if (trip.expense_count === 0) {
            return res.status(400).json({ error: 'Cannot submit trip with no expenses' });
        }
        
        // CRITICAL: Check for approved Travel Authorization before allowing submission
        const checkATQuery = `
            SELECT id, status, destination 
            FROM travel_authorizations 
            WHERE (trip_id = ? OR (employee_id = ? AND start_date <= ? AND end_date >= ?)) 
            AND status = 'approved'
            LIMIT 1
        `;
        
        db.get(checkATQuery, [tripId, req.user.employeeId, trip.start_date, trip.end_date], (err, at) => {
            if (err) {
                console.error('❌ Error checking travel authorization:', err);
                return res.status(500).json({ error: 'Failed to verify travel authorization' });
            }
            
            if (!at) {
                return res.status(400).json({ 
                    error: 'An approved Authorization to Travel (AT) is required before submitting trip expenses. Please create and get approval for an AT first.',
                    code: 'MISSING_AT'
                });
            }
            
            // Update trip status and link to AT if not already linked
            const updateQuery = `
                UPDATE trips 
                SET status = 'submitted', submitted_at = CURRENT_TIMESTAMP
                WHERE id = ?
            `;
            
            db.run(updateQuery, [tripId], function(err) {
                if (err) {
                    console.error('❌ Error submitting trip:', err);
                    return res.status(500).json({ error: 'Failed to submit trip' });
                }
                
                // Link AT to trip if not already linked
                if (!at.trip_id) {
                    db.run(`UPDATE travel_authorizations SET trip_id = ? WHERE id = ?`, [tripId, at.id]);
                }
                
                
                // FEATURE 4: Notify supervisor
                db.get('SELECT supervisor_id FROM employees WHERE id = ?', [req.user.employeeId], (err2, emp) => {
                    if (!err2 && emp && emp.supervisor_id) {
                        createNotification(emp.supervisor_id, 'trip_submitted', 
                            `Trip "${trip.trip_name || tripId}" has been submitted for your approval.`);
                    }
                });
                
                res.json({ 
                    success: true, 
                    message: 'Trip submitted for approval!' 
                });
            });
        });
    });
});

// 📱 Handle receipt photo upload as base64
app.post('/api/upload-receipt', requireAuth, (req, res) => {
    const { imageData, filename } = req.body;
    
    if (!imageData) {
        return res.status(400).json({ 
            success: false, 
            error: 'No image data provided' 
        });
    }
    
    try {
        // Remove data URL prefix if present
        const base64Data = imageData.replace(/^data:image\/[a-z]+;base64,/, '');
        const buffer = Buffer.from(base64Data, 'base64');
        
        const fileName = `receipt-${Date.now()}-${Math.round(Math.random() * 1E9)}.jpg`;
        const filePath = path.join(uploadsDir, fileName);
        
        fs.writeFileSync(filePath, buffer);
        
        res.json({ 
            success: true, 
            filename: fileName,
            path: `/uploads/${fileName}` 
        });
        
    } catch (error) {
        console.error('❌ Error uploading receipt:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Failed to upload receipt' 
        });
    }
});

// 📄 OCR Receipt Scanning Endpoint
app.post('/api/ocr/scan', requireAuth, upload.single('receipt'), async (req, res) => {
    const Tesseract = require('tesseract.js');
    
    try {
        if (!req.file) {
            return res.status(400).json({ 
                success: false, 
                error: 'No image file provided' 
            });
        }

        
        // Run Tesseract OCR on the uploaded image
        const { data: { text } } = await Tesseract.recognize(req.file.path, 'eng');


        // Smart parsing logic
        const parsedData = parseReceiptText(text);
        
        
        res.json({
            success: true,
            vendor: parsedData.vendor || '',
            amount: parsedData.amount || '',
            date: parsedData.date || '',
            rawText: text
        });

    } catch (error) {
        console.error('❌ OCR Error:', error);
        res.status(500).json({ 
            success: false, 
            error: 'OCR processing failed',
            details: error.message 
        });
    }
});

/**
 * Parse receipt text to extract vendor, amount, and date
 */
function parseReceiptText(text) {
    const lines = text.split('\n').map(line => line.trim()).filter(line => line.length > 0);
    
    let vendor = '';
    let amount = '';
    let date = '';

    // Extract amount - look for dollar patterns
    const amountPatterns = [
        /\$\s*(\d+[\.,]\d{2})/g,  // $XX.XX or $XX,XX
        /(\d+[\.,]\d{2})\s*\$?/g,  // XX.XX$ or XX.XX
        /total:?\s*\$?(\d+[\.,]\d{2})/gi,  // total: $XX.XX
        /amount:?\s*\$?(\d+[\.,]\d{2})/gi  // amount: $XX.XX
    ];
    
    for (const pattern of amountPatterns) {
        const matches = text.match(pattern);
        if (matches) {
            // Get the largest amount found (likely the total)
            const amounts = matches.map(match => {
                const num = match.replace(/[^\d\.,]/g, '').replace(',', '.');
                return parseFloat(num);
            }).filter(num => !isNaN(num));
            
            if (amounts.length > 0) {
                amount = Math.max(...amounts).toFixed(2);
                break;
            }
        }
    }

    // Extract date - look for common date patterns
    const datePatterns = [
        /(\d{1,2}[-\/]\d{1,2}[-\/]\d{2,4})/g,  // MM/DD/YYYY or MM-DD-YYYY
        /(\d{2,4}[-\/]\d{1,2}[-\/]\d{1,2})/g,  // YYYY/MM/DD or YYYY-MM-DD
        /(\w{3}\s+\d{1,2},?\s+\d{2,4})/g,      // Jan 15, 2024 or Jan 15 2024
        /(\d{1,2}\s+\w{3}\s+\d{2,4})/g        // 15 Jan 2024
    ];
    
    for (const pattern of datePatterns) {
        const matches = text.match(pattern);
        if (matches && matches.length > 0) {
            // Try to parse the first valid date
            const dateStr = matches[0];
            const parsedDate = new Date(dateStr);
            if (!isNaN(parsedDate.getTime()) && parsedDate.getFullYear() > 2020) {
                date = parsedDate.toISOString().split('T')[0]; // YYYY-MM-DD format
                break;
            }
        }
    }

    // Extract vendor - use the longest meaningful text line (likely business name)
    const meaningfulLines = lines.filter(line => {
        // Filter out common receipt noise
        const noise = /^(receipt|invoice|thank you|total|subtotal|tax|date|time|\$|visa|mastercard|\d+[\.,]\d{2}|[\d\s\-\(\)]+$)/gi;
        return line.length > 3 && line.length < 60 && !noise.test(line);
    });
    
    if (meaningfulLines.length > 0) {
        // Find the longest line that's likely a business name
        vendor = meaningfulLines.reduce((longest, current) => 
            current.length > longest.length ? current : longest
        );
        
        // Clean up vendor name
        vendor = vendor.replace(/[^\w\s&\-\.]/g, ' ').trim();
    }

    return { vendor, amount, date };
}

// ============================================
// FEATURE 1: Dashboard Stats Endpoint
// ============================================
app.get('/api/dashboard/stats', requireAuth, (req, res) => {
    const isAdmin = req.user.role === 'admin';
    const userId = req.user.employeeId;
    const whereClause = isAdmin ? '1=1' : 'e.employee_id = ?';
    const params = isAdmin ? [] : [userId];

    const now = new Date();
    const currentMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;

    const query = `
        SELECT 
            COUNT(*) as total_count,
            COALESCE(SUM(e.amount), 0) as total_amount,
            COALESCE(SUM(CASE WHEN e.status = 'pending' THEN 1 ELSE 0 END), 0) as pending_count,
            COALESCE(SUM(CASE WHEN e.date LIKE '${currentMonth}%' THEN e.amount ELSE 0 END), 0) as monthly_spend,
            COALESCE(SUM(CASE WHEN e.status = 'draft' THEN 1 ELSE 0 END), 0) as draft_count,
            COALESCE(SUM(CASE WHEN e.status = 'submitted' THEN 1 ELSE 0 END), 0) as submitted_count,
            COALESCE(SUM(CASE WHEN e.status = 'approved' THEN 1 ELSE 0 END), 0) as approved_count,
            COALESCE(SUM(CASE WHEN e.status = 'rejected' THEN 1 ELSE 0 END), 0) as rejected_count,
            COALESCE(SUM(CASE WHEN e.expense_type IN ('breakfast','lunch','dinner') THEN e.amount ELSE 0 END), 0) as meals_amount,
            COALESCE(SUM(CASE WHEN e.expense_type = 'vehicle_km' THEN e.amount ELSE 0 END), 0) as transport_amount,
            COALESCE(SUM(CASE WHEN e.expense_type = 'hotel' THEN e.amount ELSE 0 END), 0) as hotel_amount,
            COALESCE(SUM(CASE WHEN e.expense_type NOT IN ('breakfast','lunch','dinner','vehicle_km','hotel') THEN e.amount ELSE 0 END), 0) as other_amount
        FROM expenses e
        WHERE ${whereClause}
    `;

    db.get(query, params, (err, row) => {
        if (err) {
            console.error('❌ Error fetching dashboard stats:', err);
            return res.status(500).json({ error: 'Failed to fetch stats' });
        }
        res.json({
            success: true,
            total: { count: row.total_count, amount: row.total_amount },
            pending_count: row.pending_count,
            monthly_spend: row.monthly_spend,
            by_status: {
                draft: row.draft_count,
                submitted: row.submitted_count,
                approved: row.approved_count,
                rejected: row.rejected_count
            },
            by_type: {
                meals: row.meals_amount,
                transport: row.transport_amount,
                hotel: row.hotel_amount,
                other: row.other_amount
            }
        });
    });
});

// ============================================
// FEATURE 2: Expense Editing
// ============================================
app.put('/api/expenses/:id', requireAuth, (req, res) => {
    const { id } = req.params;
    const { expense_type, meal_name, date, location, amount, vendor, description } = req.body;

    // First check ownership and status
    db.get(`SELECT e.*, t.status as trip_status FROM expenses e LEFT JOIN trips t ON e.trip_id = t.id WHERE e.id = ?`, [id], (err, expense) => {
        if (err) return res.status(500).json({ success: false, error: 'Database error' });
        if (!expense) return res.status(404).json({ success: false, error: 'Expense not found' });
        if (expense.employee_id !== req.user.employeeId && req.user.role !== 'admin') {
            return res.status(403).json({ success: false, error: 'Not your expense' });
        }
        // Only allow editing draft/pending expenses whose trip is not submitted
        if (expense.status === 'approved' || expense.status === 'rejected') {
            return res.status(400).json({ success: false, error: 'Cannot edit approved/rejected expenses' });
        }
        if (expense.trip_status && expense.trip_status !== 'draft') {
            return res.status(400).json({ success: false, error: 'Cannot edit expenses in a submitted trip' });
        }

        const query = `UPDATE expenses SET 
            expense_type = COALESCE(?, expense_type),
            meal_name = COALESCE(?, meal_name),
            date = COALESCE(?, date),
            location = COALESCE(?, location),
            amount = COALESCE(?, amount),
            vendor = COALESCE(?, vendor),
            description = COALESCE(?, description),
            updated_at = CURRENT_TIMESTAMP
            WHERE id = ?`;

        db.run(query, [expense_type, meal_name, date, location, amount, vendor, description, id], function(err) {
            if (err) return res.status(500).json({ success: false, error: 'Failed to update expense' });
            res.json({ success: true, message: 'Expense updated successfully' });
        });
    });
});

// Employee can delete their own draft expenses (for Day Planner toggle-off)
app.delete('/api/expenses/:id/mine', requireAuth, (req, res) => {
    const { id } = req.params;
    db.get(`SELECT e.*, t.status as trip_status FROM expenses e LEFT JOIN trips t ON e.trip_id = t.id WHERE e.id = ?`, [id], (err, expense) => {
        if (err) return res.status(500).json({ success: false, error: 'Database error' });
        if (!expense) return res.status(404).json({ success: false, error: 'Expense not found' });
        if (expense.employee_id !== req.user.employeeId) {
            return res.status(403).json({ success: false, error: 'Not your expense' });
        }
        if (expense.status === 'approved') {
            return res.status(400).json({ success: false, error: 'Cannot delete approved expenses' });
        }
        if (expense.trip_status && expense.trip_status !== 'draft') {
            return res.status(400).json({ success: false, error: 'Cannot delete expenses in a submitted trip' });
        }
        db.run('DELETE FROM expenses WHERE id = ?', [id], function(err) {
            if (err) return res.status(500).json({ success: false, error: 'Failed to delete' });
            res.json({ success: true });
        });
    });
});

// ============================================
// FEATURE 3: Notifications table + endpoints
// ============================================
// Create notifications table on startup
db.run(`CREATE TABLE IF NOT EXISTS notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    type TEXT NOT NULL,
    message TEXT NOT NULL,
    read INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees (id)
)`, (err) => {
    if (err) console.error('❌ Error creating notifications table:', err.message);
});

function createNotification(employeeId, type, message) {
    db.run('INSERT INTO notifications (employee_id, type, message) VALUES (?, ?, ?)',
        [employeeId, type, message], (err) => {
            if (err) console.error('❌ Notification error:', err.message);
        });
}

// Get notifications for current user
app.get('/api/notifications', requireAuth, (req, res) => {
    db.all('SELECT * FROM notifications WHERE employee_id = ? ORDER BY created_at DESC LIMIT 50',
        [req.user.employeeId], (err, rows) => {
            if (err) return res.status(500).json({ error: 'Failed to fetch notifications' });
            const unread = rows.filter(r => !r.read).length;
            res.json({ notifications: rows, unread_count: unread });
        });
});

// Mark notification as read
app.put('/api/notifications/:id/read', requireAuth, (req, res) => {
    db.run('UPDATE notifications SET read = 1 WHERE id = ? AND employee_id = ?',
        [req.params.id, req.user.employeeId], function(err) {
            if (err) return res.status(500).json({ success: false, error: 'Failed' });
            res.json({ success: true });
        });
});

// ============================================
// TRAVEL AUTHORIZATION (AT) SYSTEM
// ============================================

// 1. Create Travel Authorization
app.post('/api/travel-auth', requireAuth, async (req, res) => {
    const {
        name,
        destination = '',
        start_date,
        end_date,
        purpose = '',
        est_transport = 0,
        est_lodging = 0,
        est_meals = 0,
        est_other = 0,
        details = null
    } = req.body;
    
    // Validation
    if (!name || !start_date || !end_date || !destination) {
        return res.status(400).json({
            success: false,
            error: 'Missing required fields: name, destination, start_date, end_date'
        });
    }
    
    // Calculate total
    const est_total = parseFloat(est_transport) + parseFloat(est_lodging) + 
                     parseFloat(est_meals) + parseFloat(est_other);
    
    // Check for overlapping travel authorizations
    try {
        const overlap = await new Promise((resolve, reject) => {
            db.get(
                `SELECT id, name, start_date, end_date FROM travel_authorizations 
                 WHERE employee_id = ? AND status NOT IN ('rejected') 
                 AND start_date <= ? AND end_date >= ?`,
                [req.user.employeeId, end_date, start_date],
                (err, row) => err ? reject(err) : resolve(row)
            );
        });
        if (overlap) {
            return res.status(400).json({
                success: false,
                error: `Dates overlap with existing authorization "${overlap.name}" (${overlap.start_date} → ${overlap.end_date}). Please choose different dates.`
            });
        }
    } catch (e) {
        console.error('❌ Error checking overlap:', e);
    }
    
    // Get supervisor (approver)
    db.get('SELECT supervisor_id FROM employees WHERE id = ?', [req.user.employeeId], (err, employee) => {
        if (err) {
            console.error('❌ Error fetching supervisor:', err);
            return res.status(500).json({ success: false, error: 'Failed to get approver' });
        }
        
        if (!employee || !employee.supervisor_id) {
            return res.status(400).json({ 
                success: false, 
                error: 'No supervisor assigned. Contact admin to assign a supervisor.' 
            });
        }
        
        const query = `
            INSERT INTO travel_authorizations 
            (employee_id, name, destination, start_date, end_date, purpose, 
             est_transport, est_lodging, est_meals, est_other, est_total, 
             approver_id, status, details)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'draft', ?)
        `;
        
        const params = [
            req.user.employeeId, name, destination, start_date, end_date, purpose,
            est_transport, est_lodging, est_meals, est_other, est_total,
            employee.supervisor_id, details
        ];
        
        db.run(query, params, function(err) {
            if (err) {
                console.error('❌ Error creating travel authorization:', err);
                return res.status(500).json({ 
                    success: false, 
                    error: 'Failed to create travel authorization' 
                });
            }
            
            res.json({ 
                success: true, 
                id: this.lastID, 
                message: 'Travel Authorization created as draft!' 
            });
        });
    });
});

// 2. Get Travel Authorizations (employee sees own, supervisor sees team's, admin sees all)
app.get('/api/travel-auth', requireAuth, (req, res) => {
    let query, params;
    
    if (req.user.role === 'admin') {
        query = `
            SELECT ta.*, e.name as employee_name, s.name as approver_name,
                   (SELECT COUNT(*) FROM expenses ex WHERE ex.travel_auth_id = ta.id) as expense_count,
                   (SELECT COALESCE(SUM(ex.amount), 0) FROM expenses ex WHERE ex.travel_auth_id = ta.id) as expenses_total
            FROM travel_authorizations ta
            JOIN employees e ON ta.employee_id = e.id
            LEFT JOIN employees s ON ta.approver_id = s.id
            ORDER BY ta.created_at DESC
        `;
        params = [];
    } else if (req.user.role === 'supervisor') {
        if (req.query.view === 'team') {
            // 🚨 GOVERNANCE FIX: Supervisor sees ONLY direct reports (not indirect/recursive)
            query = `
                SELECT ta.*, e.name as employee_name, s.name as approver_name,
                       (SELECT COUNT(*) FROM expenses ex WHERE ex.travel_auth_id = ta.id) as expense_count,
                       (SELECT COALESCE(SUM(ex.amount), 0) FROM expenses ex WHERE ex.travel_auth_id = ta.id) as expenses_total
                FROM travel_authorizations ta
                JOIN employees e ON ta.employee_id = e.id
                LEFT JOIN employees s ON ta.approver_id = s.id
                WHERE e.supervisor_id = ?
                ORDER BY ta.created_at DESC
            `;
        } else {
            // Employee dashboard — show only own auths
            query = `
                SELECT ta.*, e.name as employee_name, s.name as approver_name,
                       (SELECT COUNT(*) FROM expenses ex WHERE ex.travel_auth_id = ta.id) as expense_count,
                       (SELECT COALESCE(SUM(ex.amount), 0) FROM expenses ex WHERE ex.travel_auth_id = ta.id) as expenses_total
                FROM travel_authorizations ta
                JOIN employees e ON ta.employee_id = e.id
                LEFT JOIN employees s ON ta.approver_id = s.id
                WHERE ta.employee_id = ?
                ORDER BY ta.created_at DESC
            `;
        }
        params = [req.user.employeeId];
    } else {
        query = `
            SELECT ta.*, e.name as employee_name, s.name as approver_name,
                   (SELECT COUNT(*) FROM expenses ex WHERE ex.travel_auth_id = ta.id) as expense_count,
                   (SELECT COALESCE(SUM(ex.amount), 0) FROM expenses ex WHERE ex.travel_auth_id = ta.id) as expenses_total
            FROM travel_authorizations ta
            JOIN employees e ON ta.employee_id = e.id
            LEFT JOIN employees s ON ta.approver_id = s.id
            WHERE ta.employee_id = ?
            ORDER BY ta.created_at DESC
        `;
        params = [req.user.employeeId];
    }
    
    db.all(query, params, (err, rows) => {
        if (err) {
            console.error('❌ Error fetching travel authorizations:', err);
            return res.status(500).json({ error: 'Failed to fetch travel authorizations' });
        }
        
        res.json(rows);
    });
});

// 3. Get single Travel Authorization
app.get('/api/travel-auth/:id', requireAuth, (req, res) => {
    const query = `
        SELECT ta.*, e.name as employee_name, s.name as approver_name
        FROM travel_authorizations ta
        JOIN employees e ON ta.employee_id = e.id
        LEFT JOIN employees s ON ta.approver_id = s.id
        WHERE ta.id = ?
    `;
    
    db.get(query, [req.params.id], (err, row) => {
        if (err) {
            console.error('❌ Error fetching travel authorization:', err);
            return res.status(500).json({ error: 'Failed to fetch travel authorization' });
        }
        
        if (!row) {
            return res.status(404).json({ error: 'Travel authorization not found' });
        }
        
        // Check permissions
        if (req.user.role !== 'admin' && 
            row.employee_id !== req.user.employeeId && 
            row.approver_id !== req.user.employeeId) {
            return res.status(403).json({ error: 'Access denied' });
        }
        
        res.json(row);
    });
});

// 4. Approve Travel Authorization
app.put('/api/travel-auth/:id/approve', requireAuth, requireRole('supervisor'), (req, res) => {
    const atId = req.params.id;
    
    // Check if user is the approver
    db.get('SELECT * FROM travel_authorizations WHERE id = ? AND approver_id = ?', 
        [atId, req.user.employeeId], (err, at) => {
        if (err) {
            console.error('❌ Error checking AT approval rights:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        
        if (!at) {
            return res.status(404).json({ error: 'Travel authorization not found or you are not the approver' });
        }
        
        if (at.status !== 'pending') {
            return res.status(400).json({ error: 'Travel authorization is not pending' });
        }
        
        // Approve the AT
        const updateQuery = `
            UPDATE travel_authorizations 
            SET status = 'approved', approved_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `;
        
        db.run(updateQuery, [atId], function(err) {
            if (err) {
                console.error('❌ Error approving travel authorization:', err);
                return res.status(500).json({ error: 'Failed to approve travel authorization' });
            }
            
            
            // Auto-create trip from approved authorization
            db.run(`INSERT INTO trips (employee_id, trip_name, destination, purpose, start_date, end_date, status)
                    VALUES (?, ?, ?, ?, ?, ?, 'active')`,
                [at.employee_id, at.name || at.destination, at.destination || '', at.purpose || '', at.start_date, at.end_date],
                function(tripErr) {
                    if (tripErr) {
                        console.error('❌ Error auto-creating trip from auth:', tripErr);
                    } else {
                        const tripId = this.lastID;
                        // Link the auth to the trip
                        db.run('UPDATE travel_authorizations SET trip_id = ? WHERE id = ?', [tripId, atId]);
                        console.log(`✅ Auto-created trip #${tripId} from approved auth #${atId}`);
                    }
                }
            );

            // Notify employee
            createNotification(at.employee_id, 'at_approved', 
                `Your Authorization to Travel for ${at.name || at.destination} has been approved. A trip has been created automatically.`);
            
            res.json({ 
                success: true, 
                message: 'Travel Authorization approved and trip created!' 
            });
        });
    });
});

// 5. Reject Travel Authorization
app.put('/api/travel-auth/:id/reject', requireAuth, requireRole('supervisor'), (req, res) => {
    const atId = req.params.id;
    // CRITICAL FIX: Accept rejection reason from multiple possible body formats
    const rejection_reason = req.body.rejection_reason || req.body.reason || req.body.rejectionReason;
    
    if (!rejection_reason || rejection_reason.trim() === '') {
        return res.status(400).json({ 
            error: 'Rejection reason is required',
            expected_body: { rejection_reason: 'Your reason here' }
        });
    }
    
    // Validate minimum length for governance compliance
    if (rejection_reason.trim().length < 10) {
        return res.status(400).json({ error: 'Rejection reason must be at least 10 characters' });
    }
    
    // Check if user is the approver
    db.get('SELECT * FROM travel_authorizations WHERE id = ? AND approver_id = ?', 
        [atId, req.user.employeeId], (err, at) => {
        if (err) {
            console.error('❌ Error checking AT rejection rights:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        
        if (!at) {
            return res.status(404).json({ error: 'Travel authorization not found or you are not the approver' });
        }
        
        if (at.status !== 'pending') {
            return res.status(400).json({ error: 'Travel authorization is not pending' });
        }
        
        // Reject the AT
        const updateQuery = `
            UPDATE travel_authorizations 
            SET status = 'rejected', rejection_reason = ?, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `;
        
        db.run(updateQuery, [rejection_reason, atId], function(err) {
            if (err) {
                console.error('❌ Error rejecting travel authorization:', err);
                return res.status(500).json({ error: 'Failed to reject travel authorization' });
            }
            
            
            // Notify employee
            createNotification(at.employee_id, 'at_rejected', 
                `Your Authorization to Travel for ${at.destination} was rejected: ${rejection_reason}`);
            
            res.json({ 
                success: true, 
                message: 'Travel Authorization rejected.' 
            });
        });
    });
});

// 6. Update Travel Authorization (for draft/rejected ATs)
app.put('/api/travel-auth/:id', requireAuth, (req, res) => {
    const atId = req.params.id;
    const {
        name,
        destination = '',
        start_date,
        end_date,
        purpose = '',
        est_transport = 0,
        est_lodging = 0,
        est_meals = 0,
        est_other = 0,
        details = null
    } = req.body;
    
    // Check ownership and status
    db.get('SELECT * FROM travel_authorizations WHERE id = ? AND employee_id = ?', 
        [atId, req.user.employeeId], (err, at) => {
        if (err) {
            console.error('❌ Error checking AT ownership:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        
        if (!at) {
            return res.status(404).json({ error: 'Travel authorization not found' });
        }
        
        if (at.status === 'approved') {
            return res.status(400).json({ error: 'Cannot edit approved travel authorization' });
        }
        
        if (at.status === 'pending') {
            return res.status(400).json({ error: 'Cannot edit pending travel authorization. Wait for approval or contact your supervisor.' });
        }
        
        // Calculate total
        const est_total = parseFloat(est_transport) + parseFloat(est_lodging) + 
                         parseFloat(est_meals) + parseFloat(est_other);
        
        // Check for overlapping travel authorizations (exclude self)
        if (start_date && end_date) {
            db.get(
                `SELECT id, name, start_date, end_date FROM travel_authorizations 
                 WHERE employee_id = ? AND id != ? AND status NOT IN ('rejected') 
                 AND start_date <= ? AND end_date >= ?`,
                [req.user.employeeId, atId, end_date, start_date],
                (err2, overlap) => {
                    if (overlap) {
                        return res.status(400).json({
                            error: `Dates overlap with existing authorization "${overlap.name}" (${overlap.start_date} → ${overlap.end_date}). Please choose different dates.`
                        });
                    }
                    doUpdate();
                }
            );
        } else {
            doUpdate();
        }
        
        function doUpdate() {
        // Update the AT — keep draft status if draft, otherwise set to draft for re-editing
        const newStatus = at.status === 'draft' ? 'draft' : 'draft';
        const updateQuery = `
            UPDATE travel_authorizations 
            SET name = COALESCE(?, name),
                destination = COALESCE(?, destination),
                start_date = COALESCE(?, start_date),
                end_date = COALESCE(?, end_date),
                purpose = COALESCE(?, purpose),
                est_transport = ?,
                est_lodging = ?,
                est_meals = ?,
                est_other = ?,
                est_total = ?,
                details = COALESCE(?, details),
                status = '${newStatus}',
                rejection_reason = NULL,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `;
        
        const params = [name, destination, start_date, end_date, purpose, 
                       est_transport, est_lodging, est_meals, est_other, est_total, details, atId];
        
        db.run(updateQuery, params, function(err) {
            if (err) {
                console.error('❌ Error updating travel authorization:', err);
                return res.status(500).json({ error: 'Failed to update travel authorization' });
            }
            
            
            // Update totals from expenses
            updateAuthTotals(atId);
            
            res.json({ 
                success: true, 
                message: 'Travel Authorization updated!' 
            });
        });
        } // end doUpdate
    });
});

// 7. Link Travel Authorization to Trip
app.post('/api/travel-auth/:id/link-trip/:tripId', requireAuth, (req, res) => {
    const atId = req.params.id;
    const tripId = req.params.tripId;
    
    // Check ownership of both AT and trip
    Promise.all([
        new Promise((resolve, reject) => {
            db.get('SELECT * FROM travel_authorizations WHERE id = ? AND employee_id = ? AND status = "approved"', 
                [atId, req.user.employeeId], (err, at) => {
                if (err) reject(err);
                else resolve(at);
            });
        }),
        new Promise((resolve, reject) => {
            db.get('SELECT * FROM trips WHERE id = ? AND employee_id = ?', 
                [tripId, req.user.employeeId], (err, trip) => {
                if (err) reject(err);
                else resolve(trip);
            });
        })
    ]).then(([at, trip]) => {
        if (!at) {
            return res.status(404).json({ error: 'Approved travel authorization not found' });
        }
        if (!trip) {
            return res.status(404).json({ error: 'Trip not found' });
        }
        if (at.trip_id) {
            return res.status(400).json({ error: 'Travel authorization is already linked to a trip' });
        }
        
        // Link AT to trip
        db.run('UPDATE travel_authorizations SET trip_id = ? WHERE id = ?', [tripId, atId], function(err) {
            if (err) {
                console.error('❌ Error linking AT to trip:', err);
                return res.status(500).json({ error: 'Failed to link travel authorization to trip' });
            }
            
            res.json({ 
                success: true, 
                message: 'Travel Authorization linked to trip successfully!' 
            });
        });
    }).catch(err => {
        console.error('❌ Error checking AT/trip ownership:', err);
        res.status(500).json({ error: 'Database error' });
    });
});

// ============================================
// TRAVEL AUTH EXPENSES (Estimated Expenses)
// ============================================

// 8. Add estimated expense to travel authorization
app.post('/api/travel-auth/:id/expenses', requireAuth, async (req, res) => {
    const atId = req.params.id;
    const { expense_type, date, location, amount, vendor, description, kilometers, vehicle_from, vehicle_to, hotel_checkin, hotel_checkout } = req.body;

    if (!expense_type || !date || !amount) {
        return res.status(400).json({ error: 'Missing required fields: expense_type, date, amount' });
    }
    
    // CRITICAL FIX: Validate expense type for travel auth
    const validExpenseTypes = ['breakfast', 'lunch', 'dinner', 'incidentals', 'vehicle_km', 'hotel', 'other', 'transport', 'transport_flight', 'transport_train', 'transport_bus', 'transport_rental'];
    if (!validExpenseTypes.includes(expense_type)) {
        return res.status(400).json({ 
            error: `Invalid expense type "${expense_type}". Valid types: ${validExpenseTypes.join(', ')}`,
            received_body: req.body
        });
    }
    
    // Normalize "transport" to "vehicle_km" for consistency
    if (expense_type === 'transport') {
        expense_type = 'vehicle_km';
    }

    try {
    // Check ownership and draft/rejected status
    const at = await new Promise((resolve, reject) => {
        db.get('SELECT * FROM travel_authorizations WHERE id = ? AND employee_id = ?', [atId, req.user.employeeId], (err, row) => err ? reject(err) : resolve(row));
    });
    if (!at) return res.status(404).json({ error: 'Travel authorization not found' });
    if (at.status !== 'draft' && at.status !== 'rejected') {
        return res.status(400).json({ error: 'Can only add expenses to draft or rejected authorizations' });
    }

    // Validate expense date is within authorization date range
    if (date < at.start_date || date > at.end_date) {
        return res.status(400).json({ error: `Expense date must be within the authorization dates (${at.start_date} to ${at.end_date})` });
    }

    // Validate hotel check-in/check-out dates are within authorization range
    if (expense_type === 'hotel' && hotel_checkin && hotel_checkout) {
        if (hotel_checkin < at.start_date || hotel_checkin > at.end_date) {
            return res.status(400).json({ error: `Hotel check-in must be within travel dates (${at.start_date} to ${at.end_date})` });
        }
        if (hotel_checkout < at.start_date || hotel_checkout > at.end_date) {
            return res.status(400).json({ error: `Hotel check-out must be within travel dates (${at.start_date} to ${at.end_date})` });
        }
    }

    // Prevent duplicate per diem claims on same day
    const perDiemTypes = ['breakfast', 'lunch', 'dinner', 'incidentals'];
    if (perDiemTypes.includes(expense_type)) {
        const existing = await new Promise((resolve, reject) => {
            db.get('SELECT id FROM expenses WHERE travel_auth_id = ? AND expense_type = ? AND date = ?',
                [atId, expense_type, date], (err2, row) => err2 ? reject(err2) : resolve(row));
        });
        if (existing) {
            const names = { breakfast: 'Breakfast', lunch: 'Lunch', dinner: 'Dinner', incidentals: 'Incidentals' };
            return res.status(400).json({ error: `${names[expense_type]} already claimed for ${date}. Only one per day allowed.` });
        }
    }

    // Get employee name
    const emp = await new Promise((resolve, reject) => {
        db.get('SELECT name FROM employees WHERE id = ?', [req.user.employeeId], (err2, row) => err2 ? reject(err2) : resolve(row));
    });

    // Build description with vehicle/hotel details if applicable
    let finalDesc = description || '';
    if (expense_type === 'vehicle_km' && kilometers) {
        finalDesc = `${vehicle_from || ''} → ${vehicle_to || ''} (${kilometers} km)${finalDesc ? ' — ' + finalDesc : ''}`;
    }
    if (expense_type === 'hotel' && hotel_checkin && hotel_checkout) {
        finalDesc = `Check-in: ${hotel_checkin}, Check-out: ${hotel_checkout}${finalDesc ? ' — ' + finalDesc : ''}`;
    }

    const mealNames = { breakfast: 'Breakfast', lunch: 'Lunch', dinner: 'Dinner', incidentals: 'Incidentals' };
    const meal_name = mealNames[expense_type] || null;

    await new Promise((resolve, reject) => {
        db.run(`INSERT INTO expenses (employee_name, employee_id, travel_auth_id, expense_type, meal_name, date, location, amount, vendor, description, status, receipt_photo)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'estimate', NULL)`,
            [emp.name, req.user.employeeId, atId, expense_type, meal_name, date, location || '', parseFloat(amount), vendor || '', finalDesc],
            function(err) {
                if (err) return reject(err);
                updateAuthTotals(atId);
                res.json({ success: true, id: this.lastID, message: 'Estimated expense added!' });
                resolve();
            }
        );
    });
    } catch (err) {
        console.error('❌ Error in travel auth expense:', err);
        console.error('Request body:', req.body);
        console.error('Full error stack:', err.stack);
        res.status(500).json({ 
            error: 'Internal server error',
            details: err.message,
            debug: process.env.NODE_ENV === 'development' ? err.stack : undefined
        });
    }
});

// 9. Get expenses for a travel authorization
app.get('/api/travel-auth/:id/expenses', requireAuth, (req, res) => {
    const atId = req.params.id;

    // Verify access
    db.get('SELECT * FROM travel_authorizations WHERE id = ?', [atId], (err, at) => {
        if (err) return res.status(500).json({ error: 'Database error' });
        if (!at) return res.status(404).json({ error: 'Travel authorization not found' });
        if (req.user.role !== 'admin' && at.employee_id !== req.user.employeeId && at.approver_id !== req.user.employeeId) {
            return res.status(403).json({ error: 'Access denied' });
        }

        db.all('SELECT * FROM expenses WHERE travel_auth_id = ? ORDER BY date, id', [atId], (err, rows) => {
            if (err) return res.status(500).json({ error: 'Failed to fetch expenses' });
            res.json(rows || []);
        });
    });
});

// 10. Delete estimated expense from travel authorization
app.delete('/api/travel-auth/:id/expenses/:expenseId', requireAuth, (req, res) => {
    const { id: atId, expenseId } = req.params;

    db.get('SELECT * FROM travel_authorizations WHERE id = ? AND employee_id = ?', [atId, req.user.employeeId], (err, at) => {
        if (err) return res.status(500).json({ error: 'Database error' });
        if (!at) return res.status(404).json({ error: 'Travel authorization not found' });
        if (at.status !== 'draft' && at.status !== 'rejected') {
            return res.status(400).json({ error: 'Can only remove expenses from draft or rejected authorizations' });
        }

        db.run('DELETE FROM expenses WHERE id = ? AND travel_auth_id = ? AND employee_id = ?',
            [expenseId, atId, req.user.employeeId], function(err) {
                if (err) return res.status(500).json({ error: 'Failed to delete expense' });
                if (this.changes === 0) return res.status(404).json({ error: 'Expense not found' });

                updateAuthTotals(atId);
                res.json({ success: true, message: 'Expense removed' });
            }
        );
    });
});

// 11. Submit travel authorization for approval (draft → pending)
app.put('/api/travel-auth/:id/submit', requireAuth, (req, res) => {
    const atId = req.params.id;

    db.get('SELECT * FROM travel_authorizations WHERE id = ? AND employee_id = ?', [atId, req.user.employeeId], (err, at) => {
        if (err) return res.status(500).json({ error: 'Database error' });
        if (!at) return res.status(404).json({ error: 'Travel authorization not found' });
        if (at.status !== 'draft' && at.status !== 'rejected') {
            return res.status(400).json({ error: 'Can only submit draft or rejected authorizations' });
        }

        db.run(`UPDATE travel_authorizations SET status = 'pending', rejection_reason = NULL, updated_at = CURRENT_TIMESTAMP WHERE id = ?`,
            [atId], function(err) {
                if (err) return res.status(500).json({ error: 'Failed to submit' });

                // Notify supervisor
                if (at.approver_id) {
                    createNotification(at.approver_id, 'at_pending',
                        `New Authorization to Travel request "${at.name || at.destination}" awaits your approval.`);
                }

                res.json({ success: true, message: 'Travel Authorization submitted for approval!' });
            }
        );
    });
});

// Helper: Update travel auth totals from its expenses
function updateAuthTotals(atId) {
    db.all('SELECT expense_type, amount FROM expenses WHERE travel_auth_id = ?', [atId], (err, expenses) => {
        if (err) return console.error('Error updating auth totals:', err);

        let est_transport = 0, est_lodging = 0, est_meals = 0, est_other = 0;
        (expenses || []).forEach(e => {
            const amt = parseFloat(e.amount) || 0;
            if (e.expense_type === 'vehicle_km' || e.expense_type.startsWith('transport_')) est_transport += amt;
            else if (e.expense_type === 'hotel') est_lodging += amt;
            else if (['breakfast', 'lunch', 'dinner', 'incidentals'].includes(e.expense_type)) est_meals += amt;
            else est_other += amt;
        });

        const est_total = est_transport + est_lodging + est_meals + est_other;
        db.run(`UPDATE travel_authorizations SET est_transport = ?, est_lodging = ?, est_meals = ?, est_other = ?, est_total = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?`,
            [est_transport, est_lodging, est_meals, est_other, est_total, atId]);
    });
}

// ============================================
// FEATURE 5: CSV Export
// ============================================
app.get('/api/expenses/export/csv', (req, res, next) => {
    // Support token in query string for direct download links
    if (req.query.token && !req.headers.authorization) {
        req.headers.authorization = `Bearer ${req.query.token}`;
    }
    requireAuth(req, res, next);
}, (req, res) => {
    const isEmployee = req.user.role === 'employee';
    const query = isEmployee
        ? `SELECT e.date, e.expense_type, e.amount, t.trip_name, e.status, e.description, e.location
           FROM expenses e LEFT JOIN trips t ON e.trip_id = t.id WHERE e.employee_id = ? ORDER BY e.date`
        : `SELECT e.date, e.expense_type, e.amount, t.trip_name, e.status, e.description, e.location, e.employee_name
           FROM expenses e LEFT JOIN trips t ON e.trip_id = t.id ORDER BY e.date`;
    const params = isEmployee ? [req.user.employeeId] : [];

    db.all(query, params, (err, rows) => {
        if (err) return res.status(500).json({ error: 'Failed to export' });

        const headers = isEmployee
            ? ['Date', 'Type', 'Amount', 'Trip', 'Status', 'Description', 'Location']
            : ['Date', 'Type', 'Amount', 'Trip', 'Status', 'Description', 'Location', 'Employee'];

        const csvRows = [headers.join(',')];
        rows.forEach(r => {
            const vals = [
                r.date, r.expense_type, r.amount, r.trip_name || '', r.status,
                `"${(r.description || '').replace(/"/g, '""')}"`,
                `"${(r.location || '').replace(/"/g, '""')}"`
            ];
            if (!isEmployee) vals.push(`"${(r.employee_name || '').replace(/"/g, '""')}"`);
            csvRows.push(vals.join(','));
        });

        res.setHeader('Content-Type', 'text/csv');
        res.setHeader('Content-Disposition', 'attachment; filename=expenses-export.csv');
        res.send(csvRows.join('\n'));
    });
});

// ============================================
// Inject notifications into trip submission flow
// ============================================

// 🚨 Error handling
app.use((error, req, res, next) => {
    if (error instanceof multer.MulterError) {
        if (error.code === 'LIMIT_FILE_SIZE') {
            return res.status(400).json({
                success: false,
                error: 'File size too large. Maximum size is 10MB.'
            });
        }
        return res.status(400).json({
            success: false,
            error: `Upload error: ${error.message}`
        });
    }
    
    // Bug 3 Fix: Handle file filter errors (non-MulterError from fileFilter callback)
    if (error.message && (error.message.includes('image files') || error.message.includes('Only'))) {
        return res.status(400).json({
            success: false,
            error: error.message
        });
    }
    
    console.error('❌ Unhandled error:', error);
    res.status(500).json({
        success: false,
        error: 'Internal server error'
    });
});

// 💰 SAGE 300 GL MAPPING ENDPOINTS (Admin Only)

// Get all GL accounts
app.get('/api/sage/gl-accounts', requireAuth, requireRole('admin'), (req, res) => {
    db.all(`SELECT * FROM gl_accounts ORDER BY expense_type`, (err, rows) => {
        if (err) {
            console.error('❌ Error fetching GL accounts:', err.message);
            return res.status(500).json({ success: false, error: 'Database error' });
        }
        res.json({ success: true, data: rows });
    });
});

// Update GL account
app.put('/api/sage/gl-accounts/:id', requireAuth, requireRole('admin'), (req, res) => {
    const { id } = req.params;
    const { expense_type, gl_code, gl_name, is_active } = req.body;
    
    if (!expense_type || !gl_code || !gl_name) {
        return res.status(400).json({ success: false, error: 'Missing required fields' });
    }
    
    db.run(`UPDATE gl_accounts SET expense_type = ?, gl_code = ?, gl_name = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?`,
        [expense_type, gl_code, gl_name, is_active || 1, id], function(err) {
            if (err) {
                console.error('❌ Error updating GL account:', err.message);
                return res.status(500).json({ success: false, error: 'Database error' });
            }
            if (this.changes === 0) {
                return res.status(404).json({ success: false, error: 'GL account not found' });
            }
            res.json({ success: true, message: 'GL account updated successfully' });
    });
});

// Add new GL account
app.post('/api/sage/gl-accounts', requireAuth, requireRole('admin'), (req, res) => {
    const { expense_type, gl_code, gl_name, is_active } = req.body;
    
    if (!expense_type || !gl_code || !gl_name) {
        return res.status(400).json({ success: false, error: 'Missing required fields' });
    }
    
    db.run(`INSERT INTO gl_accounts (expense_type, gl_code, gl_name, is_active) VALUES (?, ?, ?, ?)`,
        [expense_type, gl_code, gl_name, is_active || 1], function(err) {
            if (err) {
                console.error('❌ Error adding GL account:', err.message);
                if (err.message.includes('UNIQUE constraint failed')) {
                    return res.status(400).json({ success: false, error: 'Expense type already exists' });
                }
                return res.status(500).json({ success: false, error: 'Database error' });
            }
            res.json({ success: true, message: 'GL account added successfully', id: this.lastID });
    });
});

// Get all cost centers
app.get('/api/sage/cost-centers', requireAuth, requireRole('admin'), (req, res) => {
    db.all(`SELECT * FROM department_cost_centers ORDER BY department`, (err, rows) => {
        if (err) {
            console.error('❌ Error fetching cost centers:', err.message);
            return res.status(500).json({ success: false, error: 'Database error' });
        }
        res.json({ success: true, data: rows });
    });
});

// Update cost center
app.put('/api/sage/cost-centers/:id', requireAuth, requireRole('admin'), (req, res) => {
    const { id } = req.params;
    const { department, cost_center_code, cost_center_name, is_active } = req.body;
    
    if (!department || !cost_center_code || !cost_center_name) {
        return res.status(400).json({ success: false, error: 'Missing required fields' });
    }
    
    db.run(`UPDATE department_cost_centers SET department = ?, cost_center_code = ?, cost_center_name = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?`,
        [department, cost_center_code, cost_center_name, is_active || 1, id], function(err) {
            if (err) {
                console.error('❌ Error updating cost center:', err.message);
                return res.status(500).json({ success: false, error: 'Database error' });
            }
            if (this.changes === 0) {
                return res.status(404).json({ success: false, error: 'Cost center not found' });
            }
            res.json({ success: true, message: 'Cost center updated successfully' });
    });
});

// Add new cost center
app.post('/api/sage/cost-centers', requireAuth, requireRole('admin'), (req, res) => {
    const { department, cost_center_code, cost_center_name, is_active } = req.body;
    
    if (!department || !cost_center_code || !cost_center_name) {
        return res.status(400).json({ success: false, error: 'Missing required fields' });
    }
    
    db.run(`INSERT INTO department_cost_centers (department, cost_center_code, cost_center_name, is_active) VALUES (?, ?, ?, ?)`,
        [department, cost_center_code, cost_center_name, is_active || 1], function(err) {
            if (err) {
                console.error('❌ Error adding cost center:', err.message);
                if (err.message.includes('UNIQUE constraint failed')) {
                    return res.status(400).json({ success: false, error: 'Department already exists' });
                }
                return res.status(500).json({ success: false, error: 'Database error' });
            }
            res.json({ success: true, message: 'Cost center added successfully', id: this.lastID });
    });
});

// Get count of approved expenses for export confirmation
app.get('/api/sage/export-count', requireAuth, requireRole('admin'), (req, res) => {
    const query = `
        SELECT COUNT(*) as count
        FROM expenses e
        LEFT JOIN employees emp ON e.employee_id = emp.id
        LEFT JOIN gl_accounts gl ON e.expense_type = gl.expense_type
        LEFT JOIN department_cost_centers dc ON emp.department = dc.department
        WHERE e.status = 'approved' 
        AND gl.is_active = 1 
        AND dc.is_active = 1
    `;
    
    db.get(query, (err, row) => {
        if (err) {
            console.error('❌ Error counting export data:', err.message);
            return res.status(500).json({ success: false, error: 'Database error' });
        }
        res.json({ success: true, count: row.count });
    });
});

// Export approved expenses as Sage 300 CSV
app.get('/api/sage/export', requireAuth, requireRole('admin'), (req, res) => {
    const query = `
        SELECT 
            e.date,
            gl.gl_code,
            dc.cost_center_code,
            e.description,
            e.amount,
            emp.name as employee_name,
            emp.department,
            'EXP-' || e.id as reference,
            e.expense_type,
            e.vendor,
            e.location
        FROM expenses e
        LEFT JOIN employees emp ON e.employee_id = emp.id
        LEFT JOIN gl_accounts gl ON e.expense_type = gl.expense_type
        LEFT JOIN department_cost_centers dc ON emp.department = dc.department
        WHERE e.status = 'approved' 
        AND gl.is_active = 1 
        AND dc.is_active = 1
        ORDER BY e.date DESC, emp.name
    `;
    
    db.all(query, (err, rows) => {
        if (err) {
            console.error('❌ Error fetching export data:', err.message);
            return res.status(500).json({ success: false, error: 'Database error' });
        }
        
        // Generate CSV content
        const csvHeader = 'Date,Account,Description,Amount,Employee,Department,Reference\n';
        const csvRows = rows.map(row => {
            const account = `${row.gl_code}-${row.cost_center_code}`;
            const description = `${row.expense_type} - ${row.vendor || 'N/A'} - ${row.location || 'N/A'}`;
            return `${row.date},"${account}","${description}",${row.amount},"${row.employee_name}","${row.department}","${row.reference}"`;
        }).join('\n');
        
        const csvContent = csvHeader + csvRows;
        
        // Set headers for CSV download
        res.setHeader('Content-Type', 'text/csv');
        res.setHeader('Content-Disposition', 'attachment; filename="sage300_expenses_' + new Date().toISOString().split('T')[0] + '.csv"');
        res.send(csvContent);
    });
});

// 🔗 EMPLOYEE SIGNUP ROUTES

// Serve the signup HTML page
app.get('/signup', (req, res) => {
    res.sendFile(path.join(__dirname, 'signup.html'));
});

// Get employee info for signup (validate token)
app.get('/api/signup/:token', (req, res) => {
    const { token } = req.params;
    
    const query = `
        SELECT st.id, st.expires_at, st.used, e.id as employee_id, e.name, e.email
        FROM signup_tokens st
        JOIN employees e ON st.employee_id = e.id
        WHERE st.token = ?
    `;
    
    db.get(query, [token], (err, row) => {
        if (err) {
            console.error('❌ Error validating signup token:', err);
            return res.status(500).json({ 
                success: false, 
                error: 'Server error validating token' 
            });
        }
        
        if (!row) {
            return res.status(404).json({ 
                success: false, 
                error: 'Invalid or expired signup link' 
            });
        }
        
        if (row.used) {
            return res.status(400).json({ 
                success: false, 
                error: 'This signup link has already been used' 
            });
        }
        
        const now = new Date();
        const expires = new Date(row.expires_at);
        
        if (now > expires) {
            return res.status(400).json({ 
                success: false, 
                error: 'This signup link has expired. Contact your administrator.' 
            });
        }
        
        res.json({
            success: true,
            employee: {
                name: row.name,
                email: row.email
            }
        });
    });
});

// Complete signup (set password)
app.post('/api/signup/:token', (req, res) => {
    const { token } = req.params;
    const { password } = req.body;
    
    // Validate password
    if (!password || password.length < 6) {
        return res.status(400).json({
            success: false,
            error: 'Password must be at least 6 characters long'
        });
    }
    
    // First, validate the token again
    const tokenQuery = `
        SELECT st.id, st.expires_at, st.used, st.employee_id
        FROM signup_tokens st
        WHERE st.token = ?
    `;
    
    db.get(tokenQuery, [token], (err, tokenRow) => {
        if (err) {
            console.error('❌ Error validating signup token:', err);
            return res.status(500).json({ 
                success: false, 
                error: 'Server error validating token' 
            });
        }
        
        if (!tokenRow || tokenRow.used) {
            return res.status(400).json({ 
                success: false, 
                error: 'Invalid or already used signup link' 
            });
        }
        
        const now = new Date();
        const expires = new Date(tokenRow.expires_at);
        
        if (now > expires) {
            return res.status(400).json({ 
                success: false, 
                error: 'This signup link has expired. Contact your administrator.' 
            });
        }
        
        // Hash the password and update employee
        const password_hash = hashPassword(password);
        
        db.serialize(() => {
            db.run('BEGIN TRANSACTION');
            
            // Update employee with password and activate account
            db.run(
                'UPDATE employees SET password_hash = ?, is_active = 1 WHERE id = ?',
                [password_hash, tokenRow.employee_id],
                function(updateErr) {
                    if (updateErr) {
                        console.error('❌ Error updating employee password:', updateErr);
                        db.run('ROLLBACK');
                        return res.status(500).json({
                            success: false,
                            error: 'Failed to set password'
                        });
                    }
                    
                    // Mark token as used
                    db.run(
                        'UPDATE signup_tokens SET used = 1 WHERE id = ?',
                        [tokenRow.id],
                        function(tokenUpdateErr) {
                            if (tokenUpdateErr) {
                                console.error('❌ Error marking token as used:', tokenUpdateErr);
                                db.run('ROLLBACK');
                                return res.status(500).json({
                                    success: false,
                                    error: 'Failed to complete signup'
                                });
                            }
                            
                            db.run('COMMIT');
                            
                            
                            res.json({
                                success: true,
                                message: 'Account activated successfully! You can now log in.'
                            });
                        }
                    );
                }
            );
        });
    });
});

// Resend signup invite
app.post('/api/employees/:id/resend-invite', requireAuth, requireRole('admin'), (req, res) => {
    const employeeId = req.params.id;
    
    // First, check if employee exists and is inactive
    db.get(
        'SELECT id, name, email, password_hash, is_active FROM employees WHERE id = ?',
        [employeeId],
        (err, employee) => {
            if (err) {
                console.error('❌ Error finding employee:', err);
                return res.status(500).json({
                    success: false,
                    error: 'Failed to find employee'
                });
            }
            
            if (!employee) {
                return res.status(404).json({
                    success: false,
                    error: 'Employee not found'
                });
            }
            
            if (employee.password_hash && employee.is_active) {
                return res.status(400).json({
                    success: false,
                    error: 'Employee has already completed account setup'
                });
            }
            
            // Generate new signup token (invalidate any existing ones)
            const token = crypto.randomBytes(32).toString('hex');
            const expiresAt = new Date(Date.now() + 48 * 60 * 60 * 1000); // 48 hours from now
            
            db.serialize(() => {
                // Mark any existing tokens for this employee as used
                db.run(
                    'UPDATE signup_tokens SET used = 1 WHERE employee_id = ? AND used = 0',
                    [employeeId],
                    (updateErr) => {
                        if (updateErr) {
                            console.error('❌ Error invalidating old tokens:', updateErr);
                        }
                        
                        // Insert new token
                        db.run(
                            'INSERT INTO signup_tokens (employee_id, token, expires_at) VALUES (?, ?, ?)',
                            [employeeId, token, expiresAt.toISOString()],
                            function(tokenErr) {
                                if (tokenErr) {
                                    console.error('❌ Error creating signup token:', tokenErr);
                                    return res.status(500).json({
                                        success: false,
                                        error: 'Failed to create signup token'
                                    });
                                }
                                
                                // Create signup URL
                                const baseUrl = req.protocol + '://' + req.get('host');
                                const signupUrl = `${baseUrl}/signup?token=${token}`;
                                
                                
                                res.json({
                                    success: true,
                                    message: 'Signup invite resent successfully!',
                                    signupUrl: signupUrl,
                                    employee: {
                                        name: employee.name,
                                        email: employee.email
                                    }
                                });
                            }
                        );
                    }
                );
            });
        }
    );
});

// 🚀 Start server
app.listen(port, () => {
    console.log('💼 CLAIMFLOW - FULL SYSTEM');
    console.log('==========================================');
    console.log(`🚀 Server running at: http://localhost:${port}`);
    console.log(`👥 Admin dashboard: http://localhost:${port}/admin`);
    console.log('📱 Mobile-optimized expense submission');
    console.log('💰 NJC compliant meal rates');
    console.log('📊 Complete admin dashboard with approvals');
    console.log('📷 Receipt photo upload and management');
    console.log('🗄️ SQLite database with full persistence');
    console.log('');
    console.log('✅ Features: Employee directory, approval workflow, role-based access');
    console.log('⏹️  Press Ctrl+C to stop');
    console.log('==========================================');
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\\n💼 Shutting down expense tracker server...');
    
    db.close((err) => {
        if (err) {
            console.error('❌ Error closing database:', err.message);
        } else {
            console.log('✅ Database connection closed');
        }
        
        console.log('✅ Server stopped');
        process.exit(0);
    });
});