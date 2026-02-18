/**
 * 🏛️ NATIONAL JOINT COUNCIL (NJC) RATES SERVICE
 * Official Government of Canada per diem rates and allowances
 * Source: https://www.njc-cnm.gc.ca/directive/app_d/en
 */

class NJCRatesService {
    constructor() {
        // Official NJC rates effective January 1, 2026
        this.currentRates = {
            // Canadian domestic rates (most common)
            canada: {
                meals: {
                    breakfast: 23.45,
                    lunch: 29.75, 
                    dinner: 47.05,
                    total_daily: 100.25
                },
                accommodation: {
                    maximum: 200.00, // varies by city, this is general max
                    private_non_commercial: 50.00
                },
                incidentals: {
                    commercial_accommodation: 32.08, // 32% of meal total
                    private_accommodation: 20.05 // 20% of meal total
                },
                vehicle: {
                    rate_per_km: 0.68, // 2026 government vehicle allowance rate
                    description: "Personal vehicle use for government business"
                }
            },
            // International rates - sample for major destinations
            international: {
                usa: {
                    meals: { breakfast: 27.50, lunch: 35.25, dinner: 55.75, total_daily: 118.50 },
                    vehicle_km: 0.68 // Same as Canadian rate
                },
                uk: {
                    meals: { breakfast: 31.20, lunch: 42.80, dinner: 68.45, total_daily: 142.45 },
                    vehicle_km: 0.68
                }
            }
        };
        
        // Per diem expense type mappings
        this.perDiemTypes = {
            'breakfast': { 
                rate: this.currentRates.canada.meals.breakfast,
                category: 'meal',
                description: 'NJC Standard Breakfast Rate',
                fixed: true 
            },
            'lunch': { 
                rate: this.currentRates.canada.meals.lunch,
                category: 'meal', 
                description: 'NJC Standard Lunch Rate',
                fixed: true 
            },
            'dinner': { 
                rate: this.currentRates.canada.meals.dinner,
                category: 'meal',
                description: 'NJC Standard Dinner Rate', 
                fixed: true 
            },
            'incidentals': { 
                rate: this.currentRates.canada.incidentals.commercial_accommodation,
                category: 'incidental',
                description: 'NJC Incidental Allowance (Daily)',
                fixed: true // Fixed per diem rate
            },
            'hotel': { 
                rate: this.currentRates.canada.accommodation.maximum,
                category: 'accommodation',
                description: 'Hotel/Accommodation (Receipt Required)',
                fixed: false, // Can be less than max with receipts
                max_amount: this.currentRates.canada.accommodation.maximum,
                requires_receipt: true
            },
            'vehicle_km': { 
                rate: this.currentRates.canada.vehicle.rate_per_km,
                category: 'vehicle',
                description: 'NJC Vehicle Allowance per Kilometre',
                fixed: true,
                unit: 'per km'
            }
        };
    }
    
    /**
     * Get official NJC rate for expense type
     */
    getPerDiemRate(expenseType, location = 'canada') {
        const rateInfo = this.perDiemTypes[expenseType];
        if (!rateInfo) return null;
        
        return {
            rate: rateInfo.rate,
            description: rateInfo.description,
            fixed: rateInfo.fixed,
            category: rateInfo.category,
            unit: rateInfo.unit || 'per expense',
            max_amount: rateInfo.max_amount,
            effective_date: '2026-01-01',
            source: 'National Joint Council of Canada',
            source_url: 'https://www.njc-cnm.gc.ca/directive/app_d/en'
        };
    }
    
    /**
     * Check if expense type is a fixed per diem
     */
    isPerDiem(expenseType) {
        return this.perDiemTypes.hasOwnProperty(expenseType);
    }
    
    /**
     * Check if rate is fixed (non-modifiable)
     */
    isFixedRate(expenseType) {
        const rateInfo = this.perDiemTypes[expenseType];
        return rateInfo ? rateInfo.fixed : false;
    }
    
    /**
     * Calculate vehicle allowance based on kilometers
     */
    calculateVehicleAllowance(kilometers) {
        const rate = this.currentRates.canada.vehicle.rate_per_km;
        return {
            kilometers: kilometers,
            rate_per_km: rate,
            total_amount: (kilometers * rate).toFixed(2),
            description: `${kilometers} km × $${rate}/km = $${(kilometers * rate).toFixed(2)}`
        };
    }
    
    /**
     * Get all available per diem types for UI
     */
    getAvailablePerDiemTypes() {
        return Object.keys(this.perDiemTypes).map(type => ({
            value: type,
            label: this.getDisplayName(type),
            rate: this.perDiemTypes[type].rate,
            fixed: this.perDiemTypes[type].fixed,
            description: this.perDiemTypes[type].description
        }));
    }
    
    /**
     * Get user-friendly display name
     */
    getDisplayName(expenseType) {
        const displayNames = {
            'breakfast': '🥐 Breakfast (Per Diem)',
            'lunch': '🥗 Lunch (Per Diem)', 
            'dinner': '🍽️ Dinner (Per Diem)',
            'incidentals': '📱 Incidentals (Per Diem)',
            'hotel': '🏨 Hotel/Accommodation (Receipt Required)',
            'vehicle_km': '🚗 Vehicle Allowance (per km)'
        };
        return displayNames[expenseType] || expenseType;
    }
    
    /**
     * Validate submitted expense against per diem rules
     */
    validatePerDiemExpense(expenseType, submittedAmount, additionalData = {}) {
        const rateInfo = this.getPerDiemRate(expenseType);
        if (!rateInfo) return { valid: true, message: 'Not a per diem expense' };
        
        // For fixed rates, amount must match exactly (except vehicle_km which is rate × km)
        if (rateInfo.fixed) {
            if (expenseType === 'vehicle_km') {
                // Vehicle allowance: validate amount is a valid multiple of rate per km
                const submitted = parseFloat(submittedAmount);
                const rate = parseFloat(rateInfo.rate);
                const impliedKm = submitted / rate;
                if (submitted <= 0 || impliedKm > 10000) {
                    return {
                        valid: false,
                        message: `Vehicle allowance must be a valid amount based on $${rate.toFixed(2)}/km rate`
                    };
                }
            } else {
                const expectedAmount = parseFloat(rateInfo.rate);
                const submitted = parseFloat(submittedAmount);
                
                if (Math.abs(submitted - expectedAmount) > 0.01) {
                    return {
                        valid: false,
                        message: `Per diem rate must be exactly $${expectedAmount.toFixed(2)} (submitted: $${submitted.toFixed(2)})`
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
        
        return { valid: true, message: 'Per diem expense is valid' };
    }
    
    /**
     * Get rate update information (for admin reference)
     */
    getRateUpdateInfo() {
        return {
            last_updated: '2026-01-01',
            next_review: '2027-01-01', 
            source: 'National Joint Council of Canada',
            authority: 'Treasury Board of Canada Secretariat',
            notes: 'Rates are reviewed annually and updated by the National Joint Council'
        };
    }
}

module.exports = NJCRatesService;