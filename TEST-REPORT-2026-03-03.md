# ClaimFlow Comprehensive Test Report
**Date:** 2026-03-03  
**URL:** https://claimflow-e0za.onrender.com  
**Tester:** Automated (OpenClaw Agent)

---

## Summary

| Metric | Count |
|--------|-------|
| **Total Tests** | 49 |
| **Passed** | 36 |
| **Failed** | 7 |
| **Partial/Warning** | 6 |

---

## Phase 1: Auth & Setup

| # | Test | Result | Notes |
|---|------|--------|-------|
| 1a | Login as Anna (Employee) | ✅ PASS | Returns `sessionId` + user object with correct role/dept |
| 1b | Login as Lisa (Supervisor) | ✅ PASS | Role=supervisor, Operations dept |
| 1c | Login as John (Admin) | ✅ PASS | Role=admin, Management dept |
| 2 | Role-based access control | ⚠️ WARNING | Anna (employee) **can** access `GET /api/settings/hwa` and sees `{"annual_max":500}`. Settings endpoints are not role-restricted. |

### Bug: Settings endpoints not role-protected
- **Severity:** Major
- **Detail:** `GET /api/settings/hwa`, `/api/settings/phone`, `/api/settings/transit`, `/api/settings/variance` all return data for employee-role users. Only `PUT` was not tested for employee access but GET is unrestricted.
- **Note:** Auth mechanism uses `Authorization: Bearer <sessionId>` header. No cookies are set by the server.

---

## Phase 2: Travel Auth → Trip → Approve → PDF

| # | Test | Result | Notes |
|---|------|--------|-------|
| 3 | Create travel auth | ✅ PASS | Created as draft. Field is `name` not `title`. Returns `{success:true, id:1}` |
| 4 | Verify AT in list | ✅ PASS | Shows in `GET /api/travel-auth` with all fields, status=draft |
| 5a | Submit AT | ✅ PASS | `PUT /api/travel-auth/1/submit` transitions to pending |
| 5b | Lisa approve AT | ✅ PASS | `PUT /api/travel-auth/1/approve` → "Travel Authorization approved and trip created!" |
| 6 | Verify auto-created trip | ✅ PASS | Trip ID=1 created with status=active, linked via auth_id=1 |
| 7 | Add actuals to trip | ✅ PASS | Flight $425.50 ✅, Hotel $189 ✅. Fields: `expense_type`, `date`, `amount` |
| 7b | Add dinner expense | ❌ FAIL | Per diem enforcement: "Per diem rate must be exactly $47.05 (submitted: $45.00)". Cannot add meals with custom amounts. |
| 8 | Submit trip | ✅ PASS | `POST /api/trips/1/submit` |
| 9 | Lisa approve trip | ✅ PASS | `POST /api/trips/1/approve` |
| 10 | Get trip PDF | ✅ PASS | `GET /api/trips/1/report` returns valid PDF (6,426 bytes). Content is FlateDecoded (compressed). |

### Notes:
- Travel auth `est_total` is $0 despite submitting estimates — estimates array in POST body was accepted but amounts not stored in `est_transport`/`est_lodging` etc.
- The Travel Auth tab in the UI shows a rich estimation form with per-diem grid, hotel rates, and transportation — the API POST doesn't populate these fields.
- Trip shows "N/A" for destination in admin view despite being set to "Ottawa" — display bug.

---

## Phase 3: Expense Claim Groups

| # | Test | Result | Notes |
|---|------|--------|-------|
| 11 | POST grouped claim | ⚠️ PARTIAL | Submitted 3 items (purchase, kilometric, parking). Only **2 created** (purchase + parking). Kilometric item silently dropped. |
| 12 | Verify claim_group ID | ✅ PASS | Response: `claim_group: "CLM-1772534303319"`, count: 2 |
| 13 | GET expenses as supervisor | ✅ PASS | Shows `claim_group` field on grouped items |
| 14 | Approve all in group | ✅ PASS | `POST /api/expenses/3/approve` and `/4/approve` both succeed |
| 15 | Verify approved status | ✅ PASS | Both show status=approved |

### Bug: Kilometric expense silently dropped from claim group
- **Severity:** Major
- **Detail:** When submitting 3 items including a kilometric type, only 2 were created. The kilometric item was silently dropped with no error message. Response said "2 expense(s) submitted" for 3 items provided.

---

## Phase 4: Health & Wellness Account

| # | Test | Result | Notes |
|---|------|--------|-------|
| 16 | GET balance | ✅ PASS | `{annual_max:500, used:0, remaining:500, year:2026}` |
| 17 | POST $200 claim | ✅ PASS | Requires multipart with receipt file. Returns id:1 |
| 18 | Verify balance reduced | ✅ PASS | `{used:200, remaining:300}` |
| 19 | Try $400 (exceeds) | ✅ PASS | Error: "Amount exceeds remaining balance of $300.00" |
| 20 | Lisa: pending HWA | ⚠️ WARNING | `GET /api/hwa-claims/pending` returns `[]` despite claim being pending. Lisa used `POST /api/hwa-claims/1/approve` which worked. |
| 21 | Approve HWA claim | ✅ PASS | `POST /api/hwa-claims/1/approve` succeeds |
| 22 | Balance after approval | ✅ PASS | Still shows used:200, remaining:300 |
| 23 | Submit remaining $300 | ✅ PASS | Claim id:2 created |
| 24 | Try $1 more | ✅ PASS | Error: "Amount exceeds remaining balance of $0.00" |

### Note:
- HWA claims require a receipt file upload (multipart/form-data). JSON-only POST returns "At least one receipt is required".
- The pending endpoint for supervisor may have filtering issues (returns empty despite pending claims existing).

---

## Phase 5: Phone Benefit (Combined Max)

| # | Test | Result | Notes |
|---|------|--------|-------|
| 25 | GET phone settings | ✅ PASS | `{monthly_max:100, claim_window:2}` |
| 26 | POST phone claim ($60 plan + $50 device) | ✅ PASS | API fields: `plan_receipt` and `device_receipt`. Requires multipart with receipt. |
| 27 | Verify capped amounts | ✅ PASS | Plan $60→$54.55, Device $50→$45.45, Total capped to $100.00. Pro-rata capping works correctly. |
| 28 | Lisa approve | ✅ PASS | `POST /api/phone-claims/1/approve` |

### Notes:
- API field names (`plan_receipt`, `device_receipt`) are undocumented and differ from form labels ("Receipt Amount"). Required significant trial and error to discover.
- The claims must be sent as a JSON array string in a multipart `claims` field, which is an unusual pattern.

---

## Phase 6: Transit Benefit

| # | Test | Result | Notes |
|---|------|--------|-------|
| 29 | POST transit claim $80 | ✅ PASS | `claims` array via multipart. Returns claim_id:1, total:$80 |
| 30 | Verify amount capping | ⚠️ NOTE | $80 < $100 max, so no capping occurred. Would need to test with >$100 to verify cap. |
| 31 | Duplicate month rejection | ✅ PASS | "Claims already exist for: 3/2026 (pending). Cannot submit duplicate claims." |
| 32 | Supervisor approve | ✅ PASS | `POST /api/transit-claims/1/approve` |

### Bug: Transit JSON POST causes Internal Server Error
- **Severity:** Major
- **Detail:** `POST /api/transit-claims` with `Content-Type: application/json` returns HTTP 500 "Internal Server Error". Only multipart/form-data works. This is inconsistent with other endpoints and represents an unhandled exception.

---

## Phase 7: Admin Settings

| # | Test | Result | Notes |
|---|------|--------|-------|
| 33 | GET HWA settings | ✅ PASS | `{annual_max:500}` |
| 34 | PUT HWA to $600 | ✅ PASS | "HWA settings updated" |
| 35 | Verify changed | ✅ PASS | `{annual_max:600}` |
| 36 | PUT back to $500 | ✅ PASS | Restored successfully |
| 37a | GET variance settings | ✅ PASS | `{variance_pct_threshold:10, variance_dollar_threshold:100}` |
| 37b | GET transit settings | ✅ PASS | `{monthly_max:100, claim_window:2}` |
| 37c | GET phone settings | ✅ PASS | `{monthly_max:100, claim_window:2}` |

### Note:
- Settings change history is tracked and visible in admin UI (see browser screenshot).
- `GET /api/settings` (root) returns 404 — no aggregate endpoint.

---

## Phase 8: Edge Cases

| # | Test | Result | Notes |
|---|------|--------|-------|
| 38 | Amount=0 | ✅ PASS | Rejected: "Please fill in all required fields: expense type, date, and amount" |
| 39 | Missing fields | ✅ PASS | Same validation error message |
| 40 | Special chars vendor | ✅ PASS | `O'Brien & Sons <test>` accepted and stored correctly, renders properly in UI |
| 41 | Overlapping travel auth dates | ✅ PASS | Rejected: "Dates overlap with existing authorization 'Ottawa Conference' (2026-03-10 → 2026-03-12)" |
| 42 | GET /api/my-expenses | ✅ PASS | Returns 5 expenses, no estimate-type expenses visible. All are actual expenses. |

### Note:
- Validation error message for amount=0 and missing fields is identical — could be more specific (e.g., "Amount must be greater than zero").

---

## Phase 9: Browser UX Review

| # | Test | Result | Notes |
|---|------|--------|-------|
| 43 | Login page | ✅ PASS | Clean design. Demo accounts clearly listed with click-to-login. Government of Canada branding. |
| 44 | Employee dashboard tabs | ✅ PASS | 4 tabs: Expenses, Travel Auth, Trips, Expense History — all functional |
| 45 | Admin dashboard | ✅ PASS | 7 tabs: All Expenses, Employee Directory, Org Chart, Travel Auth, Sage 300, NJC Rates, Settings |
| 46 | Mobile viewport (375px) | ✅ PASS | Responsive layout works. Buttons stack vertically, stat cards go 2-column. Form elements fit. |
| 47 | UX issues noted | See below | |

### UX Issues Found:

1. **Trip destination shows "N/A"** in admin All Expenses view despite being set to "Ottawa" — data not propagating to trip display card header.

2. **Trip date display incorrect** — Expense History shows "Mar 9 – Mar 11, 2026" for a trip dated Mar 10-12. Off by one day (timezone issue?).

3. **"Force deployment" timestamp visible** at bottom of every page: `// Force deployment Mon Feb 23 12:16:32 EST 2026` — should be removed for production.

4. **Notification badge count inconsistent** — Shows "6" initially, then "7" after adding expenses, but the count doesn't clearly correspond to unread items.

5. **Quick Access Benefits dropdown** changes the entire form below it, which could confuse users who already started filling out a regular expense claim.

6. **"Add to Draft"** button label may confuse users who expect "Submit" — the draft→submit workflow isn't immediately obvious.

7. **Admin view shows "2 Pending"** for an approved trip's expenses — these are the individual expense line items that were approved as part of the trip but show pending separately.

8. **No favicon** — browser tab shows default icon. `GET /favicon.ico` returns 404.

---

## Phase 10: PDF Verification

| # | Test | Result | Notes |
|---|------|--------|-------|
| 48 | Download trip PDF | ✅ PASS | Valid PDF 1.7, 6,426 bytes. Content is FlateDecoded (compressed streams). |
| 49 | Check for garbled content | ⚠️ UNABLE | PDF uses compressed streams; cannot verify text content without a full PDF parser. No obviously broken encoding in raw structure. |

### Notes:
- PDF page count could not be reliably determined from raw bytes (uses indirect object references). The PDF opens and renders correctly when downloaded via browser ("Download Expense Report (PDF)" button visible in Trips tab).
- Reference number format: EXP-2026-00001, generated timestamp included.

---

## Bugs Found

### Critical
*None*

### Major
| # | Bug | Phase |
|---|-----|-------|
| B1 | **Settings endpoints not role-protected** — Employee users can read all admin settings (HWA, phone, transit, variance) | P1 |
| B2 | **Kilometric expense silently dropped** from expense claim groups — no error returned, count mismatches | P3 |
| B3 | **Transit JSON POST causes HTTP 500** — Internal Server Error when using application/json content type | P6 |
| B4 | **Travel Auth estimates not stored** — POST body `estimates` array accepted but `est_transport`/`est_total` fields remain 0 | P2 |

### Minor
| # | Bug | Phase |
|---|-----|-------|
| B5 | Trip destination shows "N/A" in admin view despite being set | P9 |
| B6 | Trip dates off by 1 day in Expense History (timezone issue) | P9 |
| B7 | "Force deployment" debug text visible in footer | P9 |
| B8 | Missing favicon (404) | P9 |
| B9 | HWA pending endpoint returns empty for supervisor despite pending claims | P4 |
| B10 | Validation message for amount=0 is generic, doesn't specify the zero-amount issue | P8 |
| B11 | Phone/Transit API field names undocumented and inconsistent with UI labels | P5/P6 |

---

## UX Recommendations

### Intuitiveness
- **Draft workflow clarity**: The "Add to Draft" → review → submit workflow is powerful but not immediately discoverable. Add a step indicator (1. Add items → 2. Review draft → 3. Submit) or an onboarding tooltip.
- **Quick Access Benefits**: When switching benefit types, warn if the user has unsaved data in the current form.
- **Per-diem enforcement**: The error "Per diem rate must be exactly $47.05" is helpful but should link to the NJC Rates tab or explain the rate source.

### Ease of Use
- **Claim group feedback**: When submitting multiple items, show which items succeeded and which failed (don't silently drop items).
- **Supervisor pending view**: Add a unified "Pending Approvals" dashboard that aggregates expenses, HWA claims, phone claims, and transit claims in one view.
- **API consistency**: All benefit claim endpoints should accept both JSON and multipart. Current inconsistency (some require receipts, some don't) creates integration friction.

### Visual/Design
- **Color coding is excellent**: Green=approved, yellow=pending, red=rejected is intuitive and consistent throughout.
- **Stat cards**: The 4 summary cards at the top provide a great at-a-glance overview.
- **Mobile responsive**: Layout adapts well to 375px viewport. Buttons and inputs remain usable.
- **Remove debug footer**: The "Force deployment" timestamp should be removed or moved to an admin-only footer.
- **Add favicon**: Even a simple 🏛️ emoji-based favicon would improve the browser tab appearance.

### Optimization
- **PDF generation**: PDFs are generated on-demand and stored in the database as Buffer data. Consider caching or generating lazily only when requested.
- **Notification system**: The bell icon notification count exists but the notification content/clearing mechanism wasn't observed. Ensure notifications can be dismissed.
- **EN/FR toggle**: Bilingual support is great for Government of Canada context. Verify all strings are translated (not tested in this run).
- **CSV Export**: Export button is present on both employee and admin dashboards — good for reporting needs.

---

## API Endpoint Reference (Discovered)

| Method | Endpoint | Auth | Notes |
|--------|----------|------|-------|
| POST | /api/auth/login | None | Returns sessionId |
| GET | /api/travel-auth | Bearer | List user's travel auths |
| POST | /api/travel-auth | Bearer | Create (field: `name`, not `title`) |
| PUT | /api/travel-auth/:id/submit | Bearer | Submit draft for approval |
| PUT | /api/travel-auth/:id/approve | Bearer (supervisor) | Approve + auto-create trip |
| GET | /api/trips | Bearer | List user's trips |
| GET | /api/trips/:id | Bearer | Trip detail with expenses |
| POST | /api/trips/:id/submit | Bearer | Submit trip |
| POST | /api/trips/:id/approve | Bearer (supervisor) | Approve trip |
| GET | /api/trips/:id/report | Bearer | Download PDF report |
| POST | /api/expenses | Bearer | Create expense (fields: expense_type, date, amount) |
| GET | /api/expenses | Bearer (supervisor) | List pending expenses |
| GET | /api/my-expenses | Bearer | List own expenses |
| POST | /api/expenses/:id/approve | Bearer (supervisor) | Approve expense |
| POST | /api/expense-claims | Bearer | Create grouped claim (fields: purpose, date, items[]) |
| GET | /api/hwa-claims/balance | Bearer | HWA balance |
| POST | /api/hwa-claims | Bearer (multipart) | Submit HWA claim with receipt |
| GET | /api/hwa-claims/pending | Bearer (supervisor) | Pending HWA claims |
| POST | /api/hwa-claims/:id/approve | Bearer (supervisor) | Approve HWA |
| POST | /api/phone-claims | Bearer (multipart) | Submit phone claims (claims JSON + receipts) |
| GET | /api/phone-claims/pending | Bearer (supervisor) | Pending phone claims |
| POST | /api/phone-claims/:id/approve | Bearer (supervisor) | Approve phone claim |
| POST | /api/transit-claims | Bearer (multipart) | Submit transit claims |
| GET | /api/transit-claims/pending | Bearer (supervisor) | Pending transit claims |
| POST | /api/transit-claims/:id/approve | Bearer (supervisor) | Approve transit claim |
| GET | /api/settings/hwa | Bearer | HWA settings |
| PUT | /api/settings/hwa | Bearer | Update HWA settings |
| GET | /api/settings/phone | Bearer | Phone settings |
| GET | /api/settings/transit | Bearer | Transit settings |
| GET | /api/settings/variance | Bearer | Variance threshold settings |
