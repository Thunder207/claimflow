# Draft Editing Feature Test Plan
**Date:** 2026-03-06  
**Feature:** Allow editing of draft expenses before submission  
**Version:** v8.4-draft-editing  

## Overview
Employees can now edit draft expenses before submitting them for approval. This includes modifying amounts, categories, vendors, details, receipts, and adding/removing line items.

## Test Scenarios

### Test 1: Edit Button Appears Only on Drafts
**Steps:**
1. Create a new expense claim (don't submit)
2. Verify "✏️ Edit" button appears next to the draft
3. Submit the draft
4. Verify "✏️ Edit" button no longer appears (status = pending)

**Expected:** Edit button only visible for draft status

### Test 2: Edit Form Pre-fills Correctly  
**Steps:**
1. Create a draft with 2 items:
   - Purchase/Supply: $50, Vendor: "Office Depot", Details: "Supplies"
   - Kilometric: 25km
2. Click "✏️ Edit" 
3. Verify all fields are pre-filled with correct data
4. Verify kilometric shows calculated amount ($15.25)

**Expected:** All form fields show existing draft data

### Test 3: Modify Line Item Amount
**Steps:**
1. Edit a draft with Purchase item: $50
2. Change amount from $50 to $75
3. Click "💾 Save Changes"  
4. Verify draft now shows $75
5. Verify total is recalculated

**Expected:** Amount updated, total recalculated

### Test 4: Change Category
**Steps:**
1. Edit a draft with Purchase/Supply item
2. Change category to "Parking"
3. Save changes
4. Verify category changed to 🅿️ Parking

**Expected:** Category updated with correct icon

### Test 5: Kilometric Amount Calculation
**Steps:**
1. Edit a draft with Kilometric item
2. Change km from 20 to 100
3. Verify amount updates automatically to $61.00 (100 × $0.61)
4. Change km to 6000  
5. Verify amount updates to $3602.50 (5000×$0.61 + 1000×$0.55)

**Expected:** Kilometric amounts calculated correctly using NJC rates

### Test 6: Add New Line Item
**Steps:**
1. Edit a draft with 1 item
2. Click "+ Add Item"
3. Verify new item appears with default "Purchase/Supply"
4. Fill in: Parking, $15, vendor "City Hall"
5. Save changes
6. Verify draft now has 2 items, total updated

**Expected:** New item added, total recalculated

### Test 7: Remove Line Item  
**Steps:**
1. Edit a draft with 3 items
2. Click "🗑️ Remove" on the middle item
3. Verify item disappears immediately
4. Save changes
5. Verify draft now has 2 items, total updated

**Expected:** Item removed, form updates immediately

### Test 8: Receipt Management - Replace
**Steps:**
1. Edit a draft with a receipt attached
2. Click "Replace" on the receipt
3. Upload a new file
4. Verify new filename shown
5. Save changes
6. Verify new receipt saved

**Expected:** Receipt replaced with new file

### Test 9: Receipt Management - Remove
**Steps:**
1. Edit a draft with a receipt attached
2. Click "Remove" on the receipt  
3. Verify receipt removed immediately
4. Save changes
5. Verify receipt no longer attached

**Expected:** Receipt removed from item

### Test 10: Receipt Management - Add to Item Without Receipt
**Steps:**
1. Edit a draft with item that has no receipt
2. Click "📷 Add receipt" 
3. Upload a file
4. Verify receipt appears with filename
5. Save changes

**Expected:** Receipt added to item

### Test 11: Cancel Without Saving
**Steps:**
1. Edit a draft
2. Change multiple fields (amount, vendor, add item)
3. Click "✕ Cancel" (do NOT save)
4. Verify draft shows original values
5. Check localStorage to confirm no changes saved

**Expected:** All changes discarded, original data preserved

### Test 12: Validation - Empty Purpose
**Steps:**
1. Edit a draft
2. Clear the purpose field
3. Click "💾 Save Changes"
4. Verify error message: "Purpose and date are required"

**Expected:** Validation prevents saving without purpose

### Test 13: Validation - Zero Amount Items
**Steps:**
1. Edit a draft
2. Set an item amount to 0
3. Save changes
4. Verify item with $0 amount is removed automatically

**Expected:** Zero-amount items filtered out

### Test 14: Validation - Zero Km Kilometric  
**Steps:**
1. Edit a draft with Kilometric item
2. Set km to 0
3. Save changes  
4. Verify kilometric item removed

**Expected:** Zero-km kilometric items filtered out

### Test 15: Submission Buttons Disabled During Edit
**Steps:**
1. Edit a draft
2. Verify "📤 Submit All for Approval" button is disabled/grayed out
3. Verify "🗑️ Clear All" button is disabled/grayed out  
4. Save or cancel edit
5. Verify buttons re-enabled

**Expected:** Submission buttons disabled during editing

### Test 16: Mobile Responsiveness
**Steps:**
1. Open on mobile device or resize browser to mobile width
2. Edit a draft
3. Verify all form fields accessible and usable
4. Verify buttons are tappable
5. Test adding/removing items
6. Test save/cancel

**Expected:** Edit form works on mobile

### Test 17: Complex Edit Scenario
**Steps:**
1. Create draft with 3 items: Purchase ($100), Kilometric (50km), Parking ($20)
2. Edit the draft:
   - Change purpose from "Office supplies" to "Client meeting expenses"  
   - Change Purchase amount to $150
   - Change Kilometric from 50km to 75km
   - Remove Parking item
   - Add new Phone/Telecom item: $25
3. Save changes
4. Verify all changes applied correctly
5. Verify total = $150 + $45.75 + $25 = $220.75

**Expected:** Complex multi-field edit works correctly

### Test 18: Receipt Requirements During Edit
**Steps:**
1. Edit a draft with Purchase item that has no receipt
2. Try to save without adding receipt  
3. Verify system still allows saving (receipt validation happens at submission, not draft editing)

**Expected:** Drafts can be saved without receipts (validation at submission time)

### Test 19: Edit Form Styling  
**Steps:**
1. Edit a draft
2. Verify edit form has distinct styling (white background, blue border)
3. Verify form is clearly distinguishable from read-only view
4. Check that buttons are properly styled and accessible

**Expected:** Edit form visually distinct and professional looking

### Test 20: No Regression - Creating New Drafts
**Steps:**
1. Create a brand new draft (not editing existing)
2. Add multiple items with receipts
3. Save as draft
4. Verify appears in draft list
5. Verify can still submit normally

**Expected:** New draft creation unchanged by edit feature

## Success Criteria
- ✅ All 20 tests pass
- ✅ No existing functionality broken  
- ✅ Mobile responsive
- ✅ Professional UI/UX
- ✅ Proper validation and error handling

## Risk Areas to Monitor
- localStorage corruption if editing fails mid-way
- Receipt file handling during edits
- Kilometric calculation accuracy  
- Form state management when adding/removing items
- Button state management during edit mode

## Deployment Notes
This is a frontend-only change (no backend API changes required). The existing draft system uses localStorage until submission.