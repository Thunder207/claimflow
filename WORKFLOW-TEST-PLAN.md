# ClaimFlow — End-to-End Workflow Test Plan
**Date:** March 4, 2026  
**Purpose:** Test every complete user journey from start to finish — real-world scenarios, not isolated features

---

## Test Accounts
| Role | Name | Email | Password |
|------|------|-------|----------|
| Employee 1 | Anna Lee | anna.lee@company.com | anna123 |
| Employee 2 | Mike Davis | mike.davis@company.com | mike123 |
| Supervisor | Lisa Brown | lisa.brown@company.com | lisa123 |
| Admin | John Smith | john.smith@company.com | manager123 |

---

## Workflow 1: Office Supply Run (Expense Claim — Happy Path)
**Scenario:** Anna buys office supplies at Costco, parks at the mall, and drives 15km round trip.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W1.1 | Anna | Login | Dashboard loads, "Anna Lee's Dashboard" | |
| W1.2 | Anna | Go to Expenses tab | Claim form visible, date pre-filled | |
| W1.3 | Anna | Enter purpose: "Costco Office Supply Run" | Purpose field filled | |
| W1.4 | Anna | Line item 1: Purchase/Supply, $87.50, Vendor: Costco, Details: "Printer paper and toner" | Amount, vendor, details filled | |
| W1.5 | Anna | Upload JPG receipt for item 1 | Filename shown with ✅ | |
| W1.6 | Anna | Click "+ Add Item" | Second line item appears | |
| W1.7 | Anna | Line item 2: Parking, $8.00, Vendor: Bayshore Mall | Amount, vendor filled | |
| W1.8 | Anna | Upload PNG receipt for parking | Filename shown | |
| W1.9 | Anna | Click "+ Add Item" | Third line item appears | |
| W1.10 | Anna | Line item 3: Kilometric, 15km | Amount auto-calculates to $9.15, vendor/details/receipt hidden | |
| W1.11 | Anna | Verify Claim Total | Shows $104.65 | |
| W1.12 | Anna | Click "Add to Draft" | Success message, form resets, draft section shows claim | |
| W1.13 | Anna | Verify draft card | Shows "Costco Office Supply Run — $104.65 (3 items)" | |
| W1.14 | Anna | Click "Submit All for Approval" | Submitting... then success message | |
| W1.15 | Anna | Go to Expense History tab | Claim group visible: "costco office supply run" — $104.65 — PENDING | |
| W1.16 | Lisa | Login as supervisor | Dashboard loads | |
| W1.17 | Lisa | Switch to Supervisor View | Team Approvals visible | |
| W1.18 | Lisa | Find Anna's claim in pending | "Costco Office Supply Run" with 3 items, correct amounts | |
| W1.19 | Lisa | Verify line items | Purchase $87.50 (View Receipt), Parking $8.00 (View Receipt), Kilometric $9.15 (N/A) | |
| W1.20 | Lisa | Click "View Receipt" on Purchase item | Receipt image opens in modal | |
| W1.21 | Lisa | Close modal | Modal closes cleanly | |
| W1.22 | Lisa | Click Approve | "Confirm Approve" button appears | |
| W1.23 | Lisa | Click "Confirm Approve" | Claim approved, moves to history | |
| W1.24 | Anna | Login, go to Expense History | Claim now shows ✅ APPROVED with PDF button | |
| W1.25 | Anna | Click PDF button | PDF downloads/opens with claim details + receipts | |

## Workflow 2: Business Trip — Full Lifecycle
**Scenario:** Anna travels to Ottawa for a 3-day conference. Full trip from authorization to expense report.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W2.1 | Anna | Go to Travel Auth tab | TA form visible | |
| W2.2 | Anna | Fill: Destination "Ottawa ON", Dates Mar 15-17, Purpose "Annual Tech Conference" | Fields filled | |
| W2.3 | Anna | Select Flight transport | Flight option selected | |
| W2.4 | Anna | Submit TA | TA created, "Pending Approval" status | |
| W2.5 | Anna | Open Day Planner on TA | Grid shows Mar 15, 16, 17 with per diem toggles | |
| W2.6 | Anna | Toggle all meals for 3 days + incidentals | Breakfast/lunch/dinner/incidentals toggled on | |
| W2.7 | Anna | Enter flight estimate: $450 | Transport total updates | |
| W2.8 | Anna | Enter hotel: 2 nights, $180/night | Hotel total shows $360 | |
| W2.9 | Anna | Save day planner | Success message, TA total updated | |
| W2.10 | Anna | Submit TA for approval | Status → Pending | |
| W2.11 | Lisa | Login, Supervisor View | Anna's TA visible in pending | |
| W2.12 | Lisa | Review TA details | Destination, dates, estimated costs visible | |
| W2.13 | Lisa | Approve TA | TA approved, trip auto-created | |
| W2.14 | Anna | Go to Trips tab | Trip "Annual Tech Conference" visible | |
| W2.15 | Anna | Open trip Day Planner | Grid shows with estimate values pre-filled | |
| W2.16 | Anna | Enter actual meal costs (different from estimates) | Actuals saved | |
| W2.17 | Anna | Enter actual flight cost: $425, upload flight receipt | Receipt stored | |
| W2.18 | Anna | Enter actual hotel: $175/night, upload hotel receipt (2 pages) | Both pages stored | |
| W2.19 | Anna | Save trip actuals | Success | |
| W2.20 | Anna | Submit trip for approval | Trip status → Pending | |
| W2.21 | Anna | Check variance view | Shows estimate vs actual comparison | |
| W2.22 | Lisa | View pending trip | Trip details with actuals, receipts viewable | |
| W2.23 | Lisa | Approve trip | Trip approved | |
| W2.24 | Anna | Download trip PDF | Full PDF: summary + meals + transport + hotel + receipts as pages | |

## Workflow 3: Monthly Benefits — Transit + Phone
**Scenario:** Anna submits her monthly transit pass and phone bill.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W3.1 | Anna | Expenses tab → select "Public Transit Benefit" | Transit form loads | |
| W3.2 | Anna | Select current month, enter $125 | Amount shown | |
| W3.3 | Anna | Upload transit pass receipt (JPG) | Receipt attached | |
| W3.4 | Anna | Submit transit claim | Success, appears in history as PENDING | |
| W3.5 | Anna | Back to Expenses → select "Phone Benefit" | Phone form loads | |
| W3.6 | Anna | Enter Plan: $65, Device: $40 | Amounts shown, total $105 | |
| W3.7 | Anna | Verify cap applied | Shows capped to $100 (proportional: Plan ~$61.90, Device ~$38.10) | |
| W3.8 | Anna | Upload phone bill receipt | Receipt attached | |
| W3.9 | Anna | Submit phone claim | Success, appears in history | |
| W3.10 | Lisa | Supervisor View → Phone Claims | Anna's phone claim visible | |
| W3.11 | Lisa | Click "View Receipt" on phone claim | Receipt viewable | |
| W3.12 | Lisa | Approve phone claim | Approved | |
| W3.13 | Lisa | Transit Claims section | Anna's transit claim visible | |
| W3.14 | Lisa | Approve transit claim | Approved | |
| W3.15 | Anna | Check Expense History | Both transit and phone show APPROVED with PDF buttons | |
| W3.16 | Anna | Download transit PDF | PDF with transit details + receipt | |
| W3.17 | Anna | Download phone PDF | PDF with phone details + receipt | |

## Workflow 4: Wellness Claim — HWA
**Scenario:** Anna claims a gym membership under Health & Wellness Account.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W4.1 | Anna | Expenses → select "Health & Wellness" | HWA form loads with balance ($500) | |
| W4.2 | Anna | Enter: Amount $45, Vendor "GoodLife Fitness", Description "Monthly gym membership" | Fields filled | |
| W4.3 | Anna | Upload gym receipt | Receipt attached | |
| W4.4 | Anna | Submit HWA claim | Success, balance decreases to $455 remaining | |
| W4.5 | Anna | Check HWA balance | Shows $455 available ($45 pending) | |
| W4.6 | Lisa | Supervisor View → HWA Claims | Anna's HWA claim visible with receipt | |
| W4.7 | Lisa | Click "View Receipt" | Receipt viewable | |
| W4.8 | Lisa | Approve HWA claim | Approved | |
| W4.9 | Anna | Check balance | $455 remaining (approved counts against max) | |
| W4.10 | Anna | Download HWA PDF | PDF with claim details + receipt | |

## Workflow 5: Rejection & Resubmission
**Scenario:** Anna submits an expense that Lisa rejects. Anna fixes and resubmits.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W5.1 | Anna | Submit expense claim: "Office Lunch" — Purchase $250 with receipt | Submitted, PENDING | |
| W5.2 | Lisa | View pending claim | Anna's "Office Lunch" $250 visible | |
| W5.3 | Lisa | Click Reject | Rejection reason input appears | |
| W5.4 | Lisa | Enter reason: "Amount exceeds per diem. Please split by attendees." | Reason entered | |
| W5.5 | Lisa | Confirm reject | Claim rejected | |
| W5.6 | Anna | Check Expense History | Claim shows ❌ REJECTED with reason visible | |
| W5.7 | Anna | Verify rejection reason displayed | "Amount exceeds per diem. Please split by attendees." | |
| W5.8 | Anna | Submit new corrected claim: "Office Lunch (corrected)" — $45 with receipt | New claim submitted | |
| W5.9 | Lisa | Approve corrected claim | Approved | |
| W5.10 | Anna | History shows both | Rejected $250 + Approved $45 both visible | |

## Workflow 6: Two Employees, One Supervisor
**Scenario:** Anna and Mike both submit expenses. Lisa manages both.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W6.1 | Anna | Submit: "Client Dinner" — $85 + receipt | PENDING | |
| W6.2 | Mike | Submit: "Software License" — $199 + receipt | PENDING | |
| W6.3 | Lisa | Supervisor View | Both Anna's and Mike's claims visible | |
| W6.4 | Lisa | Approve Anna's claim | Anna's approved, Mike's still pending | |
| W6.5 | Lisa | Reject Mike's claim: "Need manager pre-approval for software >$100" | Mike's rejected | |
| W6.6 | Anna | Check history | Her claim APPROVED | |
| W6.7 | Mike | Check history | His claim REJECTED with reason | |
| W6.8 | Lisa | Check supervisor history | Both actions logged | |

## Workflow 7: Admin Settings Change Mid-Cycle
**Scenario:** John changes benefit limits while claims are in progress.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W7.1 | Anna | Submit transit claim: $140 (under $150 max) | Accepted | |
| W7.2 | John | Login as admin, go to Settings | Settings visible | |
| W7.3 | John | Change transit monthly max from $150 to $125 | Saved with audit trail | |
| W7.4 | Lisa | Approve Anna's $140 transit claim | Approved (was submitted under old limit) | |
| W7.5 | Anna | Submit new transit claim: $130 | Rejected or capped at new $125 limit | |
| W7.6 | John | Check audit trail | Shows setting change with timestamp and old/new values | |

## Workflow 8: Dashboard Stats Accuracy
**Scenario:** Verify all dashboard numbers match after a full session of activity.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W8.1 | Anna | Note dashboard stats: Total Expenses, Total Submitted, Approved, Pending | Record numbers | |
| W8.2 | Anna | Submit 3 new claims totaling $200 | Stats update | |
| W8.3 | Anna | Verify Total Expenses increased by 3 | Correct | |
| W8.4 | Anna | Verify Pending increased by 3 | Correct | |
| W8.5 | Lisa | Approve 2, reject 1 | Processed | |
| W8.6 | Anna | Refresh dashboard | Approved +2, Pending -3, Rejected visible | |
| W8.7 | Anna | Verify Total Submitted amount | Matches sum of all submitted amounts | |
| W8.8 | Anna | Verify Approved amount | Matches sum of approved only | |

## Workflow 9: Multi-Draft Batch Submission
**Scenario:** Anna builds up multiple draft claims and submits them all at once.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W9.1 | Anna | Create draft 1: "Parking — Mar 1" — Parking $12 + receipt | Added to draft | |
| W9.2 | Anna | Create draft 2: "Office Supplies" — Purchase $45 + Km 10km | Added to draft | |
| W9.3 | Anna | Create draft 3: "Client Gift" — Purchase $30 + receipt | Added to draft | |
| W9.4 | Anna | Verify draft section | 3 drafts, correct totals | |
| W9.5 | Anna | Remove draft 2 (click ✕) | Draft removed, 2 remaining | |
| W9.6 | Anna | Submit All for Approval | Both remaining drafts submitted | |
| W9.7 | Anna | Drafts cleared | Draft section hidden | |
| W9.8 | Anna | Expense History | Both claims visible as PENDING | |
| W9.9 | Lisa | Two separate claim groups in pending | Both visible, independent approve/reject | |
| W9.10 | Lisa | Approve one, reject other | Each processed independently | |

## Workflow 10: Complete New Employee Onboarding
**Scenario:** Verify a new employee (Mike) can discover and use every feature.

| Step | Actor | Action | Expected | Pass/Fail |
|------|-------|--------|----------|-----------|
| W10.1 | Mike | Login | Dashboard loads with $0 stats | |
| W10.2 | Mike | Explore Expenses tab | Claim form visible with category selector | |
| W10.3 | Mike | Explore Travel Auth tab | TA creation form visible | |
| W10.4 | Mike | Explore Trips tab | "No active trips" or empty state | |
| W10.5 | Mike | Explore Expense History tab | Empty or "No expenses" | |
| W10.6 | Mike | Switch language to FR | Labels change to French | |
| W10.7 | Mike | Switch back to EN | Labels revert, dashboard name intact | |
| W10.8 | Mike | Submit first expense claim | Succeeds without confusion | |
| W10.9 | Mike | Check notifications | Submission confirmation visible | |
| W10.10 | Mike | View claim in history | Correctly displayed | |

---

## Total: 132 workflow steps across 10 real-world scenarios

## Execution Order
1. **W1** (Office Supply Run) — core happy path, must pass first
2. **W5** (Rejection) — tests reject + resubmit cycle
3. **W9** (Multi-Draft) — tests batch workflow
4. **W3** (Transit + Phone) — monthly benefits
5. **W4** (HWA) — wellness claim
6. **W2** (Business Trip) — most complex, depends on TA approval
7. **W6** (Two Employees) — concurrent users
8. **W7** (Admin Settings) — settings mid-cycle
9. **W8** (Dashboard Stats) — verification after all activity
10. **W10** (New Employee) — fresh user experience

## Success Criteria
- **100% of happy path steps pass** (W1, W3, W4)
- **Rejection flow works cleanly** (W5)
- **Stats always accurate** (W8)
- **No orphaned data** — every submission appears in history
- **Every PDF downloadable** — no auth errors, no blank pages
- **Every receipt viewable** — images in modal, PDFs in new tab
- **No scroll-to-top** during any workflow
- **No broken states** — app recoverable after any step
