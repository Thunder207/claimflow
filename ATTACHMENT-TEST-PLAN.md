# ClaimFlow — Attachment & Receipt Test Plan
**Date:** March 3, 2026  
**Purpose:** Verify every receipt/attachment upload, storage, viewing, and PDF embedding works perfectly across all features

---

## Test Accounts
| Role | Email | Password |
|------|-------|----------|
| Employee | anna.lee@company.com | anna123 |
| Supervisor | lisa.brown@company.com | lisa123 |

---

## Phase 1: Expense Claim Receipts (12 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| A1.1 | Upload JPG receipt | Create Purchase item, attach JPG photo | File accepted, name shown | |
| A1.2 | Upload PNG receipt | Create Parking item, attach PNG image | File accepted, name shown | |
| A1.3 | Upload PDF receipt | Create Software item, attach PDF document | File accepted, name shown | |
| A1.4 | Upload large image (>500KB) | Attach 2MB+ photo | Compressed client-side, accepted | |
| A1.5 | Kilometric — no receipt needed | Create Kilometric item | No receipt field shown, submits fine | |
| A1.6 | Missing receipt blocks submit | Create Purchase with no receipt, Add to Draft | Error: receipt required | |
| A1.7 | Receipt survives draft | Add claim with receipt to draft, check draft | Receipt name shown in draft | |
| A1.8 | Receipt sent on submit | Submit draft with receipts | Server receives files (no "No receipt" in supervisor view) | |
| A1.9 | Supervisor views image receipt | Lisa views Anna's JPG receipt | Image opens in modal overlay | |
| A1.10 | Supervisor views PDF receipt | Lisa views Anna's PDF receipt | PDF opens in new tab | |
| A1.11 | Receipt in approved PDF | Approve claim, download PDF | Receipt image embedded as page in PDF | |
| A1.12 | Multiple items, mixed receipts | Claim: JPG + PDF + Kilometric(none) | All stored, all viewable, Km shows N/A | |

## Phase 2: Transport Receipts — Trips (10 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| A2.1 | Flight receipt upload | Trip day planner → Flight → attach receipt | File accepted, indicator shown | |
| A2.2 | Train receipt upload | Trip → Train → attach receipt | File accepted | |
| A2.3 | Bus receipt upload | Trip → Bus → attach receipt | File accepted | |
| A2.4 | Rental receipt upload | Trip → Rental → attach receipt | File accepted | |
| A2.5 | Taxi receipt upload | Trip → Taxi → attach receipt | File accepted | |
| A2.6 | Multiple transport receipts | Upload receipts for Flight + Taxi | Both stored separately | |
| A2.7 | Supervisor views transport receipt | Lisa views Anna's transport receipts | Receipts viewable | |
| A2.8 | Transport receipts in trip PDF | Approve trip, download PDF | Transport receipts as pages in PDF | |
| A2.9 | Replace transport receipt | Upload new receipt for same mode | Old replaced with new | |
| A2.10 | Transport receipt BLOB storage | Upload receipt, redeploy (DB resets), verify pattern | Receipt stored as BLOB (survives within session) | |

## Phase 3: Hotel Receipts — Multi-Page (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| A3.1 | Single hotel receipt | Trip → Hotel → upload 1 page | File accepted, page count shown | |
| A3.2 | Multi-page hotel receipt | Upload 3 separate images for hotel | All 3 pages stored | |
| A3.3 | Add page one at a time | Upload page 1, then page 2, then page 3 | Each added incrementally, no scroll-to-top | |
| A3.4 | Remove hotel receipt page | Remove middle page | Page removed, others remain | |
| A3.5 | Hotel receipt in trip PDF | Approve trip with hotel receipts | All hotel pages in PDF | |
| A3.6 | Supervisor views hotel receipts | Lisa views Anna's hotel receipts | All pages viewable | |
| A3.7 | Hotel optional | Submit trip with no hotel | No error, hotel section skipped | |
| A3.8 | Large hotel receipt | Upload 3MB hotel invoice | Compressed, accepted | |

## Phase 4: Transit Benefit Receipts (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| A4.1 | Transit receipt upload | Transit form → select month → attach receipt | File accepted, name shown | |
| A4.2 | Transit receipt JPG | Attach JPG transit pass photo | Accepted | |
| A4.3 | Transit receipt PDF | Attach PDF transit statement | Accepted | |
| A4.4 | Transit receipt required | Submit transit claim without receipt | Error or warning | |
| A4.5 | Supervisor views transit receipt | Lisa views pending transit receipt | Receipt viewable in modal/tab | |
| A4.6 | Transit receipt in PDF | Approve transit, download PDF | Receipt embedded in PDF | |
| A4.7 | Multiple months, each with receipt | Submit Jan + Feb transit, each with receipt | Both receipts stored separately | |
| A4.8 | Transit receipt BLOB integrity | Upload, then retrieve via API | Same file type and size | |

## Phase 5: Phone Benefit Receipts (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| A5.1 | Phone receipt upload | Phone form → attach receipt | File accepted | |
| A5.2 | Multi-page phone receipt | Upload 2 receipt pages | Both stored | |
| A5.3 | Phone receipt one-at-a-time | Upload page 1, then page 2 | Each added, no scroll-to-top | |
| A5.4 | Phone receipt required | Submit phone claim without receipt | Error | |
| A5.5 | Supervisor views phone receipt | Lisa views pending phone receipts | All pages viewable via "View Receipt" button | |
| A5.6 | Phone receipt in PDF | Approve phone claim, download PDF | Receipts in PDF | |
| A5.7 | Remove phone receipt page | Remove one page from multi-page | Page removed, others remain | |
| A5.8 | Phone receipt large file | Upload 4MB receipt photo | Compressed, accepted | |

## Phase 6: HWA Receipts (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| A6.1 | HWA receipt upload | HWA form → attach receipt | File accepted | |
| A6.2 | HWA receipt JPG | Attach gym membership photo | Accepted | |
| A6.3 | HWA receipt PDF | Attach gym invoice PDF | Accepted | |
| A6.4 | Multi-page HWA receipt | Upload 2 pages | Both stored | |
| A6.5 | HWA receipt required | Submit HWA without receipt | Error | |
| A6.6 | Supervisor views HWA receipt | Lisa views pending HWA receipt | Viewable via "View Receipt" button | |
| A6.7 | HWA receipt in PDF | Approve HWA, download PDF | Receipt in PDF | |
| A6.8 | HWA receipt BLOB integrity | Upload, retrieve, compare | Same content | |

## Phase 7: Receipt Viewing — Cross-Platform (8 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| A7.1 | Image modal — tap to close | View image receipt, tap outside | Modal closes, memory freed | |
| A7.2 | PDF opens in new tab | View PDF receipt | Opens in browser PDF viewer | |
| A7.3 | Receipt auth required | Open receipt URL directly (no auth) | 401 Unauthorized | |
| A7.4 | Receipt wrong user | Anna tries to view Mike's receipt via API | Blocked or 403 | |
| A7.5 | "No receipt" shown correctly | Item without receipt in supervisor view | Shows "No receipt" in grey, no broken link | |
| A7.6 | Kilometric shows N/A | Kilometric item in supervisor view | Shows "N/A", no receipt link | |
| A7.7 | Receipt loading error | View receipt for deleted expense | "Receipt not found" error message | |
| A7.8 | Multiple receipts rapid view | Open 3 receipts quickly | Each opens/closes properly, no stacking | |

## Phase 8: PDF Embedding — All Types (10 tests)
| # | Test | Steps | Expected | Pass/Fail |
|---|------|-------|----------|-----------|
| A8.1 | Trip PDF with all receipt types | Approve trip with flight + hotel + individual receipts | All receipts as pages in PDF | |
| A8.2 | Expense claim PDF with receipts | Approve claim group with 3 receipts | All 3 receipts in PDF | |
| A8.3 | Transit PDF with receipt | Approve transit claim | Receipt in PDF | |
| A8.4 | Phone PDF with receipts | Approve phone claim (2 pages) | Both receipt pages in PDF | |
| A8.5 | PDF page order | Check multi-receipt PDF | Summary first, then receipts in order | |
| A8.6 | PDF footers on all pages | Check PDF footers | Footer on every page including receipt pages | |
| A8.7 | PDF no emoji glitches | Check all PDF text | Plain text labels, no garbled characters | |
| A8.8 | PDF download with auth | Click PDF button | Downloads via fetch+blob (no auth error) | |
| A8.9 | Large PDF with 5+ receipts | Trip with 5 transport + 3 hotel receipts | PDF generates, all pages present | |
| A8.10 | PDF receipt image quality | Check embedded receipt images | Readable, properly sized | |

---

## Total: 72 attachment tests across 8 phases

## Execution Notes
- Phase 1 is the most critical — expense claim receipts are the newest feature
- Phases 2-3 require an approved Travel Auth + active Trip
- Phases 4-6 can run independently
- Phase 7 tests viewing across all types
- Phase 8 tests PDF embedding across all types
- Use real image files (JPG/PNG) and PDF files for testing
- Test on mobile where possible (camera capture, file picker)

## Success Criteria
- **100% upload success** — every file type accepted where expected
- **100% BLOB storage** — every receipt retrievable after storage
- **100% viewing** — images in modal, PDFs in new tab, no "content blocked"
- **100% PDF embedding** — every receipt appears as a page in the generated PDF
- **Zero scroll-to-top** — no jarring scroll behavior during upload
- **Auth enforced** — no receipt accessible without valid session
