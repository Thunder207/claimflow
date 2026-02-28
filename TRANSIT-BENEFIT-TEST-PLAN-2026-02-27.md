# 🚍 Public Transit Benefit System - Test Plan
**Date:** February 27, 2026  
**Status:** Complete Implementation - Ready for Testing  
**URL:** https://claimflow-e0za.onrender.com

## 📋 Test Objectives
Verify the complete Public Transit Benefit system meets all requirements:
- ✅ Dropdown integration (first option)
- ✅ Dynamic form transformation
- ✅ Month-based claim system
- ✅ Amount capping and validation
- ✅ Receipt requirements
- ✅ Draft system integration
- ✅ Admin configuration
- ✅ Submission workflow

---

## 🔧 Test Setup
**Test Accounts:**
- **Employee:** pdftest@company.com / testpass123
- **Admin:** john.smith@company.com / manager123

**Expected Settings (Default):**
- Monthly Maximum: $100.00
- Claim Window: 2 months back + current month

---

## 📝 Test Cases

### Test 1: ✅ Dropdown - Transit Benefit is First
**Steps:**
1. Login as employee: pdftest@company.com
2. Navigate to Expenses tab
3. Click the "Expense Category" dropdown

**Expected Result:**
- "🚍 Public Transit Benefit" is the FIRST option
- All other categories (Transport, Phone, etc.) appear below it
- No visual glitches or missing options

---

### Test 2: ✅ Form Transforms on Selection
**Steps:**
1. Select "Public Transit Benefit" from dropdown
2. Verify month selector appears, regular fields hidden
3. Switch to "Transport" category  
4. Verify regular fields reappear, month selector disappears
5. Switch back to "Public Transit Benefit"

**Expected Result:**
- Form dynamically shows/hides appropriate fields
- No errors or visual glitches during switching
- Month selector shows eligible months (current + 2 back)

---

### Test 3: ✅ Eligible Months Shown
**Steps:**
1. Select "Public Transit Benefit"
2. Check which months are displayed

**Expected Result (March 2026):**
- ☐ March 2026 (current month)
- ☐ February 2026 (1 month back)  
- ☐ January 2026 (2 months back)
- December 2025 and earlier NOT shown
- Months in reverse chronological order

---

### Test 4: ✅ Single Month Claim
**Steps:**
1. Check "March 2026" 
2. Enter amount: $85.00
3. Upload receipt image
4. Click "Add to Draft"
5. Verify appears in draft list
6. Click "Submit for Approval"

**Expected Result:**
- Draft shows: "🚍 Public Transit Benefit - $85.00"
- Draft description: "1 month(s): March 2026: $85.00"
- Submission succeeds
- March 2026 should become locked/pending status

---

### Test 5: ✅ Amount Capping
**Steps:**
1. Check "February 2026"
2. Enter amount: $150.00 (over $100 max)
3. Verify auto-capping occurs
4. Upload receipt and submit

**Expected Result:**
- Amount auto-caps to $100.00
- Message: "Capped at $100.00 (monthly maximum)"
- Claim amount: $100.00
- Receipt amount: $150.00 (stored separately)

---

### Test 6: ✅ Multi-Month Claim  
**Steps:**
1. Check January ($90) and February ($75)
2. Upload receipts for both
3. Verify total calculation
4. Submit

**Expected Result:**
- Total shows: $165.00 
- Draft description: "2 month(s): January 2026: $90.00, February 2026: $75.00"
- Both months become locked after submission

---

### Test 7: ✅ Receipt Required
**Steps:**
1. Check a month, enter amount
2. Do NOT upload receipt
3. Try to "Add to Draft"

**Expected Result:**
- Blocked with error: "Please enter amount and upload receipt for [Month] [Year]"
- Cannot proceed without receipt

---

### Test 8: ✅ Admin Settings Interface
**Steps:**
1. Login as admin: john.smith@company.com
2. Navigate to Admin → Settings tab
3. Scroll to "🚍 Public Transit Benefit Settings"

**Expected Result:**
- Monthly Maximum field (default: 100.00)
- Claim Window field (default: 2)
- Current settings display
- Save button functional

---

### Test 9: ✅ Admin Changes Take Effect
**Steps:**
1. As admin, change Monthly Max to $75.00
2. Change Claim Window to 3 months
3. Save settings
4. As employee, check transit form

**Expected Result:**
- Form shows "Maximum: $75.00/month"
- Shows 4 months (current + 3 back)
- Enter $90 → auto-caps to $75
- Audit trail shows changes

---

### Test 10: ✅ Mixed Submission (Transit + Regular)
**Steps:**
1. Add transit claim to draft ($85 for March)
2. Switch to "Transport" category
3. Add regular expense to draft ($15 parking)
4. Submit all

**Expected Result:**
- Draft shows both items with different styling
- Transit: blue border with 🚍 icon
- Regular: standard blue border
- Both submit together successfully

---

### Test 11: ✅ Supervisor Review
**Steps:**
1. Submit transit claims as employee
2. Login as supervisor (if available) 
3. Review approval queue

**Expected Result:**
- Transit claims clearly labeled
- Shows months being claimed
- Shows receipt vs claim amounts
- Receipt files downloadable

---

### Test 12: ✅ Month Lockout After Approval
**Steps:**
1. Submit and approve March 2026 claim
2. Return to employee transit form
3. Check March 2026 status

**Expected Result:**
- March shows: "✅ March 2026 — $85.00 — Approved (date)"
- March is greyed out, not selectable
- February and January still available

---

### Test 13: ✅ Error Handling
**Steps:**
1. Try to submit without amount
2. Try to submit without receipt
3. Try invalid amounts (negative, zero)
4. Check form validation

**Expected Result:**
- Clear error messages for each scenario
- Form prevents invalid submissions
- User-friendly feedback

---

## 🔍 Key Validation Points

**Database Integration:**
- [ ] `transit_claims` table populated correctly
- [ ] `app_settings` has transit configuration
- [ ] Unique constraints prevent duplicate claims

**API Endpoints:**
- [ ] `GET /api/settings/transit` returns current config
- [ ] `PUT /api/settings/transit` saves admin changes
- [ ] `GET /api/transit-claims/eligible` shows available months
- [ ] `POST /api/transit-claims` handles submissions

**UI/UX:**
- [ ] Form transformation is smooth and intuitive
- [ ] Draft system integration works seamlessly  
- [ ] Admin interface is clear and functional
- [ ] Mobile responsive on phones/tablets

**Business Logic:**
- [ ] Amount capping works correctly
- [ ] Month eligibility calculated properly
- [ ] Receipt requirements enforced
- [ ] Audit trails created for setting changes

---

## 📊 Success Criteria
✅ **PASS:** All 13 test cases work as expected  
⚠️ **PARTIAL:** Most features work, minor issues  
❌ **FAIL:** Major functionality broken

**Next Steps:**
1. Complete manual testing of all cases
2. Document any issues found
3. Fix critical bugs if discovered
4. Mark Process #2 complete when all tests pass

---

## 🐛 Issues Found (To Be Updated)
*Document any bugs or issues discovered during testing*

**Issue #1:** [None found yet]
**Issue #2:** [None found yet]
**Issue #3:** [None found yet]

---

**Testing Status:** 🟡 **Ready for Testing**  
**Completion:** Process #2 pending user validation