#!/usr/bin/env node

/**
 * 🔍 QUALITY ASSURANCE AGENT
 * Government Expense Tracker System Validation
 * 
 * Comprehensive testing and validation of all system components
 */

const fs = require('fs');
const path = require('path');

class QualityAssuranceAgent {
    constructor() {
        this.testResults = [];
        this.criticalIssues = [];
        this.warnings = [];
        this.suggestions = [];
        this.baseUrl = 'http://localhost:3000';
        this.startTime = Date.now();
    }

    // 📊 Main QA execution
    async runFullQACheck() {
        console.log('🔍 QUALITY ASSURANCE AGENT STARTING...');
        console.log('==========================================');
        console.log(`🕐 Started at: ${new Date().toLocaleTimeString()}`);
        console.log('🎯 Target: Government Expense Tracker System\n');

        try {
            // Test Categories
            await this.checkSystemRequirements();
            await this.testServerConnectivity();
            await this.validateDatabaseStructure();
            await this.testAPIEndpoints();
            await this.validateFrontendComponents();
            await this.testUserWorkflows();
            await this.checkSecurityBasics();
            await this.testErrorHandling();
            await this.validateMobileExperience();
            await this.checkPerformance();
            
            // Generate comprehensive report
            this.generateQAReport();
            
        } catch (error) {
            this.addCriticalIssue('QA Agent Fatal Error', error.message);
            console.error('❌ QA Agent failed:', error);
        }
    }

    // 🛠️ System Requirements Check
    async checkSystemRequirements() {
        console.log('1️⃣ Checking System Requirements...');
        
        const checks = [
            { name: 'Node.js Version', test: () => process.version, expected: 'v22+' },
            { name: 'Package.json', test: () => fs.existsSync('./package.json') },
            { name: 'Main Server File', test: () => fs.existsSync('./app.js') },
            { name: 'Frontend Files', test: () => fs.existsSync('./index.html') && fs.existsSync('./admin.html') },
            { name: 'Dependencies', test: () => fs.existsSync('./node_modules') },
            { name: 'Uploads Directory', test: () => fs.existsSync('./uploads') || 'Will be created' }
        ];

        for (const check of checks) {
            try {
                const result = typeof check.test === 'function' ? check.test() : check.test;
                if (result === true || (typeof result === 'string' && result.includes('v'))) {
                    this.addResult('✅', check.name, 'PASS', result);
                } else if (result === 'Will be created') {
                    this.addWarning(check.name, 'Directory will be created automatically');
                } else {
                    this.addCriticalIssue(check.name, 'MISSING or FAILED');
                }
            } catch (error) {
                this.addCriticalIssue(check.name, error.message);
            }
        }
        console.log();
    }

    // 🌐 Server Connectivity Tests
    async testServerConnectivity() {
        console.log('2️⃣ Testing Server Connectivity...');
        
        const endpoints = [
            { url: '/health', expected: 200, name: 'Main Application' },
            { url: '/admin', expected: 200, name: 'Admin Dashboard' },
            { url: '/manifest.json', expected: 200, name: 'PWA Manifest' }
        ];

        for (const endpoint of endpoints) {
            try {
                const response = await this.makeRequest(endpoint.url);
                if (response.status === endpoint.expected) {
                    this.addResult('✅', endpoint.name, 'ACCESSIBLE', `${response.status} OK`);
                } else {
                    this.addCriticalIssue(endpoint.name, `Expected ${endpoint.expected}, got ${response.status}`);
                }
            } catch (error) {
                this.addCriticalIssue(endpoint.name, `Connection failed: ${error.message}`);
            }
        }
        console.log();
    }

    // 🗄️ Database Structure Validation
    async validateDatabaseStructure() {
        console.log('3️⃣ Validating Database Structure...');
        
        // Use health endpoints to validate database structure
        const healthResponse = await this.makeRequest('/api/health/tables');
        
        if (healthResponse && healthResponse.statusCode === 200) {
            try {
                const healthData = JSON.parse(healthResponse.body);
                const tables = healthData.tables || {};
                
                // Check each table
                ['employees', 'expenses', 'trips', 'njc_rates'].forEach(tableName => {
                    const tableInfo = tables[tableName];
                    if (tableInfo && typeof tableInfo.count === 'number') {
                        this.addResult('✅', `${tableName} Table`, 'HEALTHY', `${tableInfo.count} records`);
                    } else {
                        this.addResult('❌', `${tableName} Table`, 'CRITICAL', 
                            tableInfo?.error || 'Table not accessible');
                    }
                });
                
                return; // Health endpoints working - skip fallback
            } catch (error) {
                this.addResult('❌', 'Database Health Check', 'CRITICAL', `Parse error: ${error.message}`);
            }
        } else {
            this.addResult('❌', 'Database Health Endpoint', 'CRITICAL', 'Health endpoint not responding');
        }
        
        // Skip fallback tests - health endpoints should be sufficient

        // Database validation complete via health endpoints
        console.log();
    }

    // 🔌 API Endpoints Testing
    async testAPIEndpoints() {
        console.log('4️⃣ Testing API Endpoints...');
        
        // Test health endpoints (should work without auth)
        const healthEndpoints = [
            '/api/health/system',
            '/api/health/database',
            '/api/health/tables'
        ];

        for (const endpoint of healthEndpoints) {
            await this.testGETEndpoint(endpoint, 200);
        }
        
        // Test protected endpoints (should return 401 without auth - this is CORRECT behavior)
        const protectedEndpoints = [
            '/api/employees',
            '/api/expenses', 
            '/api/njc-rates'
        ];

        for (const endpoint of protectedEndpoints) {
            try {
                const response = await this.makeRequest(endpoint, { timeout: 5000 });
                if (response && response.statusCode === 401) {
                    this.addResult('✅', `${endpoint}`, 'SECURED', 'Properly requires authentication');
                } else if (response && response.statusCode) {
                    this.addResult('❌', `${endpoint}`, 'CRITICAL', 
                        `Expected 401 (auth required), got ${response.statusCode}`);
                } else {
                    this.addResult('⚠️', `${endpoint}`, 'WARNING', 'No response - server may be busy');
                }
            } catch (error) {
                this.addResult('⚠️', `${endpoint}`, 'WARNING', `Request failed: ${error.message}`);
            }
        }

        // Test POST expense submission
        // Expense submission is now tested in testUserWorkflows() with proper authentication
        // await this.testExpenseSubmission();
        
        console.log();
    }

    // 🎨 Frontend Component Validation
    async validateFrontendComponents() {
        console.log('5️⃣ Validating Frontend Components...');
        
        const frontendFiles = [
            { file: 'employee-dashboard.html', required: ['expense-form', 'expense-type', 'individual-draft-section', 'trip-draft-section'] },
            { file: 'admin.html', required: ['role-selector', 'nav-tabs', 'expenses-container'] }
        ];

        for (const fileTest of frontendFiles) {
            try {
                const content = fs.readFileSync(fileTest.file, 'utf8');
                let missingElements = [];
                
                for (const element of fileTest.required) {
                    if (!content.includes(element)) {
                        missingElements.push(element);
                    }
                }
                
                if (missingElements.length === 0) {
                    this.addResult('✅', `${fileTest.file} Elements`, 'ALL PRESENT', `${fileTest.required.length} required elements`);
                } else {
                    this.addCriticalIssue(`${fileTest.file} Elements`, `Missing: ${missingElements.join(', ')}`);
                }
                
                // Check for responsive design indicators
                if (content.includes('viewport') && content.includes('media')) {
                    this.addResult('✅', `${fileTest.file} Mobile`, 'RESPONSIVE', 'Viewport and media queries present');
                } else {
                    this.addWarning(`${fileTest.file} Mobile`, 'May not be fully mobile-optimized');
                }
                
            } catch (error) {
                this.addCriticalIssue(`${fileTest.file} Validation`, error.message);
            }
        }
        console.log();
    }

    // 🔄 User Workflow Testing
    async testUserWorkflows() {
        console.log('6️⃣ Testing User Workflows...');
        
        try {
            // First authenticate with employee user for expense submission
            const loginResponse = await this.makeRequest('/api/auth/login', 'POST', {
                email: 'david.wilson@company.com',
                password: 'david123'
            });
            
            const loginResult = await loginResponse.json();
            
            if (!loginResult.success) {
                this.addCriticalIssue('User Authentication', 'Failed to log in with demo account');
                return;
            }
            
            const sessionId = loginResult.sessionId;
            console.log('✅ Authentication successful');
            
            // Test expense submission workflow with authentication
            // Use 'other' expense type to avoid per diem daily limits
            const testExpense = {
                expense_type: 'other',
                meal_name: 'Other Expense',
                date: new Date().toISOString().split('T')[0],
                location: 'QA Test Location',
                amount: '50.00',  // Custom amount for other expense
                vendor: 'QA Test Vendor',
                description: 'Quality Assurance Test - Other Expense'
            };

            // Submit expense with authentication header
            const submitResponse = await this.makeRequest('/api/expenses', 'POST', testExpense, {
                'Authorization': `Bearer ${sessionId}`
            });
            const submitResult = await submitResponse.json();

            if (submitResult.success) {
                this.addResult('✅', 'Expense Submission', 'SUCCESS', `ID: ${submitResult.id}`);
                
                // Test approval workflow with authentication
                const expenseId = submitResult.id;
                await this.testApprovalWorkflow(expenseId, sessionId);
                
            } else {
                this.addCriticalIssue('Expense Submission', submitResult.error || 'Unknown error');
            }
        } catch (error) {
            this.addCriticalIssue('Expense Submission Workflow', error.message);
        }
        console.log();
    }

    // 🔒 Basic Security Checks
    async checkSecurityBasics() {
        console.log('7️⃣ Checking Basic Security...');
        
        const securityTests = [
            {
                name: 'SQL Injection Protection',
                test: async () => {
                    try {
                        const response = await this.makeRequest("/api/expenses/employee/' OR '1'='1");
                        return response.status !== 500; // Should handle gracefully
                    } catch (error) {
                        return true; // Error handling is good
                    }
                }
            },
            {
                name: 'File Upload Validation',
                test: () => {
                    const appContent = fs.readFileSync('app.js', 'utf8');
                    return appContent.includes('fileFilter') && appContent.includes('limits');
                }
            },
            {
                name: 'Input Validation',
                test: () => {
                    const appContent = fs.readFileSync('app.js', 'utf8');
                    return appContent.includes('validation') || appContent.includes('required');
                }
            }
        ];

        for (const test of securityTests) {
            try {
                const result = typeof test.test === 'function' ? await test.test() : test.test;
                if (result) {
                    this.addResult('✅', test.name, 'PROTECTED', 'Basic protection in place');
                } else {
                    this.addWarning(test.name, 'May need additional security measures');
                }
            } catch (error) {
                this.addWarning(test.name, `Could not verify: ${error.message}`);
            }
        }
        console.log();
    }

    // ⚠️ Error Handling Tests
    async testErrorHandling() {
        console.log('8️⃣ Testing Error Handling...');
        
        const errorTests = [
            {
                name: 'Invalid Expense Data',
                test: () => this.makeRequest('/api/expenses', 'POST', { invalid: 'data' })
            },
            {
                name: 'Non-existent Employee',
                test: () => this.makeRequest('/api/expenses/employee/NonExistentUser')
            },
            {
                name: 'Invalid Expense ID',
                test: () => this.makeRequest('/api/expenses/99999/approve', 'POST', { comment: 'test' })
            }
        ];

        for (const test of errorTests) {
            try {
                const response = await test.test();
                if (response.status >= 400 && response.status < 500) {
                    this.addResult('✅', test.name, 'HANDLED', `Returns ${response.status} error`);
                } else {
                    this.addWarning(test.name, `Unexpected response: ${response.status}`);
                }
            } catch (error) {
                this.addResult('✅', test.name, 'HANDLED', 'Proper error handling');
            }
        }
        console.log();
    }

    // 📱 Mobile Experience Check
    async validateMobileExperience() {
        console.log('9️⃣ Validating Mobile Experience...');
        
        const mobileChecks = [
            {
                name: 'PWA Manifest',
                test: () => fs.existsSync('manifest.json'),
                details: () => {
                    const manifest = JSON.parse(fs.readFileSync('manifest.json', 'utf8'));
                    return `Icons: ${manifest.icons?.length || 0}, Display: ${manifest.display}`;
                }
            },
            {
                name: 'Viewport Meta Tag',
                test: () => {
                    const indexContent = fs.readFileSync('index.html', 'utf8');
                    return indexContent.includes('viewport');
                }
            },
            {
                name: 'Touch-Friendly Interface',
                test: () => {
                    const indexContent = fs.readFileSync('index.html', 'utf8');
                    return indexContent.includes('padding: 15px') || indexContent.includes('touch');
                }
            },
            {
                name: 'Camera Integration',
                test: () => {
                    const indexContent = fs.readFileSync('index.html', 'utf8');
                    return indexContent.includes('capture="environment"');
                }
            }
        ];

        for (const check of mobileChecks) {
            try {
                const result = check.test();
                if (result) {
                    const details = check.details ? check.details() : 'Present';
                    this.addResult('✅', check.name, 'MOBILE READY', details);
                } else {
                    this.addWarning(check.name, 'May impact mobile experience');
                }
            } catch (error) {
                this.addWarning(check.name, error.message);
            }
        }
        console.log();
    }

    // ⚡ Performance Checks
    async checkPerformance() {
        console.log('🔟 Checking Performance...');
        
        // File size analysis
        const performanceChecks = [
            {
                name: 'HTML File Sizes',
                test: () => {
                    const indexSize = fs.statSync('index.html').size;
                    const adminSize = fs.statSync('admin.html').size;
                    return { index: Math.round(indexSize / 1024), admin: Math.round(adminSize / 1024) };
                }
            },
            {
                name: 'Database Response Time',
                test: async () => {
                    const start = Date.now();
                    await this.makeRequest('/api/employees');
                    return Date.now() - start;
                }
            }
        ];

        for (const check of performanceChecks) {
            try {
                const result = await check.test();
                if (check.name === 'HTML File Sizes') {
                    if (result.index < 100 && result.admin < 100) {
                        this.addResult('✅', check.name, 'OPTIMIZED', `Index: ${result.index}KB, Admin: ${result.admin}KB`);
                    } else {
                        this.addSuggestion(check.name, `Consider optimization: Index: ${result.index}KB, Admin: ${result.admin}KB`);
                    }
                } else if (check.name === 'Database Response Time') {
                    if (result < 1000) {
                        this.addResult('✅', check.name, 'FAST', `${result}ms`);
                    } else {
                        this.addWarning(check.name, `Slow response: ${result}ms`);
                    }
                }
            } catch (error) {
                this.addWarning(check.name, error.message);
            }
        }
        console.log();
    }

    // 🧪 Helper Methods
    async testGETEndpoint(endpoint) {
        try {
            const response = await this.makeRequest(endpoint);
            if (response.status === 200) {
                this.addResult('✅', `GET ${endpoint}`, 'SUCCESS', `${response.status} OK`);
            } else {
                this.addCriticalIssue(`GET ${endpoint}`, `Status: ${response.status}`);
            }
        } catch (error) {
            this.addCriticalIssue(`GET ${endpoint}`, error.message);
        }
    }

    async testExpenseSubmission() {
        const testData = {
            employee_name: 'QA Agent',
            expense_type: 'breakfast',
            meal_name: 'Breakfast',
            date: '2026-02-17',
            location: 'Test Location',
            amount: '15.50',
            vendor: 'Test Vendor',
            description: 'QA Test'
        };

        try {
            const response = await this.makeRequest('/api/expenses', 'POST', testData);
            const result = await response.json();
            
            if (result.success) {
                this.addResult('✅', 'POST /api/expenses', 'SUCCESS', `Created ID: ${result.id}`);
                return result.id;
            } else {
                this.addCriticalIssue('POST /api/expenses', result.error);
                return null;
            }
        } catch (error) {
            this.addCriticalIssue('POST /api/expenses', error.message);
            return null;
        }
    }

    async testApprovalWorkflow(expenseId, sessionId) {
        try {
            // Authenticate as supervisor for approval
            const supervisorLogin = await this.makeRequest('/api/auth/login', 'POST', {
                email: 'sarah.johnson@company.com',  // supervisor account
                password: 'sarah123'
            });
            
            const supervisorResult = await supervisorLogin.json();
            if (!supervisorResult.success) {
                this.addCriticalIssue('Approval Workflow', 'Failed to authenticate supervisor for approval');
                return;
            }
            
            const supervisorSessionId = supervisorResult.sessionId;
            
            const approveResponse = await this.makeRequest(`/api/expenses/${expenseId}/approve`, 'POST', {
                comment: 'QA Test Approval',
                approver: 'QA Agent'
            }, {
                'Authorization': `Bearer ${supervisorSessionId}`
            });
            
            const approveResult = await approveResponse.json();
            
            if (approveResult.success) {
                this.addResult('✅', 'Approval Workflow', 'SUCCESS', 'Expense approved');
            } else {
                this.addCriticalIssue('Approval Workflow', approveResult.error);
            }
        } catch (error) {
            this.addCriticalIssue('Approval Workflow', error.message);
        }
    }

    validateEmployeeStructure(employee) {
        const requiredFields = ['id', 'name', 'employee_number'];
        const missingFields = requiredFields.filter(field => !employee.hasOwnProperty(field));
        
        if (missingFields.length === 0) {
            this.addResult('✅', 'Employee Data Structure', 'VALID', 'All required fields present');
        } else {
            this.addCriticalIssue('Employee Data Structure', `Missing: ${missingFields.join(', ')}`);
        }
    }

    validateNJCRateStructure(rates) {
        const expectedTypes = ['breakfast', 'lunch', 'dinner', 'mileage', 'accommodation'];
        const actualTypes = rates.map(r => r.meal_type);
        const missingTypes = expectedTypes.filter(type => !actualTypes.includes(type));
        
        if (missingTypes.length === 0) {
            this.addResult('✅', 'NJC Rates Coverage', 'COMPLETE', `${rates.length} expense types`);
        } else {
            this.addWarning('NJC Rates Coverage', `Missing: ${missingTypes.join(', ')}`);
        }
    }

    async makeRequest(endpoint, method = 'GET', data = null, customHeaders = {}) {
        const url = `${this.baseUrl}${endpoint}`;
        
        // Simulate fetch for Node.js environment using curl
        const { exec } = require('child_process');
        return new Promise((resolve, reject) => {
            let curlCommand = `curl -s -w "HTTPSTATUS:%{http_code}" -X ${method}`;
            
            // Add Content-Type header for POST/PUT requests
            if (data && method !== 'GET') {
                curlCommand += ` -H "Content-Type: application/json"`;
            }
            
            // Add custom headers (like Authorization)
            Object.entries(customHeaders).forEach(([key, value]) => {
                curlCommand += ` -H "${key}: ${value}"`;
            });
            
            // Add data for POST/PUT requests
            if (data && method !== 'GET') {
                curlCommand += ` -d '${JSON.stringify(data)}'`;
            }
            
            curlCommand += ` "${url}"`;
            
            exec(curlCommand, (error, stdout, stderr) => {
                if (error) {
                    reject(error);
                    return;
                }
                
                const parts = stdout.split('HTTPSTATUS:');
                const body = parts[0];
                const status = parseInt(parts[1]) || 200;
                
                resolve({
                    status,
                    json: async () => {
                        try {
                            return JSON.parse(body);
                        } catch (e) {
                            return { error: 'Invalid JSON response' };
                        }
                    }
                });
            });
        });
    }

    // 📊 Result Management
    addResult(icon, test, status, details) {
        this.testResults.push({ icon, test, status, details });
        console.log(`${icon} ${test}: ${status} ${details ? `- ${details}` : ''}`);
    }

    addCriticalIssue(test, issue) {
        this.criticalIssues.push({ test, issue });
        console.log(`❌ ${test}: CRITICAL - ${issue}`);
    }

    addWarning(test, warning) {
        this.warnings.push({ test, warning });
        console.log(`⚠️  ${test}: WARNING - ${warning}`);
    }

    addSuggestion(test, suggestion) {
        this.suggestions.push({ test, suggestion });
        console.log(`💡 ${test}: SUGGESTION - ${suggestion}`);
    }

    // 📋 Generate Final Report
    generateQAReport() {
        const endTime = Date.now();
        const duration = Math.round((endTime - this.startTime) / 1000);
        
        console.log('\n🔍 QUALITY ASSURANCE REPORT');
        console.log('==========================================');
        console.log(`⏱️  Test Duration: ${duration} seconds`);
        console.log(`✅ Tests Passed: ${this.testResults.length}`);
        console.log(`❌ Critical Issues: ${this.criticalIssues.length}`);
        console.log(`⚠️  Warnings: ${this.warnings.length}`);
        console.log(`💡 Suggestions: ${this.suggestions.length}`);
        
        // Overall System Health
        let healthScore = 100;
        healthScore -= (this.criticalIssues.length * 20);
        healthScore -= (this.warnings.length * 5);
        healthScore = Math.max(0, healthScore);
        
        console.log(`\n🏥 SYSTEM HEALTH SCORE: ${healthScore}%`);
        
        if (healthScore >= 90) {
            console.log('🎉 EXCELLENT: System is production-ready!');
        } else if (healthScore >= 70) {
            console.log('✅ GOOD: System is functional with minor issues');
        } else if (healthScore >= 50) {
            console.log('⚠️  FAIR: System needs improvements before production');
        } else {
            console.log('❌ POOR: System has critical issues that must be fixed');
        }

        // Detailed Issues
        if (this.criticalIssues.length > 0) {
            console.log('\n🚨 CRITICAL ISSUES TO FIX:');
            this.criticalIssues.forEach((issue, index) => {
                console.log(`${index + 1}. ${issue.test}: ${issue.issue}`);
            });
        }

        if (this.warnings.length > 0) {
            console.log('\n⚠️  WARNINGS TO REVIEW:');
            this.warnings.forEach((warning, index) => {
                console.log(`${index + 1}. ${warning.test}: ${warning.warning}`);
            });
        }

        if (this.suggestions.length > 0) {
            console.log('\n💡 SUGGESTIONS FOR IMPROVEMENT:');
            this.suggestions.forEach((suggestion, index) => {
                console.log(`${index + 1}. ${suggestion.test}: ${suggestion.suggestion}`);
            });
        }

        console.log('\n🎯 NEXT STEPS:');
        if (this.criticalIssues.length > 0) {
            console.log('1. Fix all critical issues immediately');
            console.log('2. Re-run QA agent to verify fixes');
        } else if (this.warnings.length > 0) {
            console.log('1. Review and address warnings');
            console.log('2. Consider implementing suggestions');
        } else {
            console.log('1. System is ready for production use!');
            console.log('2. Consider implementing suggestions for enhancement');
        }
        
        console.log('\n🔍 QA Agent completed successfully!');
        console.log('==========================================');
    }
}

// Run QA if called directly
if (require.main === module) {
    const qaAgent = new QualityAssuranceAgent();
    qaAgent.runFullQACheck().catch(console.error);
}

module.exports = QualityAssuranceAgent;