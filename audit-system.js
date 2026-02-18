/*
╔═══════════════════════════════════════════════════════════════════════════════╗
║                              AUDIT TRAIL SYSTEM                              ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║ Purpose: Comprehensive audit logging for government compliance               ║
║ Features: Action tracking, user activity, data change logs, export reports  ║
║ Compliance: Government auditing standards, SOX compliance ready             ║
╚═══════════════════════════════════════════════════════════════════════════════╝
*/

const fs = require('fs').promises;
const path = require('path');

class AuditTrailSystem {
    constructor(dbConnection) {
        this.db = dbConnection;
        this.auditLogPath = path.join(__dirname, 'logs', 'audit.log');
        this.setupAuditTables();
    }

    // Initialize audit database tables
    async setupAuditTables() {
        const auditTableSQL = `
            CREATE TABLE IF NOT EXISTS audit_log (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                user_id INTEGER,
                user_email TEXT,
                action_type TEXT NOT NULL,
                resource_type TEXT NOT NULL,
                resource_id TEXT,
                old_values TEXT,
                new_values TEXT,
                ip_address TEXT,
                user_agent TEXT,
                session_id TEXT,
                status TEXT DEFAULT 'success',
                details TEXT,
                risk_level TEXT DEFAULT 'low',
                FOREIGN KEY (user_id) REFERENCES employees (id)
            )
        `;

        const expenseHistorySQL = `
            CREATE TABLE IF NOT EXISTS expense_history (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                expense_id INTEGER NOT NULL,
                changed_by INTEGER,
                changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                field_name TEXT,
                old_value TEXT,
                new_value TEXT,
                change_reason TEXT,
                FOREIGN KEY (expense_id) REFERENCES expenses (id),
                FOREIGN KEY (changed_by) REFERENCES employees (id)
            )
        `;

        const loginHistorySQL = `
            CREATE TABLE IF NOT EXISTS login_history (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER,
                email TEXT,
                login_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                logout_time DATETIME,
                ip_address TEXT,
                user_agent TEXT,
                login_status TEXT DEFAULT 'success',
                failure_reason TEXT,
                session_duration INTEGER,
                FOREIGN KEY (user_id) REFERENCES employees (id)
            )
        `;

        await this.db.exec(auditTableSQL);
        await this.db.exec(expenseHistorySQL);
        await this.db.exec(loginHistorySQL);

        // Create audit log directory
        await this.ensureLogDirectory();
    }

    async ensureLogDirectory() {
        const logDir = path.dirname(this.auditLogPath);
        try {
            await fs.access(logDir);
        } catch {
            await fs.mkdir(logDir, { recursive: true });
        }
    }

    // Core audit logging function
    async logAction(actionData) {
        const {
            userId,
            userEmail,
            actionType,
            resourceType,
            resourceId,
            oldValues = null,
            newValues = null,
            ipAddress,
            userAgent,
            sessionId,
            status = 'success',
            details = '',
            riskLevel = 'low'
        } = actionData;

        // Database logging
        const sql = `
            INSERT INTO audit_log (
                user_id, user_email, action_type, resource_type, resource_id,
                old_values, new_values, ip_address, user_agent, session_id,
                status, details, risk_level
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;

        await this.db.run(sql, [
            userId, userEmail, actionType, resourceType, resourceId,
            JSON.stringify(oldValues), JSON.stringify(newValues),
            ipAddress, userAgent, sessionId, status, details, riskLevel
        ]);

        // File logging for backup
        await this.logToFile(actionData);

        // Real-time alerting for high-risk actions
        if (riskLevel === 'high') {
            await this.triggerSecurityAlert(actionData);
        }
    }

    // File-based audit logging
    async logToFile(actionData) {
        const timestamp = new Date().toISOString();
        const logEntry = {
            timestamp,
            ...actionData
        };

        const logLine = JSON.stringify(logEntry) + '\n';
        await fs.appendFile(this.auditLogPath, logLine);
    }

    // Specific audit methods for common actions
    async logExpenseCreation(userId, userEmail, expenseData, metadata) {
        await this.logAction({
            userId,
            userEmail,
            actionType: 'CREATE',
            resourceType: 'expense',
            resourceId: expenseData.id,
            newValues: expenseData,
            ...metadata,
            details: `Created ${expenseData.expense_type} expense for $${expenseData.amount}`
        });
    }

    async logExpenseModification(userId, userEmail, expenseId, oldData, newData, metadata) {
        // Track individual field changes
        const changes = this.calculateFieldChanges(oldData, newData);
        
        await this.logAction({
            userId,
            userEmail,
            actionType: 'UPDATE',
            resourceType: 'expense',
            resourceId: expenseId,
            oldValues: oldData,
            newValues: newData,
            ...metadata,
            details: `Modified expense: ${changes.join(', ')}`
        });

        // Log detailed field changes
        for (const change of changes) {
            await this.logFieldChange(expenseId, userId, change.field, change.oldValue, change.newValue);
        }
    }

    async logExpenseApproval(userId, userEmail, expenseId, approvalData, metadata) {
        await this.logAction({
            userId,
            userEmail,
            actionType: 'APPROVE',
            resourceType: 'expense',
            resourceId: expenseId,
            newValues: approvalData,
            ...metadata,
            details: `Approved expense with comment: "${approvalData.comment}"`,
            riskLevel: 'medium'
        });
    }

    async logLogin(userId, email, loginData) {
        const sql = `
            INSERT INTO login_history (
                user_id, email, ip_address, user_agent, login_status, failure_reason
            ) VALUES (?, ?, ?, ?, ?, ?)
        `;

        await this.db.run(sql, [
            userId, email, loginData.ipAddress, loginData.userAgent,
            loginData.status, loginData.failureReason || null
        ]);

        await this.logAction({
            userId,
            userEmail: email,
            actionType: loginData.status === 'success' ? 'LOGIN' : 'LOGIN_FAILED',
            resourceType: 'session',
            resourceId: loginData.sessionId,
            ipAddress: loginData.ipAddress,
            userAgent: loginData.userAgent,
            sessionId: loginData.sessionId,
            status: loginData.status,
            details: loginData.failureReason || 'Successful login',
            riskLevel: loginData.status === 'success' ? 'low' : 'medium'
        });
    }

    async logLogout(userId, email, sessionData) {
        // Update login history with logout time
        const updateSQL = `
            UPDATE login_history 
            SET logout_time = CURRENT_TIMESTAMP,
                session_duration = (strftime('%s', 'now') - strftime('%s', login_time))
            WHERE user_id = ? AND session_id = ? AND logout_time IS NULL
        `;
        
        await this.db.run(updateSQL, [userId, sessionData.sessionId]);

        await this.logAction({
            userId,
            userEmail: email,
            actionType: 'LOGOUT',
            resourceType: 'session',
            resourceId: sessionData.sessionId,
            ...sessionData,
            details: 'User logged out'
        });
    }

    // Field-level change tracking
    async logFieldChange(expenseId, changedBy, fieldName, oldValue, newValue, reason = '') {
        const sql = `
            INSERT INTO expense_history (
                expense_id, changed_by, field_name, old_value, new_value, change_reason
            ) VALUES (?, ?, ?, ?, ?, ?)
        `;

        await this.db.run(sql, [expenseId, changedBy, fieldName, oldValue, newValue, reason]);
    }

    // Calculate field-level changes
    calculateFieldChanges(oldData, newData) {
        const changes = [];
        const fields = ['amount', 'expense_type', 'date', 'location', 'vendor', 'description', 'status'];

        for (const field of fields) {
            if (oldData[field] !== newData[field]) {
                changes.push({
                    field,
                    oldValue: oldData[field],
                    newValue: newData[field]
                });
            }
        }

        return changes;
    }

    // Security alert system
    async triggerSecurityAlert(actionData) {
        console.warn('🚨 HIGH RISK ACTION DETECTED:', actionData);
        
        // In production, this would send alerts to security team
        // Could integrate with email, Slack, SMS, etc.
        
        const alertData = {
            timestamp: new Date().toISOString(),
            severity: 'HIGH',
            action: actionData.actionType,
            user: actionData.userEmail,
            resource: `${actionData.resourceType}:${actionData.resourceId}`,
            details: actionData.details
        };

        // Log to special security log
        const securityLogPath = path.join(__dirname, 'logs', 'security-alerts.log');
        await fs.appendFile(securityLogPath, JSON.stringify(alertData) + '\n');
    }

    // Audit report generation
    async generateAuditReport(criteria = {}) {
        const {
            startDate = '2026-01-01',
            endDate = '2026-12-31',
            userId = null,
            actionType = null,
            resourceType = null
        } = criteria;

        let sql = `
            SELECT 
                a.*,
                e.name as user_name,
                e.employee_number,
                e.department
            FROM audit_log a
            LEFT JOIN employees e ON a.user_id = e.id
            WHERE a.timestamp BETWEEN ? AND ?
        `;

        const params = [startDate, endDate];

        if (userId) {
            sql += ' AND a.user_id = ?';
            params.push(userId);
        }

        if (actionType) {
            sql += ' AND a.action_type = ?';
            params.push(actionType);
        }

        if (resourceType) {
            sql += ' AND a.resource_type = ?';
            params.push(resourceType);
        }

        sql += ' ORDER BY a.timestamp DESC';

        return new Promise((resolve, reject) => {
            this.db.all(sql, params, (err, rows) => {
                if (err) reject(err);
                else resolve(rows);
            });
        });
    }

    // Export audit data to CSV
    async exportAuditToCSV(criteria = {}) {
        const auditData = await this.generateAuditReport(criteria);
        
        const csvHeader = 'Timestamp,User Name,Employee Number,Department,Action Type,Resource Type,Resource ID,Status,Details,IP Address\n';
        
        const csvRows = auditData.map(row => {
            return [
                row.timestamp,
                row.user_name || 'Unknown',
                row.employee_number || 'N/A',
                row.department || 'N/A',
                row.action_type,
                row.resource_type,
                row.resource_id || 'N/A',
                row.status,
                (row.details || '').replace(/,/g, ';'), // Escape commas
                row.ip_address || 'Unknown'
            ].join(',');
        }).join('\n');

        const csvContent = csvHeader + csvRows;
        
        // Save to file
        const exportPath = path.join(__dirname, 'exports', `audit-report-${Date.now()}.csv`);
        await fs.mkdir(path.dirname(exportPath), { recursive: true });
        await fs.writeFile(exportPath, csvContent);
        
        return exportPath;
    }

    // Dashboard analytics
    async getAuditAnalytics(timeframe = '30d') {
        const daysBack = timeframe === '30d' ? 30 : 7;
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - daysBack);

        const analytics = {
            totalActions: await this.getActionCount(startDate),
            actionsByType: await this.getActionsByType(startDate),
            userActivity: await this.getMostActiveUsers(startDate),
            riskDistribution: await this.getRiskDistribution(startDate),
            recentHighRiskActions: await this.getRecentHighRiskActions()
        };

        return analytics;
    }

    // Helper methods for analytics
    async getActionCount(startDate) {
        const sql = 'SELECT COUNT(*) as count FROM audit_log WHERE timestamp >= ?';
        return new Promise((resolve, reject) => {
            this.db.get(sql, [startDate.toISOString()], (err, row) => {
                if (err) reject(err);
                else resolve(row.count);
            });
        });
    }

    async getActionsByType(startDate) {
        const sql = `
            SELECT action_type, COUNT(*) as count 
            FROM audit_log 
            WHERE timestamp >= ? 
            GROUP BY action_type 
            ORDER BY count DESC
        `;
        
        return new Promise((resolve, reject) => {
            this.db.all(sql, [startDate.toISOString()], (err, rows) => {
                if (err) reject(err);
                else resolve(rows);
            });
        });
    }

    async getMostActiveUsers(startDate) {
        const sql = `
            SELECT 
                a.user_email,
                e.name,
                COUNT(*) as action_count
            FROM audit_log a
            LEFT JOIN employees e ON a.user_id = e.id
            WHERE a.timestamp >= ?
            GROUP BY a.user_id, a.user_email, e.name
            ORDER BY action_count DESC
            LIMIT 10
        `;
        
        return new Promise((resolve, reject) => {
            this.db.all(sql, [startDate.toISOString()], (err, rows) => {
                if (err) reject(err);
                else resolve(rows);
            });
        });
    }

    async getRiskDistribution(startDate) {
        const sql = `
            SELECT risk_level, COUNT(*) as count 
            FROM audit_log 
            WHERE timestamp >= ? 
            GROUP BY risk_level
        `;
        
        return new Promise((resolve, reject) => {
            this.db.all(sql, [startDate.toISOString()], (err, rows) => {
                if (err) reject(err);
                else resolve(rows);
            });
        });
    }

    async getRecentHighRiskActions() {
        const sql = `
            SELECT 
                a.*,
                e.name as user_name
            FROM audit_log a
            LEFT JOIN employees e ON a.user_id = e.id
            WHERE a.risk_level = 'high'
            ORDER BY a.timestamp DESC
            LIMIT 20
        `;
        
        return new Promise((resolve, reject) => {
            this.db.all(sql, [], (err, rows) => {
                if (err) reject(err);
                else resolve(rows);
            });
        });
    }
}

module.exports = { AuditTrailSystem };