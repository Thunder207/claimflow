# ClaimFlow — Concurrent Multi-User Test Plan
**Date:** March 3, 2026  
**URL:** https://claimflow-e0za.onrender.com  
**Purpose:** Validate app stability with multiple simultaneous users

---

## Test Users (All Active Simultaneously)

| Session | User | Role | Action |
|---------|------|------|--------|
| A | Anna Lee (anna.lee@company.com / anna123) | Employee | Submitting expenses |
| B | Mike Davis (mike.davis@company.com / mike123) | Employee | Submitting expenses |
| C | Lisa Brown (lisa.brown@company.com / lisa123) | Supervisor | Approving/rejecting |
| D | John Smith (john.smith@company.com / manager123) | Admin | Settings + approving |

---

## Phase 1: Simultaneous Login (4 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| C1.1 | 4 users login at once | All 4 login within 10 seconds | All get valid sessions | |
| C1.2 | Sessions are independent | Check each user sees their own name | No session bleed | |
| C1.3 | Role-correct UI | Anna/Mike see employee view, Lisa sees supervisor switch | Correct per role | |
| C1.4 | Concurrent dashboard load | All 4 load dashboard stats | No errors, correct data per user | |

## Phase 2: Simultaneous Expense Submission (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| C2.1 | Anna submits claim | Anna: Purchase $75 "Office Supplies" | Claim created, CLM-xxx ID | |
| C2.2 | Mike submits claim | Mike: Parking $20 "Client Meeting" (same time as Anna) | Separate CLM-xxx ID | |
| C2.3 | No ID collision | Check both claim group IDs | Different CLM- timestamps | |
| C2.4 | Anna submits 2nd claim | Anna: Kilometric 50km | Second claim created | |
| C2.5 | Mike submits multi-item | Mike: Purchase $100 + Km 30km + Parking $15 | All 3 items in one group | |
| C2.6 | Both in pending queue | Lisa checks pending | Both Anna's and Mike's claims visible | |
| C2.7 | Correct employee attribution | Each claim shows correct employee name | No cross-contamination | |
| C2.8 | Expense totals correct | Anna and Mike see own totals in dashboard stats | Independent calculations | |

## Phase 3: Concurrent Approval & Rejection (10 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| C3.1 | Lisa approves Anna's claim | Lisa approves Anna's first claim | Approved, Anna sees it | |
| C3.2 | John approves Mike's claim | John approves Mike's claim (simultaneously) | Approved, Mike sees it | |
| C3.3 | No cross-approval interference | Both approvals succeed independently | Both recorded correctly | |
| C3.4 | Lisa rejects Anna's 2nd claim | Lisa rejects with reason "Missing details" | Rejected, reason saved | |
| C3.5 | Anna sees approved + rejected | Anna checks history | One approved, one rejected with reason | |
| C3.6 | Mike sees approved | Mike checks history | His claim approved | |
| C3.7 | Double-approve race | Lisa and John both try to approve same claim | Only one succeeds (or both idempotent) | |
| C3.8 | Approve after reject race | Lisa rejects, John tries to approve same | Reject takes priority (already processed) | |
| C3.9 | PDF generated on approve | Check approved claims | PDF available for download | |
| C3.10 | Supervisor history consistent | Lisa and John see same approval history | Matching records | |

## Phase 4: Concurrent Benefit Claims (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| C4.1 | Anna submits transit | Anna: Transit $125 for January | Transit claim created | |
| C4.2 | Mike submits transit | Mike: Transit $100 for January (same time) | Separate transit claim | |
| C4.3 | Anna submits HWA | Anna: HWA $200 "Gym membership" | HWA claim, balance reduced | |
| C4.4 | Mike submits HWA | Mike: HWA $150 "Running shoes" | Separate HWA claim | |
| C4.5 | HWA balances independent | Check Anna's balance vs Mike's | Each has own $500 annual balance | |
| C4.6 | Anna submits phone | Anna: Phone $80 plan + $30 device | Phone claim with cap check | |
| C4.7 | Concurrent benefit approval | Lisa approves Anna's transit + Mike's HWA at same time | Both approved independently | |
| C4.8 | Balance updates after approval | Anna and Mike check balances | Correctly adjusted per user | |

## Phase 5: Concurrent Travel Auth & Trips (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| C5.1 | Anna creates TA | Anna: Ottawa trip Mar 15-17 | TA created | |
| C5.2 | Mike creates TA | Mike: Toronto trip Mar 15-17 (same dates, different dest) | TA created (no conflict — different users) | |
| C5.3 | Lisa approves both TAs | Approve Anna's and Mike's TAs back-to-back | Both approved, trips auto-created | |
| C5.4 | Anna edits trip day planner | Anna: toggle meals, add transport | Saved correctly | |
| C5.5 | Mike edits trip day planner | Mike: toggle meals, add hotel (same time) | Saved correctly, no interference | |
| C5.6 | Both submit trips | Anna and Mike submit trips | Both pending | |
| C5.7 | Concurrent trip approval | Lisa approves both trips | Both approved, PDFs generated | |
| C5.8 | Trip PDFs independent | Download both PDFs | Each contains correct trip data | |

## Phase 6: Admin Settings Under Load (6 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| C6.1 | John changes transit max | Set transit max to $175 | Saved, audit logged | |
| C6.2 | Anna submits transit during change | Anna submits transit while John updates settings | Uses correct max (before or after, not corrupted) | |
| C6.3 | John changes phone max | Set phone max to $120 | Saved, audit logged | |
| C6.4 | John changes HWA max | Set HWA max to $600 | Saved, audit logged | |
| C6.5 | Settings not cached stale | Anna reloads form after setting change | Sees new limits | |
| C6.6 | Concurrent setting updates | John updates transit, Lisa views pending | No interference | |

## Phase 7: Session & Data Integrity (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| C7.1 | Session isolation | Anna's session can't access Mike's data via API | 403 or filtered results | |
| C7.2 | No data leakage in history | Anna sees only her expenses | Mike's expenses not visible | |
| C7.3 | Supervisor sees all | Lisa sees both Anna's and Mike's pending items | Complete view | |
| C7.4 | Logout doesn't affect others | Anna logs out | Mike, Lisa, John still active | |
| C7.5 | Re-login fresh session | Anna logs back in | New session, data intact | |
| C7.6 | Rapid API calls | Anna submits 5 claims in rapid succession | All 5 created, no duplicates | |
| C7.7 | Concurrent receipt viewing | Lisa views Anna's receipt, John views Mike's receipt | Both load independently | |
| C7.8 | DB consistency | Compare total expenses in employee view vs supervisor view | Numbers match | |

## Phase 8: Stress & Edge Cases (6 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| C8.1 | 10 rapid expense submissions | Script: submit 10 expenses in 5 seconds | All 10 created, unique IDs | |
| C8.2 | Approve/reject rapid fire | Lisa approves 5 claims in 10 seconds | All processed correctly | |
| C8.3 | Concurrent PDF generation | 3 PDFs requested simultaneously | All 3 generated without error | |
| C8.4 | Large claim group | Submit claim with 10 line items | All items saved | |
| C8.5 | Simultaneous language toggle | Anna switches to FR while Mike switches to EN | No interference | |
| C8.6 | Server error recovery | Force an invalid API call | Error returned, app still functional | |

---

## Total: 58 concurrent tests across 8 phases

## Execution Approach
Tests will be executed using multiple concurrent browser sessions and API calls via curl/fetch to simulate simultaneous users. Each session maintains its own auth token.

## Success Criteria
- **Zero data corruption** — no user sees another user's data
- **Zero session bleed** — sessions remain independent
- **Zero lost writes** — every submission is recorded
- **Race conditions handled** — double-approve doesn't create duplicates
- **95%+ pass rate** on all testable scenarios
