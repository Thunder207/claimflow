const BASE = 'http://localhost:3000';
const results = [];

function log(step, pass, detail = '') {
  const status = pass ? 'PASS' : 'FAIL';
  console.log(`[${status}] ${step}${detail ? ' — ' + detail : ''}`);
  results.push({ step, pass, detail });
}

async function run() {
  let token;

  // 1. Login as supervisor
  try {
    const r = await fetch(`${BASE}/api/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'sarah.johnson@company.com', password: 'sarah123' })
    });
    const d = await r.json();
    token = d.sessionId;
    log('Supervisor login', d.success && !!token, `role=${d.user?.role}`);
  } catch (e) { log('Supervisor login', false, e.message); }

  const auth = { 'Authorization': `Bearer ${token}` };

  // 2. List pending expenses (supervisor sees team expenses)
  let pendingExpenses = [];
  try {
    const r = await fetch(`${BASE}/api/expenses`, { headers: auth });
    const d = await r.json();
    pendingExpenses = Array.isArray(d) ? d.filter(e => e.status === 'pending') : [];
    log('List pending expenses', pendingExpenses.length > 0, `found ${pendingExpenses.length} pending`);
  } catch (e) { log('List pending expenses', false, e.message); }

  // 3. Find expenses from David Wilson's trip
  const davidExpenses = pendingExpenses.filter(e =>
    (e.employee_name || e.employee_name_from_db || '').includes('David Wilson')
  );
  log('Find David Wilson expenses', davidExpenses.length > 0, `found ${davidExpenses.length}`);

  // 4. Review expenses
  if (davidExpenses.length > 0) {
    const types = davidExpenses.map(e => `${e.expense_type}($${e.amount})`).join(', ');
    const total = davidExpenses.reduce((s, e) => s + parseFloat(e.amount), 0).toFixed(2);
    log('Review expenses', true, `${types} — total $${total}`);
  } else {
    log('Review expenses', false, 'No expenses to review');
  }

  // 5. Approve each expense
  let approvedCount = 0;
  for (const exp of davidExpenses) {
    try {
      const r = await fetch(`${BASE}/api/expenses/${exp.id}/approve`, {
        method: 'POST',
        headers: { ...auth, 'Content-Type': 'application/json' },
        body: JSON.stringify({ approver: 'Sarah Johnson', comment: 'Approved — within policy' })
      });
      const d = await r.json();
      if (d.success) approvedCount++;
    } catch (e) { /* count stays */ }
  }
  log('Approve all expenses', approvedCount === davidExpenses.length && approvedCount > 0,
    `${approvedCount}/${davidExpenses.length} approved`);

  // 6. Verify status changed
  try {
    const r = await fetch(`${BASE}/api/expenses`, { headers: auth });
    const d = await r.json();
    const davidNow = Array.isArray(d) ? d.filter(e =>
      (e.employee_name || e.employee_name_from_db || '').includes('David Wilson') &&
      davidExpenses.some(de => de.id === e.id)
    ) : [];
    const allApproved = davidNow.every(e => e.status === 'approved');
    log('Expenses status = approved', allApproved && davidNow.length > 0,
      davidNow.map(e => `${e.expense_type}:${e.status}`).join(', '));
  } catch (e) { log('Expenses status = approved', false, e.message); }

  const passed = results.filter(r => r.pass).length;
  console.log(`\n=== Supervisor Agent: ${passed}/${results.length} passed ===`);
  return { results };
}

run().catch(e => { console.error(e); process.exit(1); });
