# ClaimFlow Architecture & Developer Guide

**Last Updated:** 2026-02-20 22:55 EST  
**Current Commit:** `d7c4318` (on `main` branch)  
**Current Tag:** `v3.0-supervisor-ui-2026-02-20-2255EST`  
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
10. [Supervisor Dashboard](#supervisor-dashboard)
11. [Governance Rules](#governance-rules)
12. [Deployment](#deployment)
13. [Demo Accounts](#demo-accounts)
14. [Known Issues & Next Steps](#known-issues--next-steps)
15. [Git History & Tags](#git-history--tags)
16. [Troubleshooting](#troubleshooting)

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

**Manual deploy trigger:**
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
- **Supervisor approval workflows** for both travel auths and trip expenses
- **Bilingual support** (EN/FR)
- **Sage 300 export** compatibility

### Key Design Decisions

- **Day Planner over form-based UI**: Visual tap-to-toggle grid replaces dropdown expense forms
- **All per diems default ON**: Employee turns off what doesn't apply (subtract model)
- **No incidentals on last day**: Per NJC policy, incidentals only with overnight stay
- **No hotel on last day**: Return day doesn't include hotel
- **Trips auto-created on approval**: No manual trip creation — auth approval triggers it
- **Immediate server sync**: Trip Day Planner saves each toggle instantly (POST/DELETE)
- **Trip-level governance**: Supervisors approve/reject ALL expenses in a trip at once — no cherry-picking
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
│  4. Supervisor reviews (admin.html → Travel Auth tab)           │
│     └─ Sees trip header with cost summary                       │
│     └─ Expandable day-by-day breakdown (click to view)          │
│     └─ Approves or rejects ENTIRE authorization                 │
│     └─ On approve: trip auto-created (status='active')          │
│                                                                 │
│  5. Trip appears in employee's Trips tab                        │
│     └─ Day Planner grid for ACTUAL expenses                     │
│     └─ Toggle tiles → instant POST/DELETE to server             │
│     └─ Add actual vehicle km, hotel amounts                     │
│                                                                 │
│  6. Employee submits trip                                       │
│     └─ Creates DB records for all enabled tiles                 │
│     └─ Trip status: active → submitted                          │
│     └─ Grid becomes read-only                                   │
│                                                                 │
│  7. Supervisor reviews trip (admin.html → Team Approvals tab)   │
│     └─ Grouped trip card with header, cost summary              │
│     └─ Expandable day-by-day breakdown with status pills        │
│     └─ "Approve All" or "Reject All" — trip-level only          │
│     └─ Rejection requires reason via inline modal               │
│     └─ NO individual expense approve/reject for trips           │
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
├── app.js                      # Backend — Express server, all API routes, DB schema (~4500+ lines)
├── employee-dashboard.html     # Employee UI — expenses, travel auth, trips, Day Planner (~5400 lines)
├── admin.html                  # Supervisor/Admin UI — approvals, team mgmt, travel auth (~3900+ lines)
├── login.html                  # Login page with demo account cards
├── translations.json           # EN/FR translations
├── package.json                # Dependencies
├── render.yaml                 # Render.com deployment config
├── Dockerfile.disabled         # Docker (disabled — Render uses native Node)
├── README.md                   # Basic readme
└── ARCHITECTURE.md             # ← YOU ARE HERE
```

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
- `expenses.status = 'estimate'` → travel auth estimated expenses (filtered from approval queues)
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
| GET | `/api/travel-auth` | List auths (employee: own only; supervisor with `?view=team`: department auths) |
| POST | `/api/travel-auth` | Create new authorization |
| GET | `/api/travel-auth/:id` | Get single authorization |
| PUT | `/api/travel-auth/:id` | Edit authorization (draft only) |
| PUT | `/api/travel-auth/:id/submit` | Submit for approval (draft → pending) |
| PUT | `/api/travel-auth/:id/approve` | Supervisor approves (→ auto-creates trip) |
| PUT | `/api/travel-auth/:id/reject` | Supervisor rejects (reason required) |
| POST | `/api/travel-auth/:id/expenses` | Add estimated expense to auth |
| GET | `/api/travel-auth/:id/expenses` | List estimated expenses for auth |
| DELETE | `/api/travel-auth/:id/expenses/:expenseId` | Remove estimated expense |

**Important:** `GET /api/travel-auth` has role-based behavior:
- **admin**: Returns ALL travel auths
- **supervisor** (no `?view=team`): Returns only supervisor's OWN auths (employee dashboard)
- **supervisor** (`?view=team`): Returns all auths in supervisor's department (admin.html approval view)
- **employee**: Returns only own auths

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
| GET | `/api/expenses` | List expenses (supervisor: team expenses with trip JOIN data) |
| POST | `/api/expenses` | Create expense (standalone or trip). Hotel type skips receipt when `trip_id` present |
| GET | `/api/my-expenses` | List current user's expenses |
| PUT | `/api/expenses/:id` | Edit expense |
| DELETE | `/api/expenses/:id/mine` | Delete own expense (trip Day Planner toggle-off) |
| POST | `/api/expenses/:id/approve` | Supervisor approves expense |
| POST | `/api/expenses/:id/reject` | Supervisor rejects expense (reason required) |
| POST | `/api/expenses/:id/return` | Supervisor returns expense for correction |

**Supervisor expense query** includes trip JOIN data: `trip_name`, `trip_start`, `trip_end`, `trip_destination`, `trip_status` — used for grouping in the UI.

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
    }
  ],
  vehicleKm: 0,
  otherExpenses: [],
  total: 0
}
```

### Trip Day Planner (Actuals)

**Functions**:
- `tdpLoadTrip(tripId)` — Loads trip data and existing expenses
- `tdpBuildGrid()` — Builds grid, pre-fills from existing expenses. When trip has 0 expenses, defaults all meals/hotels to ON visually (no DB records yet)
- `tdpRenderCards()` — Renders interactive tiles
- `tdpToggle(dayIndex, type)` — Toggle ON = `POST /api/expenses`, Toggle OFF = `DELETE /api/expenses/:id/mine`
- `tdpCreateExpense(type, date, amount, ...)` — Creates single expense on server
- `tdpDeleteExpense(expenseId)` — Deletes single expense from server
- `tdpSubmitTrip()` — **Critical**: Before calling submit endpoint, loops through all days creating DB records for any enabled meals/hotels that lack `expenseIds`. Then submits trip.

**State** stored in `tdpState` object (similar to `dpState` but with `expenseIds` for server sync).

### NJC Per Diem Rates (Hardcoded)

| Type | Rate |
|------|------|
| Breakfast | $23.45 |
| Lunch | $29.75 |
| Dinner | $47.05 |
| Incidentals | $32.08 |
| Vehicle | $0.68/km |
| Hotel | User-entered amount (default $150) |

### Day Rules

- **First day** (Departure): All meals + incidentals + hotel (if multi-day)
- **Middle days**: All meals + incidentals + hotel
- **Last day** (Return): Meals only — **NO incidentals, NO hotel**
- **Single day trip**: Meals only (B/L/D) — no incidentals, no hotel

---

## Frontend Architecture

### employee-dashboard.html (~5400 lines)

Single-page app with 4 tabs:
1. **Expenses** — Standalone expense form + draft list
2. **Travel Auth** — Authorization management + Day Planner grid
3. **Trips** — Trip management + Day Planner grid for actuals (internally `submit-tab` div)
4. **Expense History** — Read-only history

**Tab switching**: `showTab('expenses'|'travel-auth'|'submit'|'history')`

**Key HTML elements:**
- `#ta-auth-select` — Travel Auth dropdown (`onchange="handleAuthSelection()"`)
- `#dp-grid-container` — Day Planner grid for travel auth estimates
- `#trip-select` — Trip dropdown (`onchange="handleTripSelection()"`)
- `#tdp-grid-container` — Day Planner grid for trip actuals
- `#supervisor-switch-btn` — Toggle to admin view (visible for supervisor/admin roles)

**Auto-select behavior**: When only one auth/trip exists, auto-selects and triggers handler after 50ms delay.

### admin.html (~3900+ lines)

Supervisor/Admin dashboard with 4 tabs:
1. **Team Approvals** — Grouped trip expense cards with bulk approve/reject
2. **My Team** — Team member list
3. **Team Structure** — Org chart
4. **Travel Auth** — Travel authorization approval queue with expandable detail

---

## Supervisor Dashboard

### Team Approvals Tab (Trip Expenses)

Expenses are **grouped by trip** into cards:

```
┌──────────────────────────────────────────────────┐
│ ✈️ Montreal Conference                  $1,229.57 │
│ 👤 Anna Lee · 📍 montreal · 📅 Feb 21→25 (5 days)│
├──────────────────────────────────────────────────┤
│ ⏳ 23 Pending                                     │
├──────────────────────────────────────────────────┤
│ [✅ Approve All 23 Expenses] [❌ Reject All]      │
├──────────────────────────────────────────────────┤
│ [📋 View Day-by-Day Breakdown ▼]                  │
│                                                    │
│  📅 Feb 21 — Departure               $282.33      │
│  🥐 Breakfast $23.45 ⏳ | 🥗 Lunch $29.75 ⏳ ... │
│                                                    │
│  📅 Feb 25 — Return                  $100.25      │
│  🥐 Breakfast $23.45 ⏳ | 🥗 Lunch $29.75 ⏳ ... │
└──────────────────────────────────────────────────┘
```

**Key behaviors:**
- Trip expenses: ONLY bulk approve/reject (no individual buttons) — governance requirement
- Non-trip standalone expenses: Individual approve/reject buttons
- Expense pills show status colors: yellow=pending, green=approved, red=rejected
- Day breakdown is collapsed by default, click to expand

### Travel Auth Tab (Authorization Approval)

Auth cards with expandable day-by-day breakdown:

```
┌──────────────────────────────────────────────────┐
│ ✈️ Montreal Conference                  $1,229.57 │
│ 👤 Anna Lee · 📍 Ottawa, ON · 📅 Feb 21→25       │
├──────────────────────────────────────────────────┤
│ 🍽️ Meals $629.57 | 🏨 Lodging $600.00            │
├──────────────────────────────────────────────────┤
│ [📋 View Full Day-by-Day Breakdown ▼]             │
│  (click to see per-day expense tiles)             │
├──────────────────────────────────────────────────┤
│ [✅ Approve] [❌ Reject]                          │
└──────────────────────────────────────────────────┘
```

**Key behaviors:**
- Expandable detail fetches expenses from `/api/travel-auth/:id/expenses`
- Day-by-day breakdown shows expense pills per day with amounts
- Approve/reject applies to entire authorization
- Rejection opens inline modal (not `prompt()`) requiring reason ≥10 chars

### Rejection Modal

All rejection dialogs use an **inline HTML modal** (not `prompt()`):
- Overlay with textarea for rejection reason
- 10-character minimum validation
- Cancel / ❌ Reject buttons
- Used by: `rejectExpense()`, `bulkRejectTrip()`, `rejectTravelAuth()`

---

## Governance Rules

1. **Trip expenses are all-or-nothing**: Supervisor approves or rejects ALL expenses in a trip — no cherry-picking individual meals. This ensures consistent governance and prevents partial trip approvals.

2. **Travel auth is all-or-nothing**: Supervisor approves or rejects the entire authorization.

3. **Standalone expenses (not linked to a trip)**: Can be individually approved/rejected.

4. **Rejection requires a reason**: All rejection actions require a written reason (≥10 characters) via inline modal.

5. **No overlapping travel auths**: Backend rejects travel authorizations with overlapping dates for the same employee.

6. **Duplicate per diem prevention**: Backend checks prevent duplicate per diem expenses for the same type/date/trip. Checks exclude `estimate` status expenses.

7. **Estimates filtered from approval queue**: Expenses with `status='estimate'` are filtered out of the supervisor Team Approvals tab (client-side filter in admin.html).

---

## Deployment

### Render.com Configuration

- **Service ID**: `srv-d6aj99rnv86c739nt670`
- **URL**: https://claimflow-e0za.onrender.com
- **Runtime**: Native Node.js (not Docker)
- **Build Command**: `npm install`
- **Start Command**: `node app.js`
- **Auto-deploy**: On push to `main` branch
- **Build time**: ~2-4 minutes

### ⚠️ SQLite is Ephemeral on Render

Every deploy resets the database. All user-created data (auths, trips, expenses) is lost. The app seeds demo accounts and NJC rates on startup.

**Future**: Migrate to PostgreSQL for persistent data.

### Deploy API
```bash
# Trigger deploy
curl -X POST \
  -H "Authorization: Bearer rnd_PM94FfZa3hFY3OzBJ1Ao5j9yD0qI" \
  -H "Content-Type: application/json" \
  'https://api.render.com/v1/services/srv-d6aj99rnv86c739nt670/deploys' \
  -d '{"clearCache":"do_not_clear"}'

# Check deploy status
curl -H "Authorization: Bearer rnd_PM94FfZa3hFY3OzBJ1Ao5j9yD0qI" \
  'https://api.render.com/v1/services/srv-d6aj99rnv86c739nt670/deploys?limit=1'
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

**Reporting chains:**
- Anna Lee, David Wilson → Lisa Brown (Operations supervisor)
- Mike Davis → Sarah Johnson (Finance supervisor)

**Testing workflow:** Login as Anna Lee → create auth → submit → login as Lisa Brown → Switch to Supervisor View → Travel Auth tab → approve → back to Anna → Trips tab → submit → back to Lisa → Team Approvals → approve all

---

## Known Issues & Next Steps

### Current Issues (as of v3.0)

1. **SQLite ephemeral on Render** — All data lost on deploy. Need PostgreSQL for production.
2. **Dropdown text doesn't update** — After toggling expenses in Trip Day Planner, dropdown text still shows old count until page refresh.
3. **No actual-vs-estimated comparison** — No report showing how actuals compared to estimates.
4. **Hotel receipt upload UX** — Hotels created without receipts; receipt upload is in a separate section of Day Planner. Could be more intuitive.

### Resolved Issues (this session)

- ✅ Supervisor couldn't see team travel auths → Fixed with `?view=team` query param
- ✅ Supervisor saw other employees' auths on own dashboard → Separated own vs team queries
- ✅ `prompt()` dialogs blocked browser automation → Replaced with inline modal
- ✅ `confirm()` dialogs blocked automation → Removed from all approval flows
- ✅ Individual expense approve/reject in trips → Removed; trip-level only (governance)
- ✅ Flat expense list in Team Approvals → Grouped by trip with card UI
- ✅ No detail view for travel auth approval → Expandable day-by-day breakdown
- ✅ Estimate expenses in approval queue → Filtered out client-side
- ✅ Trip submit with 0 actual expenses → Pre-submit loop creates records for default-ON tiles
- ✅ Hotel rejected without receipt → Skips receipt requirement when `trip_id` present

### Potential Enhancements

- PostgreSQL migration for data persistence
- PDF export of travel authorization documents
- Actual vs. estimated comparison report
- Cold start recovery UI (Render free tier spins down)
- Email notifications for approvals/rejections
- Mobile-responsive Day Planner improvements
- Return-for-correction flow for trip expenses

---

## Git History & Tags

### Tags
| Tag | Commit | Description |
|-----|--------|-------------|
| `v1.0-stable-2026-02-19-1730EST` | pre-dayplanner | Old form-based UI (safe rollback) |
| `v2.0-dayplanner-2026-02-19-2012EST` | `a8d3dc4` | Day Planner for Auth + Trips |
| `v2.1-tested-2026-02-20-2050EST` | `a0c8249` | Bug fixes, ARCHITECTURE.md, first E2E test |
| `v3.0-supervisor-ui-2026-02-20-2255EST` | `d7c4318` | **Current** — Supervisor UI overhaul, grouped trips, governance |

### Recent Commits (newest first)
```
d7c4318 governance: remove individual expense approve/reject from trip groups, trip-level only
35fe560 fix: replace prompt() with inline modal for all rejection dialogs
2dc58ba feat: grouped trip view in Team Approvals matching Travel Auth style with day-by-day breakdown
d22c3c6 feat: expandable day-by-day breakdown in supervisor travel auth approval view
53e9364 feat: group trip expenses in supervisor view with summary cards and bulk approve/reject
78abcec fix: separate supervisor own auths from team auths via ?view=team param
27ce848 fix: supervisor travel auth view shows department auths, not just own
99e6c0b Allow hotel expenses without receipt for trip Day Planner
2df4ff5 Fix trip submit: create expense records for default-ON meals; filter estimates from approval queue
a0c8249 Add comprehensive ARCHITECTURE.md developer guide
6bbd149 Guard null expense-form reference blocking trip Day Planner init
53b6d02 Remove confirm dialog blocking submit for approval
9ff8cf7 Call checkSupervisorRole after user data loaded
a52331f Show Supervisor View button for admin role
5f94064 Fix expense-date null reference; auto-select single auth
7d3a338 Fix login loop: separate session verification from data loading
bcdda97 Day Planner UI for Trips tab
dc9a27b Day Planner UI for Travel Auth tab
```

---

## Troubleshooting

### "Page won't load / infinite redirect"
Session verification and data loading must be in separate try/catch blocks. Session failure → redirect to `/login`. Data loading failure → log error, don't redirect. Check the init block in the `<script>` section.

### "Buttons don't work / script errors"
Check browser console. If you see TDZ (Temporal Dead Zone) errors on `let` variables, a null reference earlier in the script killed execution. Search for `document.getElementById` calls and guard with `if (element)`.

### "Day Planner grid doesn't appear"
Grid renders when an auth/trip is selected from dropdown. If only one item exists, auto-select triggers after 50ms delay. Check that `handleAuthSelection()` or `handleTripSelection()` is called.

### "Supervisor View button missing"
`checkSupervisorRole()` must be called AFTER user data is loaded. Checks `role === 'supervisor' || role === 'admin'`. Called at end of DOMContentLoaded init block.

### "Supervisor doesn't see team travel auths"
The `GET /api/travel-auth` endpoint requires `?view=team` parameter for supervisors to see department auths. Without it, supervisors only see their own auths. The admin.html Travel Auth tab passes this param.

### "Trip submit fails / 0 expenses"
`tdpSubmitTrip()` must loop through all days creating DB records for enabled tiles before calling the submit endpoint. If submitting via API without the Day Planner, you must create expense records first.

### "Duplicate per diem error"
Per diem duplicate checks exclude `status='estimate'` and are scoped to same `trip_id`. Verify estimate expenses have correct status and actual expenses have correct `trip_id`.

### "Rejection dialog doesn't appear"
All rejection dialogs use an inline HTML modal (`#reject-modal`). If it doesn't show, check that the modal element exists in the DOM and `showRejectModal()` is defined. The modal is at the bottom of admin.html before `</body>`.

### "Data disappeared after deploy"
SQLite is ephemeral on Render. Every deploy resets the database. Demo accounts are re-seeded but user data is gone. This is expected — migrate to PostgreSQL for persistence.
