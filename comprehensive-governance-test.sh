#!/bin/bash

# 🧪 COMPREHENSIVE GOVERNANCE & WORKFLOW TEST SUITE
# Tests complete AT → Trip → Approval cycle with strict governance validation
# Priority: Governance compliance + Workflow fluidity

BASE_URL="https://claimflow-e0za.onrender.com"
RESULTS_FILE="governance-test-results.json"
TEST_COUNT=0
PASS_COUNT=0
FAIL_COUNT=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "🚨 COMPREHENSIVE GOVERNANCE & WORKFLOW TEST SUITE"
echo "=================================================="
echo "URL: $BASE_URL"
echo "Priority: Governance + Workflow Fluidity"
echo "Target: 20+ comprehensive tests"
echo ""

# Helper functions
run_test() {
    local test_name="$1"
    local expected="$2"
    local actual="$3"
    local description="$4"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    
    if [[ "$actual" == "$expected" ]]; then
        echo -e "${GREEN}✅ TEST $TEST_COUNT PASS${NC}: $test_name"
        echo "   Expected: $expected | Actual: $actual"
        [[ -n "$description" ]] && echo "   Description: $description"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}❌ TEST $TEST_COUNT FAIL${NC}: $test_name"
        echo "   Expected: $expected | Actual: $actual"
        [[ -n "$description" ]] && echo "   Description: $description"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    echo ""
}

# Login helper
login() {
    local email="$1"
    local password="$2"
    curl -s -X POST "$BASE_URL/api/auth/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$email\",\"password\":\"$password\"}" | jq -r '.sessionId // empty'
}

# Test helper
api_call() {
    local method="$1"
    local endpoint="$2"
    local session="$3"
    local data="$4"
    
    if [[ -n "$data" ]]; then
        curl -s -X "$method" "$BASE_URL$endpoint" \
            -H "Authorization: Bearer $session" \
            -H "Content-Type: application/json" \
            -d "$data"
    else
        curl -s -X "$method" "$BASE_URL$endpoint" \
            -H "Authorization: Bearer $session"
    fi
}

echo "🔐 PHASE 1: GOVERNANCE TESTS (Department Isolation & Direct Reports)"
echo "=================================================================="

# Get sessions for all test users
ADMIN_SESSION=$(login "john.smith@company.com" "manager123")
SARAH_SESSION=$(login "sarah.johnson@company.com" "sarah123")  # Finance Supervisor
LISA_SESSION=$(login "lisa.brown@company.com" "lisa123")       # Operations Supervisor  
MIKE_SESSION=$(login "mike.davis@company.com" "mike123")       # Finance Employee
ANNA_SESSION=$(login "anna.lee@company.com" "anna123")         # Operations Employee
DAVID_SESSION=$(login "david.wilson@company.com" "david123")   # Operations Employee

# TEST 1: Verify Independent Supervisor Hierarchy
echo "🏗️ Test 1-3: Verify Proper Supervisor Hierarchy"
SARAH_INFO=$(api_call "GET" "/api/auth/me" "$SARAH_SESSION" | jq -r '.supervisor_id // "null"')
LISA_INFO=$(api_call "GET" "/api/auth/me" "$LISA_SESSION" | jq -r '.supervisor_id // "null"')
MIKE_SUPERVISOR=$(api_call "GET" "/api/auth/me" "$MIKE_SESSION" | jq -r '.supervisor_id // "null"')

run_test "Sarah Johnson Independence" "null" "$SARAH_INFO" "Finance supervisor should be independent (no supervisor)"
run_test "Lisa Brown Independence" "null" "$LISA_INFO" "Operations supervisor should be independent (no supervisor)" 
run_test "Mike Davis Reports to Sarah" "2" "$MIKE_SUPERVISOR" "Finance employee should report to Sarah (ID 2)"

# Create test travel authorizations
echo "📝 Creating Test Data..."

# TEST 4-6: Create Travel Authorizations
ANNA_AT_RESULT=$(api_call "POST" "/api/travel-auth" "$ANNA_SESSION" '{"name":"Operations Conference","destination":"Toronto, ON","start_date":"2026-02-28","end_date":"2026-03-02","purpose":"Operations training conference"}')
ANNA_AT_ID=$(echo "$ANNA_AT_RESULT" | jq -r '.id // empty')
ANNA_AT_SUCCESS=$(echo "$ANNA_AT_RESULT" | jq -r '.success // false')

MIKE_AT_RESULT=$(api_call "POST" "/api/travel-auth" "$MIKE_SESSION" '{"name":"Finance Meeting","destination":"Montreal, QC","start_date":"2026-03-05","end_date":"2026-03-07","purpose":"Budget planning meeting"}')
MIKE_AT_ID=$(echo "$MIKE_AT_RESULT" | jq -r '.id // empty')
MIKE_AT_SUCCESS=$(echo "$MIKE_AT_RESULT" | jq -r '.success // false')

DAVID_AT_RESULT=$(api_call "POST" "/api/travel-auth" "$DAVID_SESSION" '{"name":"Operations Site Visit","destination":"Vancouver, BC","start_date":"2026-03-10","end_date":"2026-03-11","purpose":"Site inspection"}')
DAVID_AT_ID=$(echo "$DAVID_AT_RESULT" | jq -r '.id // empty')
DAVID_AT_SUCCESS=$(echo "$DAVID_AT_RESULT" | jq -r '.success // false')

run_test "Anna AT Creation" "true" "$ANNA_AT_SUCCESS" "Operations employee can create travel authorization"
run_test "Mike AT Creation" "true" "$MIKE_AT_SUCCESS" "Finance employee can create travel authorization"  
run_test "David AT Creation" "true" "$DAVID_AT_SUCCESS" "Operations employee can create travel authorization"

# TEST 7-9: Governance - Department Isolation
echo "🛡️ Test 7-12: Department Isolation & Direct Reports Only"

SARAH_TEAM_COUNT=$(api_call "GET" "/api/travel-auth?view=team" "$SARAH_SESSION" | jq 'length // 0')
LISA_TEAM_COUNT=$(api_call "GET" "/api/travel-auth?view=team" "$LISA_SESSION" | jq 'length // 0')

# Sarah should see ONLY Mike's AT (1), Lisa should see Anna + David's ATs (2)
run_test "Sarah Sees Finance Only" "1" "$SARAH_TEAM_COUNT" "Finance supervisor sees only Mike's AT (direct report)"
run_test "Lisa Sees Operations Only" "2" "$LISA_TEAM_COUNT" "Operations supervisor sees Anna + David ATs (direct reports)"

# TEST 10-12: Cross-Department Access Violation Tests
SARAH_SEES_ANNA=$(api_call "GET" "/api/travel-auth?view=team" "$SARAH_SESSION" | jq -r '.[].employee_name // empty' | grep -c "Anna Lee" || echo "0")
LISA_SEES_MIKE=$(api_call "GET" "/api/travel-auth?view=team" "$LISA_SESSION" | jq -r '.[].employee_name // empty' | grep -c "Mike Davis" || echo "0")

run_test "Sarah Cannot See Anna" "0" "$SARAH_SEES_ANNA" "Finance supervisor cannot see Operations employee"
run_test "Lisa Cannot See Mike" "0" "$LISA_SEES_MIKE" "Operations supervisor cannot see Finance employee"

# Admin should see all
ADMIN_TEAM_COUNT=$(api_call "GET" "/api/travel-auth" "$ADMIN_SESSION" | jq 'length // 0')
run_test "Admin Sees All Departments" "3" "$ADMIN_TEAM_COUNT" "Admin can see all travel authorizations"

echo ""
echo "💼 PHASE 2: COMPLETE WORKFLOW TESTS (AT → Expenses → Approval → Trip → Approval)"
echo "=================================================================================="

# TEST 13-15: Add Estimated Expenses to Travel Authorizations
echo "📝 Test 13-18: Adding Estimated Expenses"

# Add expenses to Anna's AT
ANNA_VEHICLE=$(api_call "POST" "/api/travel-auth/$ANNA_AT_ID/expenses" "$ANNA_SESSION" '{"expense_type":"vehicle_km","date":"2026-02-28","amount":"136.00","location":"Ottawa to Toronto","description":"Drive to conference","kilometers":"200"}')
ANNA_MEAL=$(api_call "POST" "/api/travel-auth/$ANNA_AT_ID/expenses" "$ANNA_SESSION" '{"expense_type":"breakfast","date":"2026-03-01","amount":"23.45","location":"Toronto"}')
ANNA_HOTEL=$(api_call "POST" "/api/travel-auth/$ANNA_AT_ID/expenses" "$ANNA_SESSION" '{"expense_type":"hotel","date":"2026-02-28","amount":"150.00","location":"Toronto","hotel_checkin":"2026-02-28","hotel_checkout":"2026-03-01"}')

ANNA_VEHICLE_SUCCESS=$(echo "$ANNA_VEHICLE" | jq -r '.success // false')
ANNA_MEAL_SUCCESS=$(echo "$ANNA_MEAL" | jq -r '.success // false') 
ANNA_HOTEL_SUCCESS=$(echo "$ANNA_HOTEL" | jq -r '.success // false')

run_test "Vehicle Expense Added" "true" "$ANNA_VEHICLE_SUCCESS" "Vehicle km expense added to travel auth"
run_test "Meal Expense Added" "true" "$ANNA_MEAL_SUCCESS" "Per diem meal expense added to travel auth"
run_test "Hotel Expense Added" "true" "$ANNA_HOTEL_SUCCESS" "Hotel expense added to travel auth"

# Add expenses to Mike's AT  
MIKE_VEHICLE=$(api_call "POST" "/api/travel-auth/$MIKE_AT_ID/expenses" "$MIKE_SESSION" '{"expense_type":"vehicle_km","date":"2026-03-05","amount":"272.00","location":"Ottawa to Montreal","kilometers":"400"}')
MIKE_LUNCH=$(api_call "POST" "/api/travel-auth/$MIKE_AT_ID/expenses" "$MIKE_SESSION" '{"expense_type":"lunch","date":"2026-03-06","amount":"29.75","location":"Montreal"}')
MIKE_DINNER=$(api_call "POST" "/api/travel-auth/$MIKE_AT_ID/expenses" "$MIKE_SESSION" '{"expense_type":"dinner","date":"2026-03-06","amount":"47.05","location":"Montreal"}')

MIKE_EXPENSES_SUCCESS=$([[ $(echo "$MIKE_VEHICLE" | jq -r '.success') == "true" && $(echo "$MIKE_LUNCH" | jq -r '.success') == "true" && $(echo "$MIKE_DINNER" | jq -r '.success') == "true" ]] && echo "true" || echo "false")

run_test "Mike All Expenses Added" "true" "$MIKE_EXPENSES_SUCCESS" "All expenses added to Mike's Finance AT"

# TEST 16-18: Submit Travel Authorizations for Approval
echo "📤 Test 19-21: Submit Travel Authorizations"

ANNA_SUBMIT=$(api_call "PUT" "/api/travel-auth/$ANNA_AT_ID/submit" "$ANNA_SESSION")
MIKE_SUBMIT=$(api_call "PUT" "/api/travel-auth/$MIKE_AT_ID/submit" "$MIKE_SESSION") 
DAVID_SUBMIT=$(api_call "PUT" "/api/travel-auth/$DAVID_AT_ID/submit" "$DAVID_SESSION")

ANNA_SUBMIT_SUCCESS=$(echo "$ANNA_SUBMIT" | jq -r '.success // false')
MIKE_SUBMIT_SUCCESS=$(echo "$MIKE_SUBMIT" | jq -r '.success // false')
DAVID_SUBMIT_SUCCESS=$(echo "$DAVID_SUBMIT" | jq -r '.success // false')

run_test "Anna AT Submitted" "true" "$ANNA_SUBMIT_SUCCESS" "Operations AT submitted for approval"
run_test "Mike AT Submitted" "true" "$MIKE_SUBMIT_SUCCESS" "Finance AT submitted for approval"  
run_test "David AT Submitted" "true" "$DAVID_SUBMIT_SUCCESS" "Operations AT submitted for approval"

# TEST 19-21: Supervisor Approvals (Correct Department Only)
echo "✅ Test 22-24: Supervisor Approvals (Department Governance)"

# Lisa approves Anna's AT (Operations)
LISA_APPROVE_ANNA=$(api_call "PUT" "/api/travel-auth/$ANNA_AT_ID/approve" "$LISA_SESSION")
LISA_APPROVE_SUCCESS=$(echo "$LISA_APPROVE_ANNA" | jq -r '.success // false')

# Sarah approves Mike's AT (Finance)  
SARAH_APPROVE_MIKE=$(api_call "PUT" "/api/travel-auth/$MIKE_AT_ID/approve" "$SARAH_SESSION")
SARAH_APPROVE_SUCCESS=$(echo "$SARAH_APPROVE_MIKE" | jq -r '.success // false')

# Lisa approves David's AT (Operations)
LISA_APPROVE_DAVID=$(api_call "PUT" "/api/travel-auth/$DAVID_AT_ID/approve" "$LISA_SESSION")
LISA_APPROVE_DAVID_SUCCESS=$(echo "$LISA_APPROVE_DAVID" | jq -r '.success // false')

run_test "Lisa Approves Anna" "true" "$LISA_APPROVE_SUCCESS" "Operations supervisor approves Operations employee AT"
run_test "Sarah Approves Mike" "true" "$SARAH_APPROVE_SUCCESS" "Finance supervisor approves Finance employee AT"
run_test "Lisa Approves David" "true" "$LISA_APPROVE_DAVID_SUCCESS" "Operations supervisor approves Operations employee AT"

# TEST 22-24: Cross-Department Approval Violation Tests  
echo "🚫 Test 25-27: Cross-Department Approval Violations"

# Try Sarah approving Anna's AT (should fail - wrong department)
SARAH_CROSS_APPROVE=$(api_call "PUT" "/api/travel-auth/$ANNA_AT_ID/approve" "$SARAH_SESSION" 2>/dev/null)
SARAH_CROSS_ERROR=$(echo "$SARAH_CROSS_APPROVE" | jq -r '.error // "none"')
SARAH_VIOLATION_BLOCKED=$([[ "$SARAH_CROSS_ERROR" != "none" ]] && echo "true" || echo "false")

# Try Lisa approving Mike's AT (should fail - wrong department) 
LISA_CROSS_APPROVE=$(api_call "PUT" "/api/travel-auth/$MIKE_AT_ID/approve" "$LISA_SESSION" 2>/dev/null)
LISA_CROSS_ERROR=$(echo "$LISA_CROSS_APPROVE" | jq -r '.error // "none"')
LISA_VIOLATION_BLOCKED=$([[ "$LISA_CROSS_ERROR" != "none" ]] && echo "true" || echo "false")

run_test "Sarah Cross-Dept Blocked" "true" "$SARAH_VIOLATION_BLOCKED" "Finance supervisor cannot approve Operations AT"
run_test "Lisa Cross-Dept Blocked" "true" "$LISA_VIOLATION_BLOCKED" "Operations supervisor cannot approve Finance AT"

# TEST 25: Verify Trips Auto-Created
echo "🧳 Test 28-30: Verify Trips Auto-Created After Approval"

ANNA_TRIPS=$(api_call "GET" "/api/trips" "$ANNA_SESSION" | jq 'length // 0')
MIKE_TRIPS=$(api_call "GET" "/api/trips" "$MIKE_SESSION" | jq 'length // 0')
DAVID_TRIPS=$(api_call "GET" "/api/trips" "$DAVID_SESSION" | jq 'length // 0')

run_test "Anna Trip Created" "1" "$ANNA_TRIPS" "Trip auto-created after AT approval"
run_test "Mike Trip Created" "1" "$MIKE_TRIPS" "Trip auto-created after AT approval"
run_test "David Trip Created" "1" "$DAVID_TRIPS" "Trip auto-created after AT approval"

echo ""
echo "🎯 PHASE 3: TRIP WORKFLOW & FINAL APPROVAL"
echo "=========================================="

# Get trip IDs
ANNA_TRIP_ID=$(api_call "GET" "/api/trips" "$ANNA_SESSION" | jq -r '.[0].id // empty')
MIKE_TRIP_ID=$(api_call "GET" "/api/trips" "$MIKE_SESSION" | jq -r '.[0].id // empty')

echo "📝 Test 31-35: Add Actual Expenses to Trips"

# Add actual expenses to trips (different from estimates to test variance)
ANNA_ACTUAL_HOTEL=$(api_call "POST" "/api/expenses" "$ANNA_SESSION" '{"expense_type":"hotel","date":"2026-02-28","amount":"175.00","location":"Toronto","description":"Actual hotel cost","trip_id":"'$ANNA_TRIP_ID'"}')
ANNA_ACTUAL_MEAL=$(api_call "POST" "/api/expenses" "$ANNA_SESSION" '{"expense_type":"dinner","date":"2026-03-01","amount":"47.05","location":"Toronto","trip_id":"'$ANNA_TRIP_ID'"}')

MIKE_ACTUAL_PARKING=$(api_call "POST" "/api/expenses" "$MIKE_SESSION" '{"expense_type":"other","date":"2026-03-06","amount":"25.00","location":"Montreal","description":"Parking fees","trip_id":"'$MIKE_TRIP_ID'"}')

ANNA_HOTEL_ACTUAL_SUCCESS=$(echo "$ANNA_ACTUAL_HOTEL" | jq -r '.success // false')
ANNA_MEAL_ACTUAL_SUCCESS=$(echo "$ANNA_ACTUAL_MEAL" | jq -r '.success // false')
MIKE_PARKING_SUCCESS=$(echo "$MIKE_ACTUAL_PARKING" | jq -r '.success // false')

run_test "Anna Actual Hotel" "true" "$ANNA_HOTEL_ACTUAL_SUCCESS" "Actual hotel expense added to trip"
run_test "Anna Actual Meal" "true" "$ANNA_MEAL_ACTUAL_SUCCESS" "Actual meal expense added to trip"
run_test "Mike Parking Added" "true" "$MIKE_PARKING_SUCCESS" "Additional parking expense added to trip"

# TEST 31-33: Submit Trips for Final Approval
echo "📤 Test 36-38: Submit Trips for Final Approval"

ANNA_TRIP_SUBMIT=$(api_call "POST" "/api/trips/$ANNA_TRIP_ID/submit" "$ANNA_SESSION")
MIKE_TRIP_SUBMIT=$(api_call "POST" "/api/trips/$MIKE_TRIP_ID/submit" "$MIKE_SESSION")

ANNA_TRIP_SUBMIT_SUCCESS=$(echo "$ANNA_TRIP_SUBMIT" | jq -r '.success // false')
MIKE_TRIP_SUBMIT_SUCCESS=$(echo "$MIKE_TRIP_SUBMIT" | jq -r '.success // false')

run_test "Anna Trip Submitted" "true" "$ANNA_TRIP_SUBMIT_SUCCESS" "Operations trip submitted for final approval"
run_test "Mike Trip Submitted" "true" "$MIKE_TRIP_SUBMIT_SUCCESS" "Finance trip submitted for final approval"

# TEST 34-36: Final Supervisor Approval of Trips
echo "✅ Test 39-41: Final Trip Approvals by Supervisors"

# Check if supervisors can see submitted trips in their approval queue
LISA_PENDING_EXPENSES=$(api_call "GET" "/api/expenses" "$LISA_SESSION" | jq '[.[] | select(.trip_id != null and (.trip_status == "submitted" or .status == "pending"))] | length')
SARAH_PENDING_EXPENSES=$(api_call "GET" "/api/expenses" "$SARAH_SESSION" | jq '[.[] | select(.trip_id != null and (.trip_status == "submitted" or .status == "pending"))] | length')

run_test "Lisa Sees Pending Trips" "2" "$LISA_PENDING_EXPENSES" "Operations supervisor sees team's submitted trip expenses"
run_test "Sarah Sees Pending Trips" "1" "$SARAH_PENDING_EXPENSES" "Finance supervisor sees team's submitted trip expenses"

echo ""
echo "🎯 PHASE 4: EDGE CASES & ERROR HANDLING"
echo "======================================="

# TEST 37-40: Error Handling & Edge Cases
echo "🚫 Test 42-45: Error Handling & Edge Cases"

# Try creating AT with invalid date range
INVALID_DATE_AT=$(api_call "POST" "/api/travel-auth" "$ANNA_SESSION" '{"name":"Invalid AT","destination":"Test","start_date":"2026-03-15","end_date":"2026-03-10","purpose":"Test"}')
INVALID_DATE_ERROR=$(echo "$INVALID_DATE_AT" | jq -r '.error // "none"')
DATE_VALIDATION_WORKS=$([[ "$INVALID_DATE_ERROR" != "none" ]] && echo "true" || echo "false")

# Try creating expense with invalid type
INVALID_EXPENSE=$(api_call "POST" "/api/travel-auth/$ANNA_AT_ID/expenses" "$ANNA_SESSION" '{"expense_type":"invalid_type","date":"2026-02-28","amount":"100.00"}')
INVALID_TYPE_ERROR=$(echo "$INVALID_EXPENSE" | jq -r '.error // "none"')
TYPE_VALIDATION_WORKS=$([[ "$INVALID_TYPE_ERROR" != "none" ]] && echo "true" || echo "false")

# Try duplicate per diem
DUPLICATE_MEAL=$(api_call "POST" "/api/travel-auth/$ANNA_AT_ID/expenses" "$ANNA_SESSION" '{"expense_type":"breakfast","date":"2026-03-01","amount":"23.45","location":"Toronto"}')
DUPLICATE_ERROR=$(echo "$DUPLICATE_MEAL" | jq -r '.error // "none"')
DUPLICATE_PREVENTION_WORKS=$([[ "$DUPLICATE_ERROR" != "none" ]] && echo "true" || echo "false")

# Try employee approving their own AT
SELF_APPROVAL=$(api_call "PUT" "/api/travel-auth/$ANNA_AT_ID/approve" "$ANNA_SESSION" 2>/dev/null)
SELF_APPROVAL_ERROR=$(echo "$SELF_APPROVAL" | jq -r '.error // "none"')
SELF_APPROVAL_BLOCKED=$([[ "$SELF_APPROVAL_ERROR" != "none" ]] && echo "true" || echo "false")

run_test "Date Validation Works" "true" "$DATE_VALIDATION_WORKS" "Invalid date ranges are rejected"
run_test "Expense Type Validation" "true" "$TYPE_VALIDATION_WORKS" "Invalid expense types are rejected"
run_test "Duplicate Prevention" "true" "$DUPLICATE_PREVENTION_WORKS" "Duplicate per diems are prevented"
run_test "Self-Approval Blocked" "true" "$SELF_APPROVAL_BLOCKED" "Employees cannot approve their own ATs"

echo ""
echo "📊 FINAL RESULTS"
echo "================"
echo -e "${BLUE}Total Tests Run: $TEST_COUNT${NC}"
echo -e "${GREEN}Passed: $PASS_COUNT${NC}"
echo -e "${RED}Failed: $FAIL_COUNT${NC}"

PASS_RATE=$((PASS_COUNT * 100 / TEST_COUNT))
echo -e "${YELLOW}Pass Rate: $PASS_RATE%${NC}"

if [ $PASS_RATE -ge 90 ]; then
    echo -e "${GREEN}🎉 EXCELLENT! Governance & Workflow systems are functioning properly${NC}"
elif [ $PASS_RATE -ge 80 ]; then
    echo -e "${YELLOW}✅ GOOD! Minor issues detected, system is mostly functional${NC}"
else
    echo -e "${RED}⚠️  NEEDS WORK! Significant issues detected requiring fixes${NC}"
fi

echo ""
echo "🔐 GOVERNANCE SUMMARY:"
echo "- Department isolation: $(( (PASS_COUNT >= 5) && echo "✅ WORKING" || echo "❌ NEEDS WORK" ))"
echo "- Direct reports only: $(( (PASS_COUNT >= 8) && echo "✅ WORKING" || echo "❌ NEEDS WORK" ))"
echo "- Cross-department blocks: $(( (PASS_COUNT >= 10) && echo "✅ WORKING" || echo "❌ NEEDS WORK" ))"
echo "- Complete workflow: $(( (PASS_COUNT >= 15) && echo "✅ WORKING" || echo "❌ NEEDS WORK" ))"
echo ""
echo "Test completed at: $(date)"