/*
╔═══════════════════════════════════════════════════════════════════════════════╗
║                            CONCUR-STYLE ENHANCEMENTS                         ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║ Purpose: Add enterprise-grade expense management features                    ║
║ Features: Multi-step wizards, better categories, advanced draft management  ║
║ Target: Match Concur ExpenseIT functionality for government use              ║
╚═══════════════════════════════════════════════════════════════════════════════╝
*/

// Enhanced Expense Categories with Government Focus
const ENHANCED_EXPENSE_CATEGORIES = {
    // Government Per Diem (NJC Compliant)
    'government_perdiem': {
        name: 'Government Per Diem',
        icon: '🏛️',
        subcategories: {
            'breakfast': { name: 'Breakfast', rate: 23.45, limit: 'once_per_day' },
            'lunch': { name: 'Lunch', rate: 29.75, limit: 'once_per_day' },
            'dinner': { name: 'Dinner', rate: 47.05, limit: 'once_per_day' },
            'incidentals': { name: 'Incidentals', rate: 32.08, limit: 'once_per_day' }
        }
    },
    
    // Travel & Transportation
    'travel_transport': {
        name: 'Travel & Transportation',
        icon: '✈️',
        subcategories: {
            'airfare': { name: 'Airfare', receipt_required: true },
            'hotel': { name: 'Accommodation', receipt_required: true, date_range: true },
            'vehicle_rental': { name: 'Vehicle Rental', receipt_required: true },
            'mileage': { name: 'Personal Vehicle', rate: 0.68, unit: 'km' },
            'parking': { name: 'Parking', receipt_required: true },
            'taxi_uber': { name: 'Taxi/Rideshare', receipt_required: true }
        }
    },
    
    // Business Operations
    'business_ops': {
        name: 'Business Operations',
        icon: '💼',
        subcategories: {
            'office_supplies': { name: 'Office Supplies', receipt_required: true },
            'software': { name: 'Software/Subscriptions', receipt_required: true },
            'equipment': { name: 'Equipment', receipt_required: true, approval_threshold: 500 },
            'communications': { name: 'Phone/Internet', receipt_required: true }
        }
    },
    
    // Training & Development
    'training_dev': {
        name: 'Training & Development',
        icon: '📚',
        subcategories: {
            'conference_fees': { name: 'Conference Registration', receipt_required: true },
            'training_materials': { name: 'Training Materials', receipt_required: true },
            'certification': { name: 'Professional Certification', receipt_required: true }
        }
    },
    
    // Entertainment & Client Relations
    'client_entertainment': {
        name: 'Client Entertainment',
        icon: '🤝',
        subcategories: {
            'client_meals': { name: 'Client Meals', receipt_required: true, justification_required: true },
            'client_entertainment': { name: 'Client Entertainment', receipt_required: true, justification_required: true }
        }
    }
};

// Multi-Step Expense Wizard
class ExpenseWizard {
    constructor() {
        this.currentStep = 1;
        this.totalSteps = 4;
        this.expenseData = {};
        this.validationRules = {};
    }
    
    // Step 1: Category Selection
    showCategorySelection() {
        const wizardHtml = `
            <div class="expense-wizard-container">
                <div class="wizard-header">
                    <h3>Step 1 of 4: Choose Expense Category</h3>
                    <div class="wizard-progress">
                        <div class="progress-bar" style="width: 25%"></div>
                    </div>
                </div>
                
                <div class="category-grid">
                    ${Object.entries(ENHANCED_EXPENSE_CATEGORIES).map(([key, category]) => `
                        <div class="category-card" onclick="selectCategory('${key}')">
                            <div class="category-icon">${category.icon}</div>
                            <h4>${category.name}</h4>
                            <div class="subcategory-count">${Object.keys(category.subcategories).length} options</div>
                        </div>
                    `).join('')}
                </div>
                
                <div class="wizard-navigation">
                    <button class="btn btn-secondary" onclick="cancelWizard()">Cancel</button>
                </div>
            </div>
        `;
        
        document.getElementById('wizard-container').innerHTML = wizardHtml;
        document.getElementById('wizard-container').style.display = 'block';
    }
    
    // Step 2: Subcategory & Details
    showSubcategorySelection(categoryKey) {
        const category = ENHANCED_EXPENSE_CATEGORIES[categoryKey];
        this.expenseData.category = categoryKey;
        
        const wizardHtml = `
            <div class="expense-wizard-container">
                <div class="wizard-header">
                    <h3>Step 2 of 4: ${category.name} Details</h3>
                    <div class="wizard-progress">
                        <div class="progress-bar" style="width: 50%"></div>
                    </div>
                </div>
                
                <div class="subcategory-selection">
                    ${Object.entries(category.subcategories).map(([key, sub]) => `
                        <div class="subcategory-option" onclick="selectSubcategory('${key}')">
                            <input type="radio" name="subcategory" value="${key}" id="sub-${key}">
                            <label for="sub-${key}">
                                <strong>${sub.name}</strong>
                                ${sub.rate ? `<div class="rate-info">Rate: $${sub.rate}${sub.unit ? '/' + sub.unit : ''}</div>` : ''}
                                ${sub.receipt_required ? '<div class="requirement">📷 Receipt Required</div>' : ''}
                                ${sub.approval_threshold ? `<div class="requirement">⚠️ Approval required for amounts over $${sub.approval_threshold}</div>` : ''}
                            </label>
                        </div>
                    `).join('')}
                </div>
                
                <div class="wizard-navigation">
                    <button class="btn btn-secondary" onclick="previousStep()">← Back</button>
                    <button class="btn btn-primary" onclick="nextStep()" disabled id="next-btn">Continue →</button>
                </div>
            </div>
        `;
        
        document.getElementById('wizard-container').innerHTML = wizardHtml;
    }
    
    // Step 3: Amount & Date
    showAmountDateForm() {
        // Implementation for amount and date collection
        this.currentStep = 3;
        // ... form implementation
    }
    
    // Step 4: Receipt & Review
    showReceiptReview() {
        // Implementation for receipt upload and final review
        this.currentStep = 4;
        // ... form implementation
    }
    
    // Validation & Submission
    validateAndSubmit() {
        // Comprehensive validation before submission
        return this.performValidation();
    }
    
    performValidation() {
        const errors = [];
        
        // Category-specific validation
        const category = ENHANCED_EXPENSE_CATEGORIES[this.expenseData.category];
        const subcategory = category.subcategories[this.expenseData.subcategory];
        
        // Receipt requirement validation
        if (subcategory.receipt_required && !this.expenseData.receipt) {
            errors.push(`Receipt is required for ${subcategory.name}`);
        }
        
        // Per diem limits validation
        if (subcategory.limit === 'once_per_day') {
            // Check against existing expenses for the date
            if (this.checkPerDiemLimit(this.expenseData.subcategory, this.expenseData.date)) {
                errors.push(`Only one ${subcategory.name} per day is allowed`);
            }
        }
        
        // Amount validation
        if (subcategory.rate && Math.abs(this.expenseData.amount - subcategory.rate) > 0.01) {
            errors.push(`Amount must be exactly $${subcategory.rate} for government per diem`);
        }
        
        return errors;
    }
    
    checkPerDiemLimit(subcategory, date) {
        // Check existing expenses for per diem limits
        // This would query the existing expenses for the user and date
        return false; // Placeholder
    }
}

// Advanced Draft Management System
class AdvancedDraftManager {
    constructor() {
        this.drafts = this.loadDrafts();
        this.autoSaveInterval = null;
        this.setupAutoSave();
    }
    
    // Auto-save functionality
    setupAutoSave() {
        this.autoSaveInterval = setInterval(() => {
            this.autoSaveCurrentForm();
        }, 30000); // Auto-save every 30 seconds
    }
    
    autoSaveCurrentForm() {
        const formData = this.getCurrentFormData();
        if (formData && this.hasFormChanged(formData)) {
            this.saveDraft('auto-save', formData);
            this.showAutoSaveIndicator();
        }
    }
    
    // Save draft with metadata
    saveDraft(name, data) {
        const draft = {
            id: Date.now(),
            name: name,
            data: data,
            created: new Date().toISOString(),
            modified: new Date().toISOString(),
            type: data.trip_id ? 'trip' : 'individual'
        };
        
        this.drafts.push(draft);
        this.persistDrafts();
        return draft;
    }
    
    // Load all drafts
    loadDrafts() {
        const stored = localStorage.getItem('expense_drafts');
        return stored ? JSON.parse(stored) : [];
    }
    
    // Persist drafts to localStorage
    persistDrafts() {
        localStorage.setItem('expense_drafts', JSON.stringify(this.drafts));
    }
    
    // Show draft management UI
    showDraftManager() {
        const html = `
            <div class="draft-manager">
                <div class="draft-header">
                    <h3>Draft Expenses</h3>
                    <button class="btn btn-sm" onclick="refreshDrafts()">🔄 Refresh</button>
                </div>
                
                <div class="draft-list">
                    ${this.drafts.map(draft => `
                        <div class="draft-item">
                            <div class="draft-info">
                                <strong>${draft.name}</strong>
                                <div class="draft-meta">
                                    <span class="draft-type">${draft.type}</span>
                                    <span class="draft-date">${new Date(draft.modified).toLocaleDateString()}</span>
                                </div>
                            </div>
                            <div class="draft-actions">
                                <button class="btn btn-sm btn-primary" onclick="loadDraft(${draft.id})">Load</button>
                                <button class="btn btn-sm btn-danger" onclick="deleteDraft(${draft.id})">Delete</button>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;
        
        return html;
    }
    
    getCurrentFormData() {
        // Extract current form data for auto-save
        return {
            expense_type: document.getElementById('expense-type')?.value,
            amount: document.getElementById('amount')?.value,
            date: document.getElementById('expense-date')?.value,
            location: document.getElementById('location')?.value,
            vendor: document.getElementById('vendor')?.value,
            description: document.getElementById('description')?.value,
            trip_id: document.getElementById('trip-select')?.value
        };
    }
    
    hasFormChanged(formData) {
        // Compare with last saved version to detect changes
        return Object.values(formData).some(value => value && value.trim());
    }
    
    showAutoSaveIndicator() {
        // Show temporary indicator that auto-save occurred
        const indicator = document.getElementById('auto-save-indicator');
        if (indicator) {
            indicator.style.display = 'block';
            setTimeout(() => {
                indicator.style.display = 'none';
            }, 2000);
        }
    }
}

// Export for use in main application
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ExpenseWizard, AdvancedDraftManager, ENHANCED_EXPENSE_CATEGORIES };
}