/**
 * 🏛️ NATIONAL JOINT COUNCIL (NJC) RATES SERVICE
 * Official Government of Canada per diem rates and allowances
 * Source: https://www.njc-cnm.gc.ca/directive/app_d/en
 * 
 * UPDATED: Now uses database with historical tracking for audit compliance
 */

const sqlite3 = require('sqlite3').verbose();
const path = require('path');

class NJCRatesService {
    constructor() {
        this.dbPath = path.join(__dirname, 'expenses.db');
        
        // Legacy display mappings for UI compatibility
        this.displayNames = {
            'breakfast': '🥐 Breakfast (Per Diem)',
            'lunch': '🥗 Lunch (Per Diem)', 
            'dinner': '🍽️ Dinner (Per Diem)',
            'incidentals': '📱 Incidentals (Per Diem)',
            'hotel': '🏨 Hotel/Accommodation (Receipt Required)',
            'private_vehicle': '🚗 Vehicle Allowance (per km)',
            'vehicle_km': '🚗 Vehicle Allowance (per km)' // Legacy alias
        };
        
        // Categories for grouping
        this.rateCategories = {
            'breakfast': 'meal',
            'lunch': 'meal',
            'dinner': 'meal', 
            'incidentals': 'incidental',
            'private_vehicle': 'vehicle',
            'vehicle_km': 'vehicle',
            'hotel': 'accommodation'
        };
    }
    
    /**
     * Get database connection
     */
    getDb() {
        return new sqlite3.Database(this.dbPath);
    }
    
    /**
     * Get current effective rates (where end_date IS NULL or end_date >= today)
     * @param {string} province - Province code (default: 'QC')
     */
    async getCurrentRates(province = 'QC') {
        return new Promise((resolve, reject) => {
            const db = this.getDb();
            const today = new Date().toISOString().split('T')[0];
            
            db.all(`
                SELECT rate_type, amount, effective_date, notes
                FROM njc_rates 
                WHERE (province = ? OR province = 'ALL') 
                AND effective_date <= ?
                AND (end_date IS NULL OR end_date >= ?)
                ORDER BY rate_type
            `, [province, today, today], (err, rows) => {
                db.close();
                if (err) reject(err);
                else resolve(rows);
            });
        });
    }
    
    /**
     * Get rates effective on a specific date (for historical validation)
     * @param {string} date - Date in YYYY-MM-DD format
     * @param {string} province - Province code (default: 'QC')
     */
    async getRatesForDate(date, province = 'QC') {
        return new Promise((resolve, reject) => {
            const db = this.getDb();
            
            db.all(`
                SELECT rate_type, amount, effective_date, end_date, notes
                FROM njc_rates 
                WHERE (province = ? OR province = 'ALL')
                AND effective_date <= ?
                AND (end_date IS NULL OR end_date >= ?)
                ORDER BY rate_type
            `, [province, date, date], (err, rows) => {
                db.close();
                if (err) reject(err);
                else resolve(rows);
            });
        });
    }
    
    /**
     * Get all rates (current + historical) for admin interface
     * @param {string} province - Province code (default: 'QC')
     */
    async getAllRates(province = 'QC') {
        return new Promise((resolve, reject) => {
            const db = this.getDb();
            
            db.all(`
                SELECT id, rate_type, amount, effective_date, end_date, notes, created_by, created_at
                FROM njc_rates 
                WHERE (province = ? OR province = 'ALL')
                ORDER BY rate_type, effective_date DESC
            `, [province], (err, rows) => {
                db.close();
                if (err) reject(err);
                else {
                    // Group by rate type
                    const grouped = {};
                    rows.forEach(row => {
                        if (!grouped[row.rate_type]) {
                            grouped[row.rate_type] = [];
                        }
                        grouped[row.rate_type].push(row);
                    });
                    resolve(grouped);
                }
            });
        });
    }
    
    /**
     * Get official NJC rate for expense type on a specific date
     * @param {string} expenseType - Type of expense
     * @param {string} expenseDate - Date of expense (YYYY-MM-DD)
     * @param {string} location - Location/province (default: 'QC')
     */
    async getPerDiemRate(expenseType, expenseDate = null, location = 'QC') {
        try {
            // Handle legacy vehicle_km mapping
            if (expenseType === 'vehicle_km') {
                expenseType = 'private_vehicle';
            }
            
            const date = expenseDate || new Date().toISOString().split('T')[0];
            const rates = await this.getRatesForDate(date, location);
            const rate = rates.find(r => r.rate_type === expenseType);
            
            if (!rate) return null;
            
            return {
                rate: rate.amount,
                description: this.getDescription(expenseType, rate.amount),
                fixed: this.isFixedRate(expenseType),
                category: this.rateCategories[expenseType] || 'other',
                unit: expenseType === 'private_vehicle' ? 'per km' : 'per expense',
                max_amount: expenseType === 'hotel' ? 200.00 : null, // Hotel max
                effective_date: rate.effective_date,
                end_date: rate.end_date,
                source: 'National Joint Council of Canada',
                source_url: 'https://www.njc-cnm.gc.ca/directive/app_d/en'
            };
        } catch (error) {
            console.error('Error getting per diem rate:', error);
            return null;
        }
    }
    
    /**
     * Check if expense type is a fixed per diem
     */
    isPerDiem(expenseType) {
        const perDiemTypes = ['breakfast', 'lunch', 'dinner', 'incidentals', 'private_vehicle', 'vehicle_km'];
        return perDiemTypes.includes(expenseType);
    }
    
    /**
     * Check if rate is fixed (non-modifiable)
     */
    isFixedRate(expenseType) {
        const fixedTypes = ['breakfast', 'lunch', 'dinner', 'incidentals', 'private_vehicle', 'vehicle_km'];
        return fixedTypes.includes(expenseType);
    }
    
    /**
     * Get description for rate type
     */
    getDescription(rateType, amount) {
        const descriptions = {
            'breakfast': `NJC Standard Breakfast Rate - $${amount.toFixed(2)}`,
            'lunch': `NJC Standard Lunch Rate - $${amount.toFixed(2)}`,
            'dinner': `NJC Standard Dinner Rate - $${amount.toFixed(2)}`,
            'incidentals': `NJC Incidental Allowance (Daily) - $${amount.toFixed(2)}`,
            'private_vehicle': `NJC Vehicle Allowance - $${amount.toFixed(2)}/km`,
            'hotel': 'Hotel/Accommodation (Receipt Required)'
        };
        return descriptions[rateType] || `${rateType} - $${amount.toFixed(2)}`;
    }
    
    /**
     * Calculate vehicle allowance based on kilometers and date
     */
    async calculateVehicleAllowance(kilometers, expenseDate = null) {
        try {
            const rateInfo = await this.getPerDiemRate('private_vehicle', expenseDate);
            if (!rateInfo) return null;
            
            const rate = rateInfo.rate;
            return {
                kilometers: kilometers,
                rate_per_km: rate,
                total_amount: (kilometers * rate).toFixed(2),
                description: `${kilometers} km × $${rate.toFixed(2)}/km = $${(kilometers * rate).toFixed(2)}`,
                effective_date: rateInfo.effective_date
            };
        } catch (error) {
            console.error('Error calculating vehicle allowance:', error);
            return null;
        }
    }
    
    /**
     * Get all available per diem types for UI
     */
    async getAvailablePerDiemTypes() {
        try {
            const currentRates = await this.getCurrentRates();
            return currentRates.map(rate => ({
                value: rate.rate_type,
                label: this.getDisplayName(rate.rate_type),
                rate: rate.amount,
                fixed: this.isFixedRate(rate.rate_type),
                description: this.getDescription(rate.rate_type, rate.amount)
            }));
        } catch (error) {
            console.error('Error getting available per diem types:', error);
            return [];
        }
    }
    
    /**
     * Get user-friendly display name
     */
    getDisplayName(expenseType) {
        return this.displayNames[expenseType] || expenseType;
    }
    
    /**
     * Validate submitted expense against per diem rules using historical rates
     * @param {string} expenseType - Type of expense
     * @param {number} submittedAmount - Amount submitted
     * @param {string} expenseDate - Date of the expense (YYYY-MM-DD)
     * @param {object} additionalData - Additional validation data
     */
    async validatePerDiemExpense(expenseType, submittedAmount, expenseDate, additionalData = {}) {
        try {
            const rateInfo = await this.getPerDiemRate(expenseType, expenseDate);
            if (!rateInfo) return { valid: true, message: 'Not a per diem expense' };
            
            // For fixed rates, amount must match exactly (except vehicle which is rate × km)
            if (rateInfo.fixed) {
                if (expenseType === 'private_vehicle' || expenseType === 'vehicle_km') {
                    // Vehicle allowance: validate amount is a valid multiple of rate per km
                    const submitted = parseFloat(submittedAmount);
                    const rate = parseFloat(rateInfo.rate);
                    const impliedKm = submitted / rate;
                    if (submitted <= 0 || impliedKm > 10000 || Math.abs(impliedKm - Math.round(impliedKm * 100) / 100) > 0.01) {
                        return {
                            valid: false,
                            message: `Vehicle allowance must be a valid amount based on $${rate.toFixed(2)}/km rate (effective ${rateInfo.effective_date})`
                        };
                    }
                } else {
                    const expectedAmount = parseFloat(rateInfo.rate);
                    const submitted = parseFloat(submittedAmount);
                    
                    if (Math.abs(submitted - expectedAmount) > 0.01) {
                        return {
                            valid: false,
                            message: `Per diem rate must be exactly $${expectedAmount.toFixed(2)} (submitted: $${submitted.toFixed(2)}) - Rate effective ${rateInfo.effective_date}`
                        };
                    }
                }
            }
            
            // For accommodation/hotel, check against maximum
            if ((expenseType === 'accommodation' || expenseType === 'hotel') && rateInfo.max_amount) {
                const submitted = parseFloat(submittedAmount);
                if (submitted > rateInfo.max_amount) {
                    return {
                        valid: false,
                        message: `${expenseType.charAt(0).toUpperCase() + expenseType.slice(1)} expense exceeds NJC maximum of $${rateInfo.max_amount.toFixed(2)}`
                    };
                }
            }
            
            return { 
                valid: true, 
                message: `Per diem expense is valid using rate effective ${rateInfo.effective_date}`,
                rate_info: rateInfo
            };
        } catch (error) {
            console.error('Error validating per diem expense:', error);
            return { 
                valid: false, 
                message: 'Error validating expense - please try again'
            };
        }
    }
    
    /**
     * Add new rate (admin function)
     * @param {string} rateType - Type of rate
     * @param {number} amount - Rate amount
     * @param {string} effectiveDate - Effective date (YYYY-MM-DD)
     * @param {string} province - Province code
     * @param {string} notes - Notes
     * @param {string} createdBy - User who created the rate
     */
    async addNewRate(rateType, amount, effectiveDate, province = 'QC', notes = '', createdBy = 'admin') {
        return new Promise((resolve, reject) => {
            const db = this.getDb();
            
            db.serialize(() => {
                // Start transaction
                db.run('BEGIN TRANSACTION');
                
                // Update previous rate's end_date
                const previousDayDate = new Date(effectiveDate);
                previousDayDate.setDate(previousDayDate.getDate() - 1);
                const endDate = previousDayDate.toISOString().split('T')[0];
                
                db.run(`
                    UPDATE njc_rates 
                    SET end_date = ?
                    WHERE rate_type = ? AND (province = ? OR province = 'ALL') AND end_date IS NULL
                `, [endDate, rateType, province], function(err) {
                    if (err) {
                        db.run('ROLLBACK');
                        db.close();
                        return reject(err);
                    }
                    
                    // Insert new rate
                    db.run(`
                        INSERT INTO njc_rates (rate_type, amount, effective_date, province, notes, created_by)
                        VALUES (?, ?, ?, ?, ?, ?)
                    `, [rateType, amount, effectiveDate, province, notes, createdBy], function(err) {
                        if (err) {
                            db.run('ROLLBACK');
                            db.close();
                            return reject(err);
                        }
                        
                        db.run('COMMIT');
                        db.close();
                        resolve({ id: this.lastID, success: true });
                    });
                });
            });
        });
    }
    
    /**
     * Get rate update information (for admin reference)
     */
    getRateUpdateInfo() {
        return {
            last_updated: '2024-04-01',
            next_review: '2025-04-01', 
            source: 'National Joint Council of Canada',
            authority: 'Treasury Board of Canada Secretariat',
            notes: 'Rates are reviewed annually and updated by the National Joint Council'
        };
    }
}

module.exports = NJCRatesService;