#!/usr/bin/env python3
"""
Script to add data-i18n attributes to all user-visible text in ClaimFlow HTML files.
This script will systematically add translation attributes to elements that need them.
"""
import re
import sys

def process_employee_dashboard():
    """Process employee-dashboard.html to add data-i18n attributes."""
    
    file_path = '/Users/tony/.openclaw/workspace/expense-app/employee-dashboard.html'
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Dictionary of text patterns to replace with data-i18n attributes
    replacements = [
        # Trip section
        (r'<h3[^>]*>📝 Add Expense to Trip</h3>', r'<h3 style="margin-bottom: 15px; color: #2c3e50;" data-i18n="add_expense_to_trip">📝 Add Expense to Trip</h3>'),
        (r'<label for="expense-type">What type of expense is this\? \*</label>', r'<label for="expense-type" data-i18n="what_expense_type">What type of expense is this? *</label>'),
        (r'>-- Select a trip --<', r' data-i18n="select_trip">-- Select a trip --<'),
        (r'<button[^>]*onclick="showTripModal\(\)"[^>]*>✈️ Create New Trip</button>', r'<button onclick="showTripModal()" class="btn btn-primary" style="margin-bottom: 15px;" data-i18n="create_new_trip">✈️ Create New Trip</button>'),
        (r'<button[^>]*onclick="loadTrips\(\)"[^>]*>🔄 Refresh</button>', r'<button onclick="loadTrips()" class="btn btn-light" title="Refresh trip list" data-i18n="refresh">🔄 Refresh</button>'),
        
        # Hotel fields
        (r'<label for="hotel-checkin">Check-in Date \*</label>', r'<label for="hotel-checkin" data-i18n="checkin_date">Check-in Date *</label>'),
        (r'<label for="hotel-checkout">Check-out Date \*</label>', r'<label for="hotel-checkout" data-i18n="checkout_date">Check-out Date *</label>'),
        
        # Location and other fields
        (r'<label for="expense-location"[^>]*>Location \*</label>', r'<label for="expense-location" data-i18n="location">Location *</label>'),
        (r'<label for="expense-vendor"[^>]*>Vendor/Establishment \*</label>', r'<label for="expense-vendor" data-i18n="vendor">Vendor/Establishment *</label>'),
        (r'<label for="expense-description"[^>]*>Description/Notes</label>', r'<label for="expense-description" data-i18n="description">Description/Notes</label>'),
        (r'<label[^>]*>Receipt/Invoice \*</label>', r'<label data-i18n="receipt">Receipt/Invoice *</label>'),
        
        # Buttons
        (r'<button[^>]*>🧳 Add Expense to Trip</button>', r'<button type="button" onclick="addExpenseToTrip()" class="btn btn-success" style="background: #28a745; color: white; padding: 15px 30px; font-size: 16px;" data-i18n="add_expense_to_trip">🧳 Add Expense to Trip</button>'),
        
        # Success/Error messages in other sections
        (r'<span id="success-text">Expense submitted successfully!</span>', r'<span id="success-text" data-i18n="expense_submitted_successfully">Expense submitted successfully!</span>'),
        (r'<span id="error-text">Something went wrong</span>', r'<span id="error-text" data-i18n="something_went_wrong">Something went wrong</span>'),
        
        # History section
        (r'<h3[^>]*>📜 Submitted Expenses</h3>', r'<h3 style="margin-bottom: 20px; color: #2c3e50;" data-i18n="submitted_expenses">📜 Submitted Expenses</h3>'),
        (r'placeholder="Filter by expense type, status, vendor, or amount\.\.\."', r'placeholder="Filter by expense type, status, vendor, or amount..." data-i18n="filter_placeholder"'),
        (r'<p[^>]*>No submitted expenses yet\.</p>', r'<p style="text-align: center; color: #6c757d; padding: 40px;" data-i18n="no_submitted_expenses">No submitted expenses yet.</p>'),
        (r'<p[^>]*>Start by submitting some expenses above!</p>', r'<p style="font-size: 14px; color: #6c757d;" data-i18n="start_by_submitting">Start by submitting some expenses above!</p>'),
        
        # Trip Modal
        (r'<h4[^>]*>✈️ Trip Creation</h4>', r'<h4 style="margin: 0 0 20px 0; color: #2c3e50;" data-i18n="trip_creation">✈️ Trip Creation</h4>'),
        (r'<button[^>]*onclick="closeTripModal\(\)"[^>]*>Close</button>', r'<button onclick="closeTripModal()" type="button" class="btn btn-light" data-i18n="close">Close</button>'),
        (r'<button[^>]*onclick="createTrip\(\)"[^>]*>Create Trip</button>', r'<button onclick="createTrip()" type="button" class="btn btn-primary" data-i18n="create_trip">Create Trip</button>'),
    ]
    
    # Apply replacements
    for pattern, replacement in replacements:
        content = re.sub(pattern, replacement, content, flags=re.MULTILINE | re.DOTALL)
    
    # Save the updated content
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("Updated employee-dashboard.html with data-i18n attributes")

def process_admin_dashboard():
    """Process admin.html to add data-i18n attributes."""
    
    file_path = '/Users/tony/.openclaw/workspace/expense-app/admin.html'
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Dictionary of text patterns to replace with data-i18n attributes
    replacements = [
        # Search and filters
        (r'<label for="expense-search"[^>]*>🔍 Search:</label>', r'<label for="expense-search" style="font-weight: 500; color: #495057;" data-i18n="search_label">🔍 Search:</label>'),
        (r'placeholder="Filter by employee name, expense type, status, or vendor\.\.\."', r'placeholder="Filter by employee name, expense type, status, or vendor..." data-i18n="search_expenses_placeholder"'),
        
        # Loading states
        (r'<p>Loading expenses\.\.\.</p>', r'<p data-i18n="loading_expenses">Loading expenses...</p>'),
        (r'<p>Loading employees\.\.\.</p>', r'<p data-i18n="loading_employees">Loading employees...</p>'),
        
        # Employee management
        (r'<strong>💡 Managing Employees</strong>', r'<strong data-i18n="managing_employees">💡 Managing Employees</strong>'),
        (r'<span id="employee-help-text">View and manage employee information\. Admins can add, edit, and organize reporting structure\.</span>', r'<span id="employee-help-text" data-i18n="admin_help_text">View and manage employee information. Admins can add, edit, and organize reporting structure.</span>'),
        
        # Add employee form
        (r'<h4[^>]*>➕ Add New Employee</h4>', r'<h4 style="margin-bottom: 15px; color: #2c3e50;" data-i18n="add_new_employee">➕ Add New Employee</h4>'),
        (r'<label for="new-employee-name">Full Name \*</label>', r'<label for="new-employee-name" data-i18n="full_name">Full Name *</label>'),
        (r'<label for="new-employee-number">Employee Number \*</label>', r'<label for="new-employee-number" data-i18n="employee_number">Employee Number *</label>'),
        (r'<label for="new-employee-position">Position</label>', r'<label for="new-employee-position" data-i18n="position">Position</label>'),
        (r'<label for="new-employee-department">Department</label>', r'<label for="new-employee-department" data-i18n="department">Department</label>'),
        (r'<label for="new-employee-supervisor">Reports To</label>', r'<label for="new-employee-supervisor" data-i18n="reports_to">Reports To</label>'),
        
        # Buttons
        (r'<button[^>]*onclick="showAddEmployeeForm\(\)"[^>]*>➕ Add New Employee</button>', r'<button class="btn btn-primary" onclick="showAddEmployeeForm()" id="add-employee-btn" style="display: none;" title="Add a new employee to the system" data-i18n="add_new_employee">➕ Add New Employee</button>'),
        (r'<button[^>]*onclick="saveEmployee\(\)"[^>]*>Save Employee</button>', r'<button onclick="saveEmployee()" class="btn btn-primary" data-i18n="save_employee">Save Employee</button>'),
        (r'<button[^>]*onclick="cancelAddEmployee\(\)"[^>]*>Cancel</button>', r'<button onclick="cancelAddEmployee()" class="btn btn-light" data-i18n="cancel_action">Cancel</button>'),
    ]
    
    # Apply replacements
    for pattern, replacement in replacements:
        content = re.sub(pattern, replacement, content, flags=re.MULTILINE | re.DOTALL)
    
    # Save the updated content
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("Updated admin.html with data-i18n attributes")

def process_login_page():
    """Process login.html - it appears to already have most data-i18n attributes."""
    print("login.html appears to already have most data-i18n attributes based on our earlier scan")

def main():
    """Main function to process all HTML files."""
    print("Adding data-i18n attributes to ClaimFlow HTML files...")
    
    try:
        process_employee_dashboard()
        process_admin_dashboard() 
        process_login_page()
        print("\n✅ All HTML files have been updated with data-i18n attributes!")
        print("Next step: Restart the server to test the translations.")
    except Exception as e:
        print(f"❌ Error: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())