# ClaimFlow — Expense Management System

**Version:** v8.2 | **Tag:** `v8.2-receipts-auth-2026-03-03` | **Commit:** `c9ee5b5`  
**Last Updated:** March 3, 2026 11:50 AM EST  
**Production URL:** https://claimflow-e0za.onrender.com  
**Repository:** https://github.com/Thunder207/claimflow.git

---

## What Is ClaimFlow?

A full-featured, mobile-first expense management system for organizations. Employees submit expenses, supervisors approve/reject with receipts, and PDF reports are auto-generated. Built as a single Node.js app with SQLite.

---

## Quick Start

```bash
# Clone
git clone https://github.com/Thunder207/claimflow.git
cd claimflow

# Install dependencies
npm install

# Run locally
node app.js
# → http://localhost:3000
```

No environment variables required. SQLite DB auto-creates on first run with seed data.

---

## Default Test Accounts

| Role | Name | Email | Password |
|------|------|-------|----------|
| Admin | John Smith | john.smith@company.com | manager123 |
| Supervisor | Lisa Brown | lisa.brown@company.com | lisa123 |
| Employee | Anna Lee | anna.lee@company.com | anna123 |
| Employee | Mike Davis | mike.davis@company.com | mike123 |

---

## Architecture

### Files
```
app.js                    # Backend: Express server, all API routes, PDF generation, SQLite DB
employee-dashboard.html   # Employee frontend: submit expenses, trips, benefits, view history
admin.html                # Supervisor/Admin frontend: approve/reject, settings, reports
login.html                # Login page
style.css                 # Shared styles
translations.js           # i18n (EN/FR)
package.json              # Dependencies
```

### Tech Stack
- **Backend:** Node.js + Express
- **Database:** SQLite3 (auto-created, file-based)
- **PDF Generation:** PDFKit (pages) → pdf-lib (receipt merge + footers)
- **Auth:** Session-based (Bearer token in Authorization header)
- **Deployment:** Render.com (free tier, ephemeral storage — DB resets on deploy)
- **Frontend:** Vanilla JS, no framework, mobile-first responsive

### Database
SQLite auto-creates all tables on startup. Key tables:
- `employees` — user accounts with roles (employee/supervisor/admin)
- `expenses` — all expense line items (with receipt BLOBs)
- `travel_authorizations` — pre-trip approval requests
- `trips` — active business trips with day planner
- `transit_claims` / `transit_claim_receipts` — public transit benefit
- `phone_claims` / `phone_claim_receipts` — phone/telecom benefit  
- `hwa_claims` / `hwa_claim_receipts` — health & wellness account
- `expense_claim_receipts` — receipts for grouped expense claims
- `settings` — admin-configurable thresholds and limits

---

## Features

### 1. Expense Claims (Grouped)
- Employee creates a claim with a purpose, date, and multiple line items
- **Categories:** Purchase/Supply, Kilometric, Parking, Phone/Telecom, Software/Subscriptions, Professional Development, Internet, Other
- **Kilometric:** Auto-calculated at NJC rate ($0.61/km first 5000km, $0.55/km after) — no receipt required
- **All other categories:** Receipt mandatory (camera, photo, PDF, documents)
- Draft system: add multiple claims to draft, review, submit all at once
- Receipts stored as BLOBs in database
- Supervisor views receipts in-app modal, approves/rejects grouped claims
- PDF generated on approval with all receipts embedded

### 2. Business Trips
- **Travel Authorization (AT):** Pre-trip approval with estimated costs
- **Day Planner:** Visual grid for per diem (breakfast, lunch, dinner, incidentals) per day
- **Transport:** Flight, train, bus, rental, taxi with receipt uploads
- **Hotel:** Multi-page receipt upload, optional AI scanning (Phase 2)
- **Variance View:** AT estimate vs actual expense comparison with color-coded status
- **PDF Report:** Full trip report with all receipts, auto-generated on approval

### 3. Public Transit Benefit
- Monthly transit pass reimbursement (configurable max, default $150/month)
- Receipt upload per month, supervisor approval, PDF report

### 4. Phone Benefit
- Monthly phone reimbursement (combined plan + device cap, default $100/month)
- Multi-page receipt upload, proportional split when capped
- Supervisor approval, PDF report

### 5. Health & Wellness Account (HWA)
- Annual wellness benefit (default $500/year)
- Balance tracking: pending + approved count against annual max
- Receipt upload, supervisor approval

### 6. Supervisor Dashboard
- Pending approvals across all expense types
- Two-click approve/reject pattern (confirm before action)
- Receipt viewing in modal overlay
- Expense history with filters
- Audit trail for all actions

### 7. Admin Settings
- Variance thresholds (% and $)
- Transit, phone, HWA benefit limits
- All changes logged with audit trail

---

## API Endpoints (Key)

### Auth
- `POST /api/login` — `{email, password}` → `{sessionId, user}`

### Expenses
- `POST /api/expense-claims` — Submit grouped expense claim (multipart: purpose, date, items JSON, receipt files)
- `GET /api/my-expenses` — Employee's expenses
- `GET /api/expense-claims/:id/receipt` — Get receipt BLOB (requires auth)
- `GET /api/expense-claims/group/:claimGroup/pdf` — Download claim group PDF

### Trips
- `POST /api/travel-auth` — Create travel authorization
- `POST /api/trips` — Create trip
- `GET /api/trips/:id/report` — Download trip PDF (`?token=sessionId`)

### Benefits
- `POST /api/transit-claims` — Submit transit claim
- `POST /api/phone-claims` — Submit phone claim
- `POST /api/hwa-claims` — Submit HWA claim
- `GET /api/transit-claims/:id/pdf` — Transit PDF (`?auth=sessionId`)
- `GET /api/phone-claims/:id/pdf` — Phone PDF (`?auth=sessionId`)

### Supervisor
- `GET /api/pending-expenses` — All pending expenses
- `POST /api/expenses/:id/approve` — Approve expense
- `POST /api/expenses/:id/reject` — Reject expense (with reason)
- Similar approve/reject for transit, phone, HWA claims

### Settings (Admin)
- `GET/PUT /api/settings/transit`
- `GET/PUT /api/settings/phone`
- `GET/PUT /api/settings/hwa`
- `GET/PUT /api/settings/variance`

---

## Deployment

### Render.com (Current)
```bash
# Deploy latest commit
curl -X POST \
  -H "Authorization: Bearer rnd_PM94FfZa3hFY3OzBJ1Ao5j9yD0qI" \
  -H "Content-Type: application/json" \
  'https://api.render.com/v1/services/srv-d6aj99rnv86c739nt670/deploys' \
  -d '{"clearCache":"do_not_clear"}'
```

**Important:** Render free tier uses ephemeral storage. SQLite DB resets on every deploy. For persistent data, migrate to PostgreSQL or use a persistent disk.

### Any Node.js Host
```bash
npm install
PORT=3000 node app.js
```

---

## Git Tags (Rollback Points)

| Tag | Date | Description |
|-----|------|-------------|
| `v8.2-receipts-auth-2026-03-03` | Mar 3, 2026 | **CURRENT PREFERRED** — Receipt auth fixes, mandatory receipts, supervisor modal view |
| `v8.1-draft-fix-2026-03-03` | Mar 3, 2026 | Add to Draft button fix |
| `v8.0-hwa-expense-groups-2026-03-02` | Mar 2, 2026 | HWA + expense groups |
| `v7.3-pdf-fixes-2026-03-02` | Mar 2, 2026 | PDF emoji/ghost page fixes |
| `v7.0-phone-benefit-2026-03-01` | Mar 1, 2026 | Phone benefit feature |
| `v5.1-ux-optimized-2026-02-24-VERIFIED` | Feb 24, 2026 | **GOLDEN** — Last user-verified stable |

```bash
# Rollback to any tag
git checkout <tag-name>
git push -f origin main
# Then deploy on Render
```

---

## Key Technical Decisions

1. **No frameworks** — Vanilla JS frontend for simplicity and zero build step
2. **SQLite** — Zero-config database, auto-creates tables with seed data
3. **BLOB storage** — Receipts stored as binary in DB (survives Render ephemeral storage between requests, but not deploys)
4. **PDF: PDFKit + pdf-lib** — PDFKit generates pages, pdf-lib merges receipt images + adds footers in post-processing pass. Never use PDFKit `bufferPages:true` (creates ghost pages)
5. **Plain text in PDFs** — PDFKit Helvetica can't render Unicode emojis
6. **Auth via fetch headers** — All API calls use `Authorization: Bearer <sessionId>`. Receipt/PDF viewing uses fetch + blob URL (not direct links) to maintain auth
7. **Client-side image compression** — Images >500KB resized to 1200px width, JPEG 0.7 quality before upload
8. **Two-click approve pattern** — First click shows confirm, second click executes (no browser dialogs)
9. **Kilometric NJC rate** — $0.61/km first 5000km, $0.55/km after, calculated server-side
10. **i18n caution** — `translations.js` replaces `textContent` on `data-i18n` elements, which destroys child elements. Never put `data-i18n` on a parent that contains child elements with IDs

---

## Known Limitations

- **Ephemeral storage on Render** — DB resets on deploy (seed data re-created)
- **No persistent file storage** — All receipts in SQLite BLOBs
- **No email notifications** — Approval/rejection is in-app only
- **Single-server** — No clustering, WebSocket, or real-time updates
- **No password reset** — Accounts managed via seed data

---

## Development Notes

- **Backup before major changes:** `cp app.js app.js.backup-<feature>-<date>`
- **Test on mobile:** App is mobile-first, always test on phone
- **Don't use `showMessage()` in receipt handlers** — causes scroll-to-top on mobile
- **Don't use `confirm()` or `prompt()`** — use inline two-click UI
- **All `getElementById()` calls must be null-safe** — mobile browsers can lose DOM elements
- **Every code change gets a sub-agent audit before deploy**

---

## Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | This file — full system overview |
| `ARCHITECTURE.md` | Deep technical architecture (trip workflow, day planner) |
| `CONTINUITY.md` | Feature history and decision log |
| `QUALITY-GATE.md` | Code audit process |
| `PDF-FIXES-2026-03-02.md` | PDF generation fix details |
| `PHONE-BENEFIT-COMPLETION-REPORT.md` | Phone benefit implementation |
| `TRANSPORT-HOTEL-RECEIPTS-REPORT.md` | Receipt system details |
| `TEST-REPORT-2026-03-03.md` | Latest test results |
