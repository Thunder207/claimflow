# ClaimFlow — Full Test Plan v8.2
**Date:** March 3, 2026  
**URL:** https://claimflow-e0za.onrender.com  
**Version:** v8.2-receipts-auth-2026-03-03

---

## Test Accounts
| Role | Name | Email | Password |
|------|------|-------|----------|
| Admin | John Smith | john.smith@company.com | manager123 |
| Supervisor | Lisa Brown | lisa.brown@company.com | lisa123 |
| Employee | Anna Lee | anna.lee@company.com | anna123 |
| Employee | Mike Davis | mike.davis@company.com | mike123 |

---

## Phase 1: Authentication & Access Control (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 1.1 | Valid login (employee) | Login as Anna Lee | Dashboard loads, name displayed | |
| 1.2 | Valid login (supervisor) | Login as Lisa Brown | Dashboard loads, supervisor switch visible | |
| 1.3 | Valid login (admin) | Login as John Smith | Dashboard loads, admin features visible | |
| 1.4 | Invalid password | Login with wrong password | Error message shown | |
| 1.5 | Invalid email | Login with nonexistent email | Error message shown | |
| 1.6 | Empty fields | Submit blank login | Validation error | |
| 1.7 | Session persistence | Refresh page after login | Stays logged in | |
| 1.8 | Logout | Click logout button | Returns to login page | |

## Phase 2: Expense Claims — Form & Draft (15 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 2.1 | Form loads | Go to Expenses tab | Claim form visible with purpose, date, line items | |
| 2.2 | Date auto-filled | Load form | Today's date pre-filled | |
| 2.3 | Add line item | Click "+ Add Item" | New line item row appears | |
| 2.4 | Remove line item | Click ✕ on line item | Item removed, total updates | |
| 2.5 | Category change — Purchase | Select Purchase/Supply | Amount, Vendor, Details, Receipt visible | |
| 2.6 | Category change — Kilometric | Select Kilometric | Distance + calculated amount shown; Vendor, Details, Receipt HIDDEN | |
| 2.7 | Kilometric calculation | Enter 30km | Amount shows $18.30 ($0.61 × 30) | |
| 2.8 | Kilometric >5000km | Enter 6000km | Amount = $3,050 + $550 = $3,600 | |
| 2.9 | Claim total updates | Add 2 items: $50 + $25 | Total shows $75.00 | |
| 2.10 | Missing purpose — Add to Draft | Leave purpose blank, click Add to Draft | Scrolls to purpose, red border, error shown | |
| 2.11 | Missing receipt — Add to Draft | Add Purchase item without receipt | Error: receipt required | |
| 2.12 | Kilometric no receipt — Add to Draft | Add Kilometric item (no receipt) | Succeeds (no receipt needed) | |
| 2.13 | Successful Add to Draft | Fill purpose, date, item with receipt | Added to draft, success message, form resets | |
| 2.14 | Draft persists | Add to draft, refresh page | Draft still visible (localStorage) | |
| 2.15 | Clear All drafts | Click Clear All | Drafts removed, section hidden | |

## Phase 3: Expense Claims — Submission (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 3.1 | Submit single claim | Add 1 claim to draft, Submit All | Success message, drafts cleared | |
| 3.2 | Submit multi-item claim | Add claim with 3 items (Purchase + Km + Parking), Submit All | All items submitted as group | |
| 3.3 | Submit multiple drafts | Add 2 separate claims to draft, Submit All | Both submitted | |
| 3.4 | Double-tap prevention | Rapidly click Submit All twice | Only submits once | |
| 3.5 | Receipt uploaded | Submit Purchase with receipt | Receipt stored on server | |
| 3.6 | Details field saved | Submit with details text | Details visible in history/supervisor | |
| 3.7 | Appears in history | After submit, go to Expense History | Claim group visible with items | |
| 3.8 | Status shows Pending | Check submitted claim | Status = "PENDING" | |

## Phase 4: Travel Authorization (10 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 4.1 | Create TA form | Go to Travel Auth tab | Form visible (destination, dates, transport) | |
| 4.2 | Fill and submit TA | Complete all fields, submit | TA created, confirmation shown | |
| 4.3 | Overlap prevention | Create TA overlapping existing dates | Error: overlapping dates | |
| 4.4 | TA appears in list | After submit | TA visible in Travel Auth list | |
| 4.5 | Day Planner loads | Click on TA | Day planner grid visible | |
| 4.6 | Toggle per diem | Click breakfast tile for a day | Tile toggles on/off | |
| 4.7 | Transport section | Add flight cost | Amount saved, total updates | |
| 4.8 | Hotel section | Add hotel with dates | Hotel entry saved | |
| 4.9 | Save day planner | Make changes, save | Success message | |
| 4.10 | TA total calculated | Add meals + transport + hotel | Total estimate reflects all items | |

## Phase 5: Trips (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 5.1 | Trip auto-created | After TA approved, check Trips tab | Trip exists from approved TA | |
| 5.2 | Trip day planner | Open trip | Day planner with actual expenses | |
| 5.3 | Add actual expenses | Toggle meals, enter amounts | Saved correctly | |
| 5.4 | Transport receipts | Upload transport receipt | Stored as BLOB | |
| 5.5 | Hotel receipts | Upload hotel receipt (multi-page) | All pages stored | |
| 5.6 | Submit trip | Click submit | Trip status → pending | |
| 5.7 | Variance view | After submit, check variance | Budget comparison visible | |
| 5.8 | Trip PDF | After approval, download PDF | PDF opens with all receipts | |

## Phase 6: Supervisor Approval Workflow (12 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 6.1 | Switch to supervisor | Click "Supervisor View" (Lisa Brown) | Supervisor dashboard loads | |
| 6.2 | Pending expenses visible | Check Team Approvals | Pending claims from Anna visible | |
| 6.3 | Claim group display | View grouped claim | Shows purpose, items, amounts | |
| 6.4 | View receipt — image | Click "View Receipt" on item | Receipt opens in modal overlay | |
| 6.5 | View receipt — close | Click outside modal / close button | Modal closes | |
| 6.6 | Approve claim — first click | Click Approve | Confirm button appears | |
| 6.7 | Approve claim — confirm | Click Confirm Approve | Claim approved, moves to history | |
| 6.8 | Reject claim — first click | Click Reject | Reason input + confirm appears | |
| 6.9 | Reject claim — confirm | Enter reason, click Confirm Reject | Claim rejected | |
| 6.10 | Approve TA | View pending TA, approve | TA approved, trip auto-created | |
| 6.11 | Approve trip | View pending trip, approve | Trip approved, PDF generated | |
| 6.12 | Supervisor history | Check approval history | All approved/rejected items visible | |

## Phase 7: PDF Generation & Downloads (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 7.1 | Claim group PDF | After approval, click PDF button | PDF downloads/opens | |
| 7.2 | PDF content | Open claim PDF | Shows purpose, items, amounts, approval info | |
| 7.3 | PDF receipts embedded | Check PDF pages | Receipt images as pages in PDF | |
| 7.4 | Trip PDF download | Download approved trip PDF | Opens with auth | |
| 7.5 | Trip PDF content | Review trip PDF | Meals, transport, hotel, receipts | |
| 7.6 | Transit PDF | Approve transit claim, download PDF | PDF with transit details | |
| 7.7 | Phone PDF | Approve phone claim, download PDF | PDF with phone details | |
| 7.8 | PDF no emoji glitches | Check all PDFs | Plain text labels, no garbled characters | |

## Phase 8: Public Transit Benefit (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 8.1 | Transit form loads | Select "Public Transit Benefit" category | Transit form appears | |
| 8.2 | Month selection | Select a month | Month card visible | |
| 8.3 | Amount entry | Enter $125 | Amount shown | |
| 8.4 | Receipt upload | Upload transit receipt | File attached, name shown | |
| 8.5 | Submit transit | Submit claim | Success, appears in history | |
| 8.6 | Monthly cap | Enter amount > monthly max | Warning or cap applied | |
| 8.7 | Supervisor approval | Approve transit claim as supervisor | Claim approved | |
| 8.8 | Transit PDF | Download PDF after approval | PDF generated with receipt | |

## Phase 9: Phone Benefit (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 9.1 | Phone form loads | Select "Phone Benefit" category | Phone form appears | |
| 9.2 | Plan + device entry | Enter plan $60, device $50 | Amounts shown | |
| 9.3 | Combined cap | Total > $100 monthly max | Proportional cap applied, warning shown | |
| 9.4 | Receipt upload | Upload phone receipt | File attached | |
| 9.5 | Submit phone | Submit claim | Success, appears in history | |
| 9.6 | Duplicate month prevention | Submit same month again | Error or blocked | |
| 9.7 | Supervisor approval | Approve phone claim | Claim approved | |
| 9.8 | Phone PDF | Download PDF after approval | PDF generated | |

## Phase 10: Health & Wellness Account (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 10.1 | HWA form loads | Select "Health & Wellness" category | HWA form appears with balance | |
| 10.2 | Balance display | Check available balance | Shows $500 (or remaining) | |
| 10.3 | Submit HWA claim | Enter amount, vendor, upload receipt | Success, balance decreases | |
| 10.4 | Exceeds balance | Try to submit more than remaining | Error: exceeds annual max | |
| 10.5 | Receipt upload | Upload HWA receipt | File attached | |
| 10.6 | Supervisor approval | Approve HWA claim | Claim approved | |
| 10.7 | Balance updates | Check balance after approval | Reflects approved amount | |
| 10.8 | Rejection restores balance | Reject HWA claim | Balance restored | |

## Phase 11: Admin Settings (6 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 11.1 | Access admin settings | Login as John Smith, go to settings | Settings panels visible | |
| 11.2 | Transit settings | Change monthly max | Saved with audit trail | |
| 11.3 | Phone settings | Change monthly max | Saved with audit trail | |
| 11.4 | HWA settings | Change annual max | Saved with audit trail | |
| 11.5 | Variance settings | Change thresholds | Saved with audit trail | |
| 11.6 | Non-admin blocked | Login as Anna, try settings API | Access denied | |

## Phase 12: Expense History & Filters (6 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 12.1 | All expenses visible | Go to Expense History, click "All" | All claims shown | |
| 12.2 | Filter — Pending | Click "Pending" | Only pending items | |
| 12.3 | Filter — Approved | Click "Approved" | Only approved items | |
| 12.4 | Filter — Rejected | Click "Rejected" | Only rejected items | |
| 12.5 | Claim group display | Check grouped claim | Shows as grouped card with items | |
| 12.6 | Individual benefits | Check transit/phone/HWA | Each shows in appropriate section | |

## Phase 13: Mobile UX (6 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 13.1 | Responsive layout | Open on mobile | All elements fit, no horizontal scroll | |
| 13.2 | Touch targets | Tap buttons | All buttons responsive, min 44px height | |
| 13.3 | Camera capture | Tap receipt file input | Camera/gallery option appears | |
| 13.4 | Scroll behavior | Add to draft with receipt | No scroll-to-top after file select | |
| 13.5 | Two-click approve | Approve on mobile | Confirm step works, no browser dialogs | |
| 13.6 | Navigation tabs | Switch between tabs | Smooth, correct content loads | |

## Phase 14: Edge Cases & Error Handling (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 14.1 | Zero amount | Submit item with $0 | Rejected/filtered out | |
| 14.2 | Negative amount | Enter -50 | Rejected | |
| 14.3 | Very large amount | Enter $999,999 | Accepted or capped | |
| 14.4 | Special characters | Enter "O'Brien's café" as vendor | Saved without XSS | |
| 14.5 | Empty line items | Add to Draft with no items filled | Error message | |
| 14.6 | Large file upload | Upload 10MB image | Compressed client-side | |
| 14.7 | Non-image file | Upload .txt as receipt | Accepted or graceful error | |
| 14.8 | Concurrent approvals | Two supervisors approve same item | Only one succeeds | |

## Phase 15: i18n / Language Toggle (4 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| 15.1 | Default language | Load page | English labels | |
| 15.2 | Switch to French | Click FR button | Labels change to French | |
| 15.3 | Switch back to English | Click EN button | Labels revert to English | |
| 15.4 | No broken elements | After language switch | All IDs still functional (no destroyed spans) | |

---

## Total: 115 tests across 15 phases

## Execution Notes
- Run phases 1-3 first (core expense flow)
- Phase 6 depends on phases 2-3 (need pending claims)
- Phase 5 depends on phase 4 (need approved TA)
- Phase 7 depends on phase 6 (need approved claims)
- Phases 8-10 can run independently
- Phase 14 can run anytime
- Fresh DB on each deploy — run all tests in one session
