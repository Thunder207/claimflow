const { execSync } = require('child_process');
const path = require('path');

const dir = __dirname;

console.log('╔══════════════════════════════════════╗');
console.log('║   Expense Tracker E2E Test Runner    ║');
console.log('╚══════════════════════════════════════╝\n');

// Check server
try {
  execSync('curl -sf http://localhost:3000/health', { stdio: 'pipe' });
  console.log('✅ Server is running\n');
} catch {
  console.error('❌ Server not running at http://localhost:3000');
  process.exit(1);
}

console.log('━'.repeat(50));
console.log('PHASE 1: Employee Agent');
console.log('━'.repeat(50));
try {
  const out1 = execSync(`node ${path.join(dir, 'test-employee-agent.js')}`, { encoding: 'utf8', cwd: dir });
  console.log(out1);
} catch (e) {
  console.log(e.stdout || '');
  console.error('Employee agent failed:', e.message);
}

console.log('━'.repeat(50));
console.log('PHASE 2: Supervisor Agent');
console.log('━'.repeat(50));
try {
  const out2 = execSync(`node ${path.join(dir, 'test-supervisor-agent.js')}`, { encoding: 'utf8', cwd: dir });
  console.log(out2);
} catch (e) {
  console.log(e.stdout || '');
  console.error('Supervisor agent failed:', e.message);
}

console.log('━'.repeat(50));
console.log('E2E COMPLETE');
console.log('━'.repeat(50));
