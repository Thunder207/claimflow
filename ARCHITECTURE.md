# ClaimFlow Architecture & Developer Guide

**Last Updated:** 2026-02-20 20:50 EST  
**Current Commit:** `6bbd149` (on `main` branch)  
**Live URL:** https://claimflow-e0za.onrender.com  
**Repo:** GitHub `Thunder207/claimflow`

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [System Overview](#system-overview)
3. [Core Workflow](#core-workflow)
4. [Tech Stack](#tech-stack)
5. [File Structure](#file-structure)
6. [Database Schema](#database-schema)
7. [API Endpoints](#api-endpoints)
8. [Day Planner UI](#day-planner-ui)
9. [Frontend Architecture](#frontend-architecture)
10. [Deployment](#deployment)
11. [Demo Accounts](#demo-accounts)
12. [Known Issues & Next Steps](#known-issues--next-steps)
13. [Git History & Tags](#git-history--tags)
14. [Troubleshooting](#troubleshooting)

---

## Quick Start

```bash
# Local development
cd expense-app
npm install
node app.js
# → http://localhost:3000

# Deploy to Render
git push origin main
# Auto-deploys via render.yaml, ~3-4 min build
```

**Or trigger manual deploy:**
```bash
curl -X POST \
  -H "Authorization: Bearer rnd_PM94FfZa3hFY3OzBJ1Ao5j9yD0qI" \
  -H "Content-Type: application/json" \
  'https://api.render.com/v1/services/srv-d6aj99rnv86c739nt670/deploys' \
  -d '{"clearCache":"do_not_clear"}'
```

---

## System Overview

ClaimFlow is an **NJC-compliant government expense management system**. It handles:

- **Standalone expenses** (office supplies, phone bills, etc.)
- **Travel authorizations** with Day Planner visual grid for estimated per diem expenses
- **Business trips** with Day Planner for actual expenses
- **Supervisor approval workflows** for both travel auths and individual expenses
- **Bilingual support** (EN/FR)
- **Sage 300 export** compatibility

### Key Design Decisions

- **Day Planner over form-based UI**: Visual tap-to-toggle grid replaces dropdown expense forms
- **All per diems default ON**: Employee turns off what doesn't apply (subtract model)
- **No incidentals on last day**: Per NJC policy, incidentals only with overnight stay
- **No hotel on last day**: Return day doesn't include hotel
- **Trips auto-created on approval**: No manual trip creation — auth approval triggers it
- **Immediate server sync**: Trip Day Planner saves each toggle instantly (POST/DELETE)
- **SQLite**: Simple, file-based — but ephemeral on Render (resets each deploy)

---

## Core Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  TRAVEL AUTHORIZATION → TRIP → APPROVAL WORKFLOW                │
│                                                                 │
│  1. Employee creates Travel Authorization                       │
│     └─ Name, dates, destination, purpose                        │
│                                                                 │
│  2. Day Planner grid loads (Travel Auth tab)                    │
│     └─ Toggle per diem tiles: B/L/D/Incidentals/Hotel per day  │
│     └─ Add vehicle km, other expenses                           │
│     └─ All meals default ON; employee turns off what doesn't    │
│        apply                                                    │
│                                                                 │
│  3. Employee submits auth for approval                          │
│     └─ Status: draft → pending                                  │
│     └─ Grid becomes read-only                                   │
│     └─ Estimated expenses saved with status='estimate'          │
│                                                                 │
│  4. Supervisor approves (admin.html → Travel Auth tab)          │
│     └─ Status: pending → approved                               │
│     └─ Trip auto-created (status='active')                      │
│     └─ trip_id linked to travel_authorization                   │
│     └─ Employee notified                                        │
│                                                                 │
│  5. Trip appears in employee's Trips tab                        │
│     └─ Day Planner grid for ACTUAL expenses                     │
│     └─ Toggle tiles → instant POST/DELETE to server             │
│     └─ Add actual vehicle km                                    │
│                                                                 │
│  6. Employee submits trip                                       │
│     └─ Trip status: active → submitted                          │
│     └─ Grid becomes read-only                                   │
│     └─ Supervisor notified                                      │
│                                                                 │
│  7. Supervisor approves individual expenses                     │
│     └─ Team Approvals tab in admin.html                         │
│     └─ Each expense: pending → approved                         │
│     └─ Employee notified per expense                            │
└─────────────────────────────────────────────────────────────────┘
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | Node.js + Express |
| **Database** | SQLite3 (via `better-sqlite3`) |
| **Frontend** | Vanilla HTML/CSS/JS (no framework) |
| **Auth** | Session-based (cookie + in-memory sessions) |
| **File Upload** | Multer (receipts) |
| **Deployment** | Render.com (native Node runtime via `render.yaml`) |
| **i18n** | Custom bilingual system (EN/FR) |

---

## File Structure

```
expense-app/
├── app.js                      # Backend — Express server, all API routes, DB schema (~4500 lines)
├── employee-dashboard.html     # Employee UI — expenses, travel auth, trips, Day Planner (~5400 lines)
├── admin.html                  # Supervisor/Admin UI — approvals, team mgmt, travel auth (~3600 lines)
├── login.html                  # Login page with demo account cards
├── translations.json           # EN/FR translations
├── package.json                # Dependencies
├── render.yaml                 # Render.com deployment config
├── Dockerfile.disabled         # Docker (disabled — Render uses native Node)
├── README.md                   # Basic readme
├── ARCHITECTURE.md             # ← YOU ARE HERE
└── *.md                        # Various audit/phase reports from development
```

### Key Sections in employee-dashboard.html

The file is ~5400 lines of HTML + embedded `<script>`. Key sections:

| Line Range (approx) | Section |
|---------------------|---------|
| 1–800 | HTML structure, CSS styles |
| 800–1200 | Expenses tab (standalone expenses form) |
| 1200–1600 | Travel Auth tab HTML skeleton |
| 1600–1900 | Trips tab HTML skeleton |
| 1900–2200 | Expense History tab |
| 2200+ | `<script>` — all JavaScript |

### Key Sections in app.js

| Line Range (approx) | Section |
|---------------------|---------|
| 1–80 | Imports, middleware, session setup |
| 80–650 | DB schema creation, seed data, health checks |
| 650–810 | Auth routes (login, logout, me, register) |
| 810–1130 | Expense CRUD |
| 1130–1400 | Audit trail, delegation, receipts |
| 1400–1900 | My expenses, expense approval/rejection/return |
| 1900–2400 | Employee management, audit logs |
| 2400–2800 | NJC rates management |
| 2800–3100 | Trips CRUD, trip submission |
| 3100–3350 | Upload, OCR, dashboard stats, expense edit/delete |
| 3350–3950 | Travel Authorization CRUD, approval, submission |
| 3950–4100 | CSV export, Sage 300 GL/cost center management |
| 4100–4500 | Sage export, signup system, invite system |

---

## Database Schema

### Core Tables

**employees**
```sql
id, name, employee_number, email, password_hash, position, department,
supervisor_id, is_active, role ('employee'|'supervisor'|'admin'),
delegate_id, delegation_start_date, delegation_end_date, delegation_reason,
last_login, created_at
```

**travel_authorizations**
```sql
id, employee_id, name, trip_id, destination, start_date, end_date, purpose,
est_transport, est_lodging, est_meals, est_other, est_total,
approver_id, status ('draft'|'pending'|'approved'|'rejected'),
rejection_reason, approved_at, created_at, updated_at
```

**trips**
```sql
id, employee_id, trip_name, destination, purpose, start_date, end_date,
status ('draft'|'active'|'submitted'|'approved'|'rejected'),
total_amount, submitted_at, approved_by, approved_at, approval_comment,
rejection_reason, created_at, updated_at
```

**expenses**
```sql
id, employee_name, employee_id, trip_id, travel_auth_id,
expense_type, meal_name, date, location, amount, vendor, description,
receipt_photo, status ('pending'|'approved'|'rejected'|'returned'|'estimate'),
approved_by, approved_at, approval_comment, rejection_reason,
return_reason, returned_by, returned_at, created_at, updated_at
```

### Important Status Values

| Table | Statuses | Notes |
|-------|----------|-------|
| `travel_authorizations` | draft, pending, approved, rejected | Approval auto-creates trip |
| `trips` | draft, active, submitted, approved, rejected | Auto-created trips start as `active` |
| `expenses` | pending, approved, rejected, returned, **estimate** | `estimate` = from travel auth Day Planner |

### Key Relationships

- `travel_authorizations.trip_id` → `trips.id` (linked after approval)
- `expenses.trip_id` → `trips.id` (actual trip expenses)
- `expenses.travel_auth_id` → `travel_authorizations.id` (estimated expenses)
- `expenses.status = 'estimate'` → travel auth estimated expenses (excluded from duplicate checks)
- `employees.supervisor_id` → `employees.id` (reporting chain)

---

## API Endpoints

### Authentication
| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/auth/login` | Login with email/password |
| POST | `/api/auth/logout` | Logout |
| GET | `/api/auth/me` | Current user info |

### Travel Authorizations
| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/travel-auth` | List user's travel authorizations |
| POST | `/api/travel-auth` | Create new authorization |
| GET | `/api/travel-auth/:id` | Get single authorization |
| PUT | `/api/travel-auth/:id` | Edit authorization (draft only) |
| PUT | `/api/travel-auth/:id/submit` | Submit for approval (draft → pending) |
| PUT | `/api/travel-auth/:id/approve` | Supervisor approves (→ auto-creates trip) |
| PUT | `/api/travel-auth/:id/reject` | Supervisor rejects |
| POST | `/api/travel-auth/:id/expenses` | Add estimated expense to auth |
| GET | `/api/travel-auth/:id/expenses` | List estimated expenses for auth |
| DELETE | `/api/travel-auth/:id/expenses/:expenseId` | Remove estimated expense |

### Trips
| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/trips` | List user's trips |
| POST | `/api/trips` | Create trip manually |
| GET | `/api/trips/:id` | Get trip details |
| POST | `/api/trips/:id/submit` | Submit trip for approval |

### Expenses
| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/expenses` | List expenses (supervisor view) |
| POST | `/api/expenses` | Create expense (standalone or trip) |
| GET | `/api/my-expenses` | List current user's expenses |
| PUT | `/api/expenses/:id` | Edit expense |
| DELETE | `/api/expenses/:id/mine` | Delete own expense (trip Day Planner toggle-off) |
| POST | `/api/expenses/:id/approve` | Supervisor approves expense |
| POST | `/api/expenses/:id/reject` | Supervisor rejects expense |
| POST | `/api/expenses/:id/return` | Supervisor returns expense for correction |

---

## Day Planner UI

The Day Planner is the core UX innovation — a visual toggle grid replacing traditional expense forms.

### Travel Auth Day Planner (Estimates)

**Functions** (in `employee-dashboard.html`):
- `dpBuildGrid()` — Builds the grid from travel auth dates
- `dpRenderCards()` — Renders day cards with per diem tiles
- `dpToggle(dayIndex, type)` — Toggles a tile on/off
- `dpRecalcTotal()` — Recalculates running total
- `dpSubmitForApproval()` — Submits auth + all enabled tiles as estimated expenses

**State** stored in `dpState` object:
```js
dpState = {
  authId: number,
  startDate: string,
  endDate: string,
  destination: string,
  days: [
    {
      date: '2026-03-10',
      label: 'Day 1 (Departure)',
      meals: { breakfast: true, lunch: true, dinner: true, incidentals: true },
      hotel: { enabled: false, amount: 0 }
    },
    // ... one per day
  ],
  vehicleKm: 0,
  otherExpenses: [],
  total: 0
}
```

### Trip Day Planner (Actuals)

**Functions**:
- `tdpLoadTrip(tripId)` — Loads trip data and existing expenses
- `tdpBuildGrid()` — Builds grid, pre-fills from existing expenses
- `tdpRenderCards()` — Renders interactive tiles
- `tdpToggle(dayIndex, type)` — Toggle ON = `POST /api/expenses`, Toggle OFF = `DELETE /api/expenses/:id/mine`
- `tdpSubmitTrip()` — Submits trip (changes status to `submitted`)

**State** stored in `tdpState` object (similar to `dpState` but with expense IDs for server sync).

### NJC Per Diem Rates (Hardcoded)

| Type | Rate |
|------|------|
| Breakfast | $23.45 |
| Lunch | $29.75 |
| Dinner | $47.05 |
| Incidentals | $32.08 |
| Vehicle | $0.68/km |
| Hotel | User-entered amount |

### Day Rules

- **First day** (Departure): All meals + incidentals + hotel (if multi-day)
- **Middle days**: All meals + incidentals + hotel
- **Last day** (Return): Meals only — **NO incidentals, NO hotel** (no overnight stay on return day)
- **Single day trip**: Meals only (B/L/D) — no incidentals, no hotel

---

## Frontend Architecture

### employee-dashboard.html

Single-page app with 4 tabs:
1. **Expenses** — Standalone expense form + draft list
2. **Travel Auth** — Authorization management + Day Planner grid
3. **Trips** — Trip management + Day Planner grid for actuals
4. **Expense History** — Read-only history

**Tab switching**: `showTab('expenses'|'travel-auth'|'submit'|'history')`

Note: The Trips tab is internally `submit-tab` div (legacy naming).

**Key HTML elements:**
- `#ta-auth-select` — Travel Auth dropdown (`onchange="handleAuthSelection()"`)
- `#dp-grid-container` — Day Planner grid for travel auth estimates
- `#trip-select` — Trip dropdown (`onchange="handleTripSelection()"`)
- `#tdp-grid-container` — Day Planner grid for trip actuals
- `#supervisor-switch-btn` — Toggle to admin view (visible for supervisor/admin roles)

### admin.html

Supervisor/Admin dashboard with 4 tabs:
1. **Team Approvals** — List of team expenses with approve/reject per expense
2. **My Team** — Team member list
3. **Team Structure** — Org chart
4. **Travel Auth** — Travel authorization approval queue

**Key functions:**
- `approveExpense(id)` — Approves single expense (has `confirm()` dialog)
- `rejectExpense(id)` — Rejects single expense
- `bulkApproveExpenses()` — Bulk approve selected

### Critical Bug Patterns (Solved)

1. **Null reference at top-level kills entire script**: If `document.getElementById('x')` returns null and you call `.addEventListener()` on it, the entire `<script>` block dies. All subsequent `let` declarations fail with TDZ errors. **Solution**: Guard with `if (element)` checks.

2. **Login redirect loop**: Session verification and data loading must be in separate try/catch blocks. Session failure → redirect to login. Data loading failure → log error, don't redirect.

3. **`confirm()` dialogs block automation**: Browser automation tools can't interact with `confirm()`. Either remove or make optional.

---

## Deployment

### Render.com Configuration

- **Service ID**: `srv-d6aj99rnv86c739nt670`
- **URL**: https://claimflow-e0za.onrender.com
- **Runtime**: Native Node.js (not Docker)
- **Build Command**: `npm install`
- **Start Command**: `node app.js`
- **Auto-deploy**: On push to `main` branch
- **Build time**: ~3-4 minutes

### ⚠️ SQLite is Ephemeral on Render

Every deploy resets the database. All test data is lost. The app seeds demo accounts and NJC rates on startup, but any user-created data (auths, trips, expenses) is gone after each deploy.

**Future**: Migrate to PostgreSQL for persistent data.

### render.yaml
```yaml
services:
  - type: web
    name: claimflow
    runtime: node
    plan: free
    buildCommand: npm install
    startCommand: node app.js
    envVars:
      - key: NODE_ENV
        value: production
      - key: SESSION_SECRET
        generateValue: true
```

---

## Demo Accounts

| Name | Email | Password | Role | Department |
|------|-------|----------|------|------------|
| John Smith | john.smith@company.com | manager123 | admin | Management |
| Sarah Johnson | sarah.johnson@company.com | sarah123 | supervisor | Finance |
| Lisa Brown | lisa.brown@company.com | lisa123 | supervisor | Operations |
| Mike Davis | mike.davis@company.com | mike123 | employee | Finance |
| David Wilson | david.wilson@company.com | david123 | employee | Operations |
| Anna Lee | anna.lee@company.com | anna123 | employee | Operations |

**Reporting chain**: Anna Lee & David Wilson → Lisa Brown (supervisor)

---

## Known Issues & Next Steps

### Issues (as of 2026-02-20 20:50 EST)

1. **Estimate expenses visible in Team Approvals** — Travel auth estimated expenses (status=`estimate`) show as ⏳ Pending in the supervisor's Team Approvals tab alongside actual trip expenses. Supervisors shouldn't need to individually approve estimates that were already approved via the travel auth. **Fix**: Filter out `status='estimate'` expenses from the Team Approvals query in `admin.html`, or show them in a separate section.

2. **`confirm()` dialogs in admin.html** — `approveExpense()` and `rejectExpense()` use `confirm()` which blocks browser automation and can be annoying. Consider removing or making optional.

3. **SQLite ephemeral on Render** — All data lost on deploy. Need PostgreSQL migration for production use.

4. **No trip-level approval** — Supervisors approve individual expenses, not the trip as a whole. Consider adding a "Approve All Trip Expenses" bulk action.

5. **Dropdown trip text doesn't update** — After toggling expenses in Trip Day Planner, the dropdown text still shows "0 expenses, $0.00" until page refresh.

### Potential Enhancements

- PostgreSQL migration for data persistence
- Cold start recovery UI (Render free tier spins down)
- Trip-level bulk approval for supervisors
- Hotel receipt upload in Day Planner
- PDF export of travel authorization documents
- Actual vs. estimated comparison report

---

## Git History & Tags

### Tags
| Tag | Commit | Description |
|-----|--------|-------------|
| `v1.0-stable-2026-02-19-1730EST` | pre-dayplanner | Old form-based UI (safe rollback point) |
| `v2.0-dayplanner-2026-02-19-2012EST` | `a8d3dc4` | Day Planner for Auth + Trips |
| `v2.1-tested-2026-02-20-2050EST` | `6bbd149` | All bug fixes, full e2e tested |

### Recent Commits (newest first)
```
6bbd149 Guard null expense-form reference blocking trip Day Planner init
53b6d02 Remove confirm dialog blocking submit for approval
9ff8cf7 Call checkSupervisorRole after user data loaded (fixes race condition)
a52331f Show Supervisor View button for admin role too
660d97f Guard null fileInput reference that killed script initialization
5f94064 Fix expense-date null reference; auto-select single auth
7d3a338 Fix login loop: separate session verification from data loading
a8d3dc4 Prevent overlapping travel authorization dates (TAG: v2.0)
bcdda97 Day Planner UI for Trips tab
3a20b0d Remove incidentals on last day
dc9a27b Day Planner UI for Travel Auth
ec7981b Allow submitting active trips
1a0862a Fix duplicate per diem check: exclude estimates (backend #2)
225c9ef Scope per diem duplicate check to same trip
68bc841 Fix all duplicate per diem checks to exclude estimates
caedd10 Exclude estimates from duplicate checks (frontend + backend)
3a6159c Show active trips in dropdown
d9d67aa Remove manual create-trip section
e9e3946 Auto-create trip when travel auth approved
4dccc9c Restrict hotel dates to auth date range
```

---

## Troubleshooting

### "Page won't load / infinite redirect"
The login redirect and data loading must be in separate try/catch blocks. If you see infinite redirects, check that session verification failure redirects to `/login`, but data loading failure does NOT redirect.

### "Buttons don't work / script errors"
Check browser console. If you see TDZ (Temporal Dead Zone) errors on `let` variables, a null reference earlier in the script killed execution. Search for `document.getElementById` calls and guard with `if (element)`.

### "Day Planner grid doesn't appear"
The grid only renders when an authorization/trip is selected from the dropdown. If there's only one item, auto-select logic triggers after 50ms delay. Check that `handleAuthSelection()` or `handleTripSelection()` is being called.

### "Supervisor View button missing"
`checkSupervisorRole()` must be called AFTER user data is loaded. It checks for `role === 'supervisor' || role === 'admin'`. The function is called at the end of the DOMContentLoaded init block.

### "Trip submit fails with 400"
The submit endpoint accepts `active` and `draft` status trips. If the trip has no expenses, submission is rejected. If there's no approved travel auth linked, it also rejects.

### "Duplicate per diem error"
Per diem duplicate checks exclude expenses with `status='estimate'` and are scoped to the same `trip_id`. If you still get duplicates, check that the estimate expenses have `status='estimate'` and the actual expenses have the correct `trip_id`.
