# ClaimFlow — Complete Project Handoff

> Last updated: 2026-02-18 18:30 EST
> Author: Thunder ⚡ (AI agent) for Tony

---

## 🏗️ Architecture Overview

ClaimFlow is a **Government of Canada NJC-compliant expense tracker** built as a single Express.js app serving static HTML files with a SQLite database.

```
expense-app/
├── app.js                    # Main server — ALL API routes, DB init, auth, middleware
├── njc-rates-service.js      # NJC rate lookups, historical rate management
├── concur-enhancements.js    # SAP Concur-style workflow additions
├── audit-system.js           # Audit trail logging
├── translations.js           # EN/FR bilingual translations
├── package.json              # Dependencies
├── render.yaml               # Render.com deploy blueprint
├── expenses.db               # SQLite database (auto-created on first run)
├── login.html                # Login page
├── employee-dashboard.html   # Employee view — submit expenses, manage trips
├── admin.html                # Admin + Supervisor dashboard
├── uploads/                  # Receipt photos (auto-created)
└── memory files (*.md)       # Documentation, audit reports
```

### No framework, no build step
- Frontend: Vanilla HTML/CSS/JS (no React, no bundler)
- Backend: Express.js + SQLite3
- Auth: Session tokens stored in memory (no Redis/JWT)
- Deployment: `node app.js` — that's it

---

## 🔐 Credentials

### App Users
| Role | Email | Password | Notes |
|------|-------|----------|-------|
| **Admin** | john.smith@company.com | [see TOOLS.md] | System-only role, no approvals |
| **Supervisor** | sarah.johnson@company.com | sarah123 | Top-level, approves team expenses |
| **Supervisor** | lisa.brown@company.com | lisa123 | Operations supervisor |
| **Supervisor** | rachel.chen@company.com | rachel123 | Engineering supervisor |
| **Supervisor** | marcus.thompson@company.com | marcus123 | Marketing supervisor |
| **Supervisor** | priya.patel@company.com | priya123 | Finance supervisor |
| **Employee** | mike.davis@company.com | mike123 | Finance |
| **Employee** | david.wilson@company.com | david123 | Operations |
| **Employee** | anna.lee@company.com | anna123 | Operations |
| **Employee** | (10 more) | firstname123 | IDs 186-198 |

### External Services
| Service | Key/URL | Notes |
|---------|---------|-------|
| **Render.com** | API Key: `[STORED IN TOOLS.md - NOT IN REPO]` | Deploy trigger |
| **Render Service** | ID: `srv-d6aj99rnv86c739nt670` | ClaimFlow service |
| **Render URL** | https://claimflow-e0za.onrender.com | Live production |
| **GitHub** | https://github.com/Thunder207/claimflow | Public repo |
| **GitHub Token** | `[STORED IN TOOLS.md - NOT IN REPO]` | Push access |

### Deploy Command
```bash
# Trigger Render deploy via API
curl -X POST \
  -H "Authorization: Bearer [STORED IN TOOLS.md - NOT IN REPO]" \
  -H "Content-Type: application/json" \
  'https://api.render.com/v1/services/srv-d6aj99rnv86c739nt670/deploys' \
  -d '{"clearCache":"do_not_clear"}'
```

---

## 🚀 Running Locally

```bash
cd /Users/tony/.openclaw/workspace/expense-app
npm install
node app.js
# Server starts on http://localhost:3000
```

**Environment:** Node.js v22+, no env vars required (PORT defaults to 3000, Render sets PORT automatically).

---

## 🗄️ Database Schema

SQLite file: `expenses.db` (auto-created with tables + seed data on first run)

### Tables
```sql
employees (id, name, employee_number, email, password_hash, position, department, supervisor_id, role, gl_account_id)
trips (id, employee_id, trip_name, destination, purpose, start_date, end_date, status)
expenses (id, employee_name, employee_id, trip_id, expense_type, meal_name, date, location, amount, vendor, description, receipt_photo, status, rejection_reason, approved_by, approved_at)
njc_rates (id, rate_type, amount, effective_date, end_date, province, notes, created_by, created_at, updated_at)
gl_accounts (id, expense_type, gl_code, gl_name, is_active)
department_cost_centers (id, department, cost_center_code, cost_center_name, is_active)
expense_audit_log (id, expense_id, action, performed_by, details, created_at)
login_audit_log (id, email, success, ip_address, user_agent, created_at)
notifications (id, employee_id, message, type, read, created_at)
```

### Key Relationships
- `employees.supervisor_id` → `employees.id` (self-referencing hierarchy)
- `expenses.employee_id` → `employees.id`
- `expenses.trip_id` → `trips.id`
- `employees.gl_account_id` → `gl_accounts.id`

---

## 🔒 Governance Rules (Enforced at API Level)

1. **Admin (John Smith)** = System only
   - Can manage employees, GL accounts, NJC rates, view all expenses
   - CANNOT approve/reject expenses
   - CANNOT supervise employees (no one reports to admin)
   - CANNOT submit expenses
   
2. **Supervisors** = Dual role
   - Default view: Employee dashboard (submit their own expenses)
   - Toggle to Supervisor view: Approve/reject direct reports' expenses
   - CANNOT approve their own expenses
   - CANNOT switch to admin role
   - CANNOT see other supervisors' teams

3. **Employees** = Submit only
   - Create trips, add expenses, submit for approval
   - Can only see their own data
   - Per diem rates auto-applied based on NJC

4. **Circular supervision blocked** — recursive CTE query prevents A→B→A chains
5. **Admin as supervisor blocked** — API rejects assigning admin as anyone's supervisor

---

## 💰 NJC Rate System

### Current Rates (2024-2025 Fiscal Year)
| Type | Rate | Per |
|------|------|-----|
| Breakfast | $23.45 | day |
| Lunch | $29.75 | day |
| Dinner | $47.05 | day |
| Incidentals | $32.08 | day |
| Vehicle | $0.68 | km |

### How It Works
- Rates stored in `njc_rates` table with `effective_date` and `end_date`
- When employee submits expense for date X, system looks up rate active on date X
- Historical rates are **read-only** for audit compliance
- Adding a new rate auto-closes the previous one (sets end_date)
- Province support (default: ALL, can set per-province rates)

### Key Code: `njc-rates-service.js`
- `getCurrentRates(province)` — rates active today
- `getRatesForDate(date, province)` — rates active on any date
- `getAllRates(province)` — full history for admin view
- `addNewRate(...)` — adds new rate, closes previous in transaction

---

## 🔄 API Quick Reference

### Auth
```
POST /api/auth/login      {email, password}  → {sessionId, user}
POST /api/auth/logout     Bearer token
GET  /api/auth/session     Bearer token → current user info
```

### Trips
```
GET    /api/trips           → user's trips
POST   /api/trips           {trip_name, destination, purpose, start_date, end_date}
POST   /api/trips/:id/submit  → submit trip for approval
```

### Expenses
```
GET    /api/expenses        → user's expenses
POST   /api/expenses        FormData (expense_type, date, location, amount, vendor, trip_id, receipt)
PUT    /api/expenses/:id    → edit draft expense
POST   /api/expenses/:id/approve  → supervisor approves
POST   /api/expenses/:id/reject   {reason} → supervisor rejects
```

### NJC Rates
```
GET    /api/njc-rates/current       → current active rates
GET    /api/njc-rates/all           → all rates (admin)
GET    /api/njc-rates/for-date?date=YYYY-MM-DD  → rates for specific date
GET    /api/njc-rates/:expenseType  → specific rate
POST   /api/njc-rates               {rate_type, amount, effective_date, province, notes}
```

### Sage 300
```
GET    /api/sage/gl-accounts        → GL account list
POST   /api/sage/gl-accounts        → create GL account
GET    /api/sage/export-count       → count of exportable expenses
GET    /api/sage/export             → CSV download
```

### Admin
```
GET    /api/employees               → all employees (admin/supervisor)
POST   /api/employees               → create employee
PUT    /api/employees/:id           → update employee
```

---

## 🚨 Known Issues & Quirks

1. **SQLite on Render** — DB resets on every deploy (free tier has ephemeral storage). Data is re-seeded from app.js `insertDefaultData()`. For production, need persistent disk or switch to PostgreSQL.

2. **Session tokens in memory** — server restart logs everyone out. No Redis/persistent sessions.

3. **Employee IDs jump** — IDs 1-6 are original employees, 186-198 are new additions (gap due to prior deletions).

4. **FormData required** — expense submission uses multer middleware, so must use `multipart/form-data` not JSON.

5. **Express route ordering** — wildcard routes like `/api/njc-rates/:expenseType` MUST come after specific routes like `/api/njc-rates/current`. This was a bug we fixed.

6. **Province 'ALL'** — NJC rates seeded with province='ALL'. All queries must include `OR province = 'ALL'` to match.

---

## 📦 Git Tags (Rollback Points)

```bash
git tag -l                    # List all tags
git checkout v1.0-stable-2026-02-18T1745  # Rollback to stable version
git checkout main             # Back to latest
```

| Tag | Description |
|-----|-------------|
| `pre-bilingual` | Before EN/FR translation system |
| `v1.0-stable-2026-02-18T1650EST` | Before audit |
| `v1.0-stable-2026-02-18T1745` | Post-audit, all fixes applied |

---

## 🔧 Common Tasks

### Add a new employee
1. Login as admin (john.smith@company.com)
2. Employee Directory tab → Add Employee
3. Assign supervisor, GL account, department

### Change NJC rates
1. Login as admin → NJC Rates tab
2. Select rate type, enter new amount and effective date
3. Previous rate auto-closes

### Export to Sage 300
1. Login as admin → Sage 300 tab
2. Configure GL account mappings if needed
3. Click Export → confirmation dialog → CSV download

### Deploy changes
```bash
cd /Users/tony/.openclaw/workspace/expense-app
git add -A && git commit -m "description" && git push origin main
# Then trigger Render deploy:
curl -X POST -H "Authorization: Bearer [STORED IN TOOLS.md - NOT IN REPO]" \
  -H "Content-Type: application/json" \
  'https://api.render.com/v1/services/srv-d6aj99rnv86c739nt670/deploys' \
  -d '{"clearCache":"do_not_clear"}'
```

### Rollback
```bash
git checkout v1.0-stable-2026-02-18T1745
git push origin main --force
# Trigger deploy (same curl command above)
```

---

## 📊 Project Status

### Completed
- ✅ Full trip-based expense workflow
- ✅ NJC rate compliance with historical tracking
- ✅ Role-based access (admin/supervisor/employee)
- ✅ Sage 300 GL mapping + CSV export
- ✅ Bilingual EN/FR
- ✅ Mobile responsive
- ✅ Audit trail
- ✅ Future-date flagging for supervisor review
- ✅ Per diem duplicate prevention
- ✅ Draft persistence (localStorage)
- ✅ OCR receipt scanning (Tesseract.js) — in progress

### Future Roadmap
- [ ] Multi-level approval chains
- [ ] Reporting dashboard with charts
- [ ] Submit on behalf of (delegation)
- [ ] Per diem rates by city (not just province)
- [ ] PostgreSQL for persistent production data
- [ ] SSO/SAML integration
- [ ] Credit card auto-import
