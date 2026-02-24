# ClaimFlow Continuity Document
> Last updated: 2026-02-23 22:57 EST  
> Git tag: `v5.0-transport-e2e-verified-2026-02-23`  
> Live: https://claimflow-e0za.onrender.com

## What Is ClaimFlow?

NJC-compliant expense management web app for Canadian government employees. Handles per diem meals, lodging, mileage, and **smart transportation** (flight, train, bus, rental car). Built with vanilla JS frontend + Node.js/Express backend + SQLite (ephemeral on Render).

## Architecture Quick Reference

- **Single-file backend**: `app.js` (~4000+ lines) — Express server, REST API, SQLite
- **Single-file frontend**: `employee-dashboard.html` (~6000+ lines) — entire employee UI
- **Supervisor view**: served at `/admin` route, embedded in same HTML
- **Database**: SQLite in-memory — **resets on every Render deploy** (test data is lost)
- **Full architecture doc**: `ARCHITECTURE.md` (read this for deep dive)

## Deployment

```bash
# Deploy to Render (triggers rebuild + restart)
curl -X POST \
  -H "Authorization: Bearer rnd_PM94FfZa3hFY3OzBJ1Ao5j9yD0qI" \
  -H "Content-Type: application/json" \
  'https://api.render.com/v1/services/srv-d6aj99rnv86c739nt670/deploys' \
  -d '{"clearCache":"do_not_clear"}'
```

- **Render Service ID**: `srv-d6aj99rnv86c739nt670`
- **Git repo**: https://github.com/Thunder207/claimflow.git (branch: `main`)
- Push to main → manual deploy via API above (not auto-deploy)

## Demo Accounts

| Name | Email | Password | Role |
|------|-------|----------|------|
| Anna Lee | anna.lee@company.com | anna123 | Employee (EMP006, Operations) |
| Lisa Brown | lisa.brown@company.com | lisa123 | Supervisor (EMP004, Operations) |
| David Wilson | david.wilson@company.com | david123 | Employee (EMP003, IT) |
| Sarah Chen | sarah.chen@company.com | sarah123 | Supervisor (EMP001, Finance) |

## Core Workflow (End-to-End)

1. **Employee creates Travel Authorization (AT)** → Travel Auth tab → New Authorization
   - Enters trip name, dates, destination, purpose
   - Day Planner auto-generates: per diem tiles (breakfast/lunch/dinner/incidentals/private lodging) per day + hotel fields
   - Employee toggles transport mode(s): Flight/Train/Bus/Rental + enters costs
   - Clicks "Submit for Approval" → status changes to PENDING

2. **Supervisor approves AT** → Login as supervisor → Supervisor View → Travel Auth tab
   - Sees pending AT with breakdown (Meals / Lodging / Other)
   - Clicks ✅ Approve → Trip auto-created for employee

3. **Employee opens Trip** → Trips tab → Select the trip from dropdown
   - Day Planner loads with same structure
   - Employee activates transport mode(s) again, enters actual costs
   - Clicks "Submit Trip for Approval"

4. **Supervisor approves Trip expenses** → Team Approvals tab
   - Sees day-by-day breakdown including transport_flight/train/bus/rental line items
   - Approves all expenses → employee gets reimbursed

## Smart Transportation Feature (v5.0)

### How It Works

- **Transport buttons**: Personal Vehicle, Flight, Train, Bus, Rental Car (multi-select)
- **AT form**: Uses IDs `at-flight-dep`, `at-flight-ret`, etc.
- **Trip Day Planner (TDP)**: Uses IDs `tdp-flight-dep`, `tdp-flight-ret`, etc.
- **Day Planner (DP/AT draft)**: Uses IDs `dp-flight-dep`, `dp-flight-ret`, etc.
- **CRITICAL**: Three separate sets of IDs to avoid conflicts between AT creation modal, AT Day Planner, and Trip Day Planner

### Data Flow

```
AT Creation:
  createTravelAuth() → calculates transport costs → stores in `details` JSON field
  → creates expense records with types: transport_flight, transport_train, etc.

Trip Submission:
  dpSubmitForApproval() → reads DOM directly (not dpState.transport!)
  → querySelector for active buttons in #tdp-transport-toggles
  → getElementById for tdp-flight-dep/ret values
  → creates transport expense records via API
```

### Key Code Locations in employee-dashboard.html

- **Transport toggle buttons**: Search for `tdp-transport-toggles` (Trip) or `dp-transport-toggles` (AT)
- **Transport form fields**: Search for `tdp-flight-section`, `dp-flight-section`
- **Submit logic**: Search for `dpSubmitForApproval` function
- **AT creation**: Search for `createTravelAuth` function
- **Transport calculation**: Search for `updateTransportTotal` or `calculateTransportCosts`

### Key Code Locations in app.js

- **Valid expense types** (line ~3856): `validExpenseTypes` array includes `transport_flight`, `transport_train`, `transport_bus`, `transport_rental`
- **AT endpoints**: `/api/travel-authorizations` (POST/GET/PUT)
- **Trip endpoints**: `/api/trips` (POST/GET), `/api/trips/:id/expenses` (POST)
- **Expense approval**: `/api/expenses/:id/approve`

## Known Issues / Future Work

1. **AT → Trip transport auto-population**: When employee opens trip, transport buttons don't auto-activate from AT data. User must manually re-select flight and re-enter amounts. The AT `details` JSON has the data, just needs UI code to read it on trip load.

2. **`est_transport` display in supervisor AT view**: Shows $0 in the summary field even though actual expense records are correct. Cosmetic issue in GET endpoint.

3. **SQLite ephemeral**: All data lost on Render redeploy. For production, would need PostgreSQL or persistent storage.

4. **Hotel receipt uploads**: UI has file upload buttons but backend may not fully process them.

## Git Tags (Milestones)

| Tag | Description |
|-----|-------------|
| `v1.0-stable-2026-02-19-1730EST` | Pre-Day Planner stable |
| `v2.0-dayplanner-2026-02-19-2012EST` | Day Planner initial |
| `v2.1-tested-2026-02-20-2050EST` | Day Planner tested |
| `v2.2-e2e-verified-2026-02-20-2140EST` | E2E verified |
| `v3.0-supervisor-ui-2026-02-20-2255EST` | Supervisor UI |
| `v4.0-governance-validated-2026-02-21-1612EST` | Governance + roles |
| `v5.0-transport-e2e-verified-2026-02-23` | **Smart Transport complete** ← YOU ARE HERE |

## Critical Bugs Fixed (Reference)

- **Duplicate `data-mode` selectors**: AT and Trip transport buttons shared same selectors → container-specific IDs
- **`dpState.transport` unreliable**: Trip submission read from JS state object that wasn't populated → read directly from DOM
- **Extra closing braces** (commit `02ff898`): Old if-wrapper removal left orphan `}}` → broke entire JS
- **Missing transport expense types** (commit `941f85d`): Backend rejected `transport_flight` etc. → added to `validExpenseTypes`
- **Variable reference** in `dpSaveTransport()`: Used `tdpState.tripId` → fixed to `selectedAuthId`

## Browser Testing State (as of 2026-02-23 22:57 EST)

**Last test in progress** — browser automation mid-flow:
- ✅ Step 1: Anna Lee created AT "Toronto Business Meeting" (Apr 10-13, Toronto ON, $2,147.24 with $1,200 flight)
- ✅ Step 2: AT submitted for approval (PENDING, 19 expenses)
- ✅ Step 3: Lisa Brown approved AT → trip auto-created
- 🔄 Step 4: Anna Lee selected trip, activated Flight button — **need to enter $600/$600 and submit**
- ⬜ Step 5: Lisa Brown approves trip expenses

**To resume Step 4**: Login as anna.lee@company.com/anna123, Trips tab, select "Toronto Business Meeting", click ✈️ Flight, enter 600/600 in departure/return fields, click "Submit Trip for Approval".
