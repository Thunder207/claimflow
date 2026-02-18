const BASE = 'http://localhost:3000';
const results = [];

function log(step, pass, detail = '') {
  const status = pass ? 'PASS' : 'FAIL';
  console.log(`[${status}] ${step}${detail ? ' — ' + detail : ''}`);
  results.push({ step, pass, detail });
}

async function run() {
  let token, tripId;
  // Use a unique future date to avoid per diem duplicate conflicts from prior test runs
  const d = new Date(); d.setDate(d.getDate() + Math.floor(Math.random() * 300) + 30);
  const today = d.toISOString().slice(0, 10);

  // 1. Login
  try {
    const r = await fetch(`${BASE}/api/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'david.wilson@company.com', password: 'david123' })
    });
    const d = await r.json();
    token = d.sessionId;
    log('Login', d.success && !!token, `token=${token?.slice(0,8)}…`);
  } catch (e) { log('Login', false, e.message); }

  const auth = { 'Authorization': `Bearer ${token}` };

  // 2. Create trip
  try {
    const r = await fetch(`${BASE}/api/trips`, {
      method: 'POST',
      headers: { ...auth, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        trip_name: 'Ottawa Training Conference',
        destination: 'Ottawa, ON',
        purpose: 'Annual training conference',
        start_date: today,
        end_date: today
      })
    });
    const d = await r.json();
    tripId = d.id;
    log('Create trip', d.success && !!tripId, `trip_id=${tripId}`);
  } catch (e) { log('Create trip', false, e.message); }

  // 3. Add expenses via FormData
  const expenses = [
    { expense_type: 'breakfast', amount: '23.45', description: 'Breakfast per diem' },
    { expense_type: 'lunch', amount: '29.75', description: 'Lunch per diem' },
    { expense_type: 'dinner', amount: '47.05', description: 'Dinner per diem' },
    { expense_type: 'incidentals', amount: '32.08', description: 'Incidentals per diem' },
    { expense_type: 'vehicle_km', amount: '68.00', description: '100 km driven' },
  ];

  for (const exp of expenses) {
    try {
      const fd = new FormData();
      fd.append('expense_type', exp.expense_type);
      fd.append('date', today);
      fd.append('amount', exp.amount);
      fd.append('description', exp.description);
      fd.append('trip_id', String(tripId));
      fd.append('location', 'Ottawa, ON');
      const r = await fetch(`${BASE}/api/expenses`, { method: 'POST', headers: auth, body: fd });
      const d = await r.json();
      log(`Add ${exp.expense_type}`, d.success, `id=${d.id}`);
    } catch (e) { log(`Add ${exp.expense_type}`, false, e.message); }
  }

  // 4. Duplicate prevention — second breakfast same day
  try {
    const fd = new FormData();
    fd.append('expense_type', 'breakfast');
    fd.append('date', today);
    fd.append('amount', '23.45');
    fd.append('description', 'Duplicate breakfast');
    fd.append('trip_id', String(tripId));
    const r = await fetch(`${BASE}/api/expenses`, { method: 'POST', headers: auth, body: fd });
    const d = await r.json();
    log('Duplicate breakfast blocked', !d.success && r.status === 400, d.error || '');
  } catch (e) { log('Duplicate breakfast blocked', false, e.message); }

  // 5. Submit trip
  try {
    const r = await fetch(`${BASE}/api/trips/${tripId}/submit`, { method: 'POST', headers: auth });
    const d = await r.json();
    log('Submit trip', d.success);
  } catch (e) { log('Submit trip', false, e.message); }

  // 6. Verify status
  try {
    const r = await fetch(`${BASE}/api/trips/${tripId}`, { headers: auth });
    const d = await r.json();
    log('Trip status = submitted', d.status === 'submitted', `status=${d.status}`);
  } catch (e) { log('Trip status = submitted', false, e.message); }

  // Summary
  const passed = results.filter(r => r.pass).length;
  console.log(`\n=== Employee Agent: ${passed}/${results.length} passed ===`);
  return { results, tripId };
}

run().then(r => {
  process.stdout.write('\n__TRIP_ID__=' + r.tripId + '\n');
}).catch(e => { console.error(e); process.exit(1); });
