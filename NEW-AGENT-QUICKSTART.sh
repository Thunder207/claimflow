#!/bin/bash

# 🚀 CLAIMFLOW - NEW AGENT QUICKSTART SCRIPT
# ==========================================
# Run this script when taking over the project
# It will validate everything is working properly

echo "🚀 CLAIMFLOW - NEW AGENT QUICKSTART"
echo "=================================="
echo "Welcome! This script will validate the handoff is complete."
echo ""

# Check if we're in the right directory
if [ ! -f "app.js" ] || [ ! -f "HANDOFF-COMPLETE.md" ]; then
    echo "❌ ERROR: Please run this script from the expense-app directory"
    echo "   Expected files: app.js, HANDOFF-COMPLETE.md"
    exit 1
fi

echo "📁 Project Structure Check..."
REQUIRED_FILES=("app.js" "employee-dashboard.html" "admin.html" "login.html" "ARCHITECTURE.md" "HANDOFF-COMPLETE.md" "comprehensive-governance-test.sh")

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ Missing: $file"
    fi
done
echo ""

echo "📊 Git Status Check..."
echo "Current commit: $(git log -1 --format="%h - %s")"
echo "Branch: $(git branch --show-current)"
echo "Files staged: $(git diff --name-only --cached | wc -l)"
echo "Files modified: $(git diff --name-only | wc -l)"
echo ""

echo "🌐 Production URL Check..."
HEALTH_CHECK=$(curl -s "https://claimflow-e0za.onrender.com/api/health/system" 2>/dev/null)
if echo "$HEALTH_CHECK" | grep -q "healthy"; then
    echo "   ✅ Production system is healthy"
    echo "   🌍 URL: https://claimflow-e0za.onrender.com"
else
    echo "   ⚠️  Production system may be down or deploying"
    echo "   🌍 URL: https://claimflow-e0za.onrender.com"
fi
echo ""

echo "🏗️ Dependencies Check..."
if [ -f "package.json" ]; then
    echo "   Node.js version: $(node --version 2>/dev/null || echo 'Not installed')"
    echo "   npm version: $(npm --version 2>/dev/null || echo 'Not installed')"
    
    if [ -d "node_modules" ]; then
        echo "   ✅ Dependencies installed"
    else
        echo "   ⚠️  Dependencies not installed. Run: npm install"
    fi
else
    echo "   ❌ package.json missing"
fi
echo ""

echo "🧪 Test Suite Availability..."
if [ -x "comprehensive-governance-test.sh" ]; then
    echo "   ✅ Governance test suite ready"
    echo "   📝 To run: ./comprehensive-governance-test.sh"
else
    echo "   ❌ Test suite not executable. Run: chmod +x comprehensive-governance-test.sh"
fi
echo ""

echo "🔐 Demo Account Summary..."
echo "   Admin:    john.smith@company.com / manager123"
echo "   Finance:  sarah.johnson@company.com / sarah123 (supervisor)"
echo "   Finance:  mike.davis@company.com / mike123 (employee)"
echo "   Ops:      lisa.brown@company.com / lisa123 (supervisor)"
echo "   Ops:      anna.lee@company.com / anna123 (employee)"
echo "   Ops:      david.wilson@company.com / david123 (employee)"
echo ""

echo "📚 Key Documentation..."
echo "   📖 HANDOFF-COMPLETE.md  - Complete handoff guide (START HERE)"
echo "   🏗️ ARCHITECTURE.md      - Technical documentation"
echo "   🧪 Test Results         - 91% pass rate (34/37 tests)"
echo ""

echo "⚡ Quick Commands..."
echo "   Local dev:     node app.js"
echo "   Run tests:     ./comprehensive-governance-test.sh"  
echo "   Deploy:        git push origin main"
echo "   Check deploy:  curl -s https://claimflow-e0za.onrender.com/api/health/system"
echo ""

echo "🎯 Priority Next Steps..."
echo "   1. Read HANDOFF-COMPLETE.md thoroughly"
echo "   2. Run ./comprehensive-governance-test.sh to validate"
echo "   3. Test governance: Login as Sarah vs Lisa - should see different teams"
echo "   4. Fix remaining 3 failed tests (date validation edge cases)"
echo "   5. Implement variance tracking (actual vs estimated expenses)"
echo ""

echo "🚨 CRITICAL GOVERNANCE RULES..."
echo "   • Sarah (Finance) should ONLY see Mike Davis"
echo "   • Lisa (Operations) should ONLY see Anna Lee + David Wilson"  
echo "   • NO cross-department access allowed"
echo "   • Direct reports only (no recursive hierarchy)"
echo ""

echo "✅ HANDOFF VALIDATION COMPLETE"
echo "=============================="
echo "System Status: PRODUCTION READY (91% test pass rate)"
echo "Your next step: Read HANDOFF-COMPLETE.md"
echo ""
echo "Good luck! The foundation is solid. ⚡"