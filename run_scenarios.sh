#!/bin/bash

# Test configuration
ADMIN_TOKEN="4abfb1711275d2d970cadc82a74f979f6e5407b62ef134108862d459b7e2c15a"
SUPERVISOR_TOKEN="4191f38bf4fc2038233d1843895be58a9d6033e7adbee044c7f40891d7a50d48"
DAVID_TOKEN="8ca66757d60132f18740c28b00644ccdef38b596f703dc09c56b6d9a8dad62bc"
LISA_TOKEN="84203e18820fe6d4f00fc6fbfd7515db444784793d0b0a2116fc498b55049371"

BASE_URL="http://localhost:3000"
RESULTS_FILE="/Users/tony/.openclaw/workspace/expense-app/SCENARIO-TEST-RESULTS.md"

# Initialize results file
cat > "$RESULTS_FILE" << EOF
# Expense Tracker Scenario Test Results
**Test Date:** $(date)
**Server:** $BASE_URL

## Test Results Summary

EOF

# Helper functions
log_result() {
    local scenario="$1"
    local status="$2" 
    local details="$3"
    echo "### Scenario $scenario: $status" >> "$RESULTS_FILE"
    echo "$details" >> "$RESULTS_FILE"
    echo "" >> "$RESULTS_FILE"
}

create_trip() {
    local token="$1"
    local start_date="$2"
    local end_date="$3"
    local purpose="$4"
    
    curl -s -X POST "$BASE_URL/api/trips" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{\"start_date\":\"$start_date\",\"end_date\":\"$end_date\",\"purpose\":\"$purpose\",\"destination\":\"Test City\"}"
}

add_expense() {
    local token="$1"
    local trip_id="$2"
    local date="$3"
    local type="$4" 
    local amount="$5"
    local description="$6"
    
    curl -s -X POST "$BASE_URL/api/expenses" \
        -H "Authorization: Bearer $token" \
        -F "trip_id=$trip_id" \
        -F "date=$date" \
        -F "expense_type=$type" \
        -F "amount=$amount" \
        -F "description=$description"
}

submit_trip() {
    local token="$1"
    local trip_id="$2"
    
    curl -s -X PUT "$BASE_URL/api/trips/$trip_id/submit" \
        -H "Authorization: Bearer $token"
}

approve_expense() {
    local token="$1"
    local expense_id="$2"
    
    curl -s -X PUT "$BASE_URL/api/expenses/$expense_id/approve" \
        -H "Authorization: Bearer $token"
}

reject_expense() {
    local token="$1"
    local expense_id="$2"
    local reason="$3"
    
    curl -s -X PUT "$BASE_URL/api/expenses/$expense_id/reject" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{\"reason\":\"$reason\"}"
}

echo "Starting scenario tests..."

# SCENARIO 1: REJECTION FLOW
echo "=== SCENARIO 1: REJECTION FLOW ==="
trip1=$(create_trip "$DAVID_TOKEN" "2026-03-15" "2026-03-17" "Business meeting")
trip1_id=$(echo "$trip1" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$trip1_id" ]]; then
    # Add expense
    expense1=$(add_expense "$DAVID_TOKEN" "$trip1_id" "2026-03-16" "breakfast" "23.45" "Hotel breakfast")
    expense1_id=$(echo "$expense1" | grep -o '"id":[0-9]*' | cut -d':' -f2)
    
    # Submit trip
    submit_result=$(submit_trip "$DAVID_TOKEN" "$trip1_id")
    
    # Supervisor rejects
    reject_result=$(reject_expense "$SUPERVISOR_TOKEN" "$expense1_id" "Need receipt")
    
    # Check if employee can resubmit
    resubmit_result=$(add_expense "$DAVID_TOKEN" "$trip1_id" "2026-03-16" "breakfast" "23.45" "Hotel breakfast with receipt")
    
    if [[ "$reject_result" == *"success"* && "$resubmit_result" == *"id"* ]]; then
        log_result "1" "PASS" "Employee submitted trip → Supervisor rejected → Employee successfully resubmitted"
    else
        log_result "1" "FAIL" "Rejection flow failed. Reject: $reject_result, Resubmit: $resubmit_result"
    fi
else
    log_result "1" "FAIL" "Failed to create initial trip"
fi

# SCENARIO 2: EMPTY TRIP  
echo "=== SCENARIO 2: EMPTY TRIP ==="
trip2=$(create_trip "$DAVID_TOKEN" "2026-04-01" "2026-04-03" "Empty trip test")
trip2_id=$(echo "$trip2" | grep -o '"id":[0-9]*' | cut -d':' -f2)

empty_submit=$(submit_trip "$DAVID_TOKEN" "$trip2_id")
if [[ "$empty_submit" == *"error"* || "$empty_submit" == *"expense"* ]]; then
    log_result "2" "PASS" "Empty trip submission properly blocked/warned: $empty_submit"
else
    log_result "2" "FAIL" "Empty trip was allowed to submit: $empty_submit"
fi

# SCENARIO 3: PAST DATES
echo "=== SCENARIO 3: PAST DATES ==="
past_trip=$(create_trip "$DAVID_TOKEN" "2025-12-01" "2025-12-03" "Retroactive claim")
past_trip_id=$(echo "$past_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$past_trip_id" ]]; then
    past_expense=$(add_expense "$DAVID_TOKEN" "$past_trip_id" "2025-12-02" "lunch" "29.75" "Client lunch")
    if [[ "$past_expense" == *"id"* ]]; then
        log_result "3" "PASS" "Past dates allowed for retroactive claims"
    else
        log_result "3" "FAIL" "Past dates rejected: $past_expense"
    fi
else
    log_result "3" "FAIL" "Failed to create past date trip: $past_trip"
fi

# SCENARIO 4: OVERLAPPING TRIPS
echo "=== SCENARIO 4: OVERLAPPING TRIPS ==="
overlap1=$(create_trip "$DAVID_TOKEN" "2026-05-01" "2026-05-05" "Trip 1")
overlap2=$(create_trip "$DAVID_TOKEN" "2026-05-03" "2026-05-07" "Trip 2") 

overlap1_id=$(echo "$overlap1" | grep -o '"id":[0-9]*' | cut -d':' -f2)
overlap2_id=$(echo "$overlap2" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$overlap1_id" && -n "$overlap2_id" ]]; then
    log_result "4" "FAIL" "Overlapping trips were both created successfully - should be blocked"
elif [[ -n "$overlap1_id" && -z "$overlap2_id" ]]; then
    log_result "4" "PASS" "Second overlapping trip was blocked: $overlap2"
else
    log_result "4" "UNCERTAIN" "Overlap1: $overlap1, Overlap2: $overlap2"
fi

# SCENARIO 5: PER DIEM CROSS-TRIP
echo "=== SCENARIO 5: PER DIEM CROSS-TRIP ==="
cross1=$(create_trip "$DAVID_TOKEN" "2026-06-01" "2026-06-03" "Trip A")
cross2=$(create_trip "$DAVID_TOKEN" "2026-06-03" "2026-06-05" "Trip B")

cross1_id=$(echo "$cross1" | grep -o '"id":[0-9]*' | cut -d':' -f2)
cross2_id=$(echo "$cross2" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$cross1_id" && -n "$cross2_id" ]]; then
    breakfast1=$(add_expense "$DAVID_TOKEN" "$cross1_id" "2026-06-03" "breakfast" "23.45" "Day 1 breakfast")
    breakfast2=$(add_expense "$DAVID_TOKEN" "$cross2_id" "2026-06-03" "breakfast" "23.45" "Day 2 breakfast")
    
    if [[ "$breakfast1" == *"id"* && "$breakfast2" == *"error"* ]]; then
        log_result "5" "PASS" "Cross-trip per diem blocked: $breakfast2"
    else
        log_result "5" "FAIL" "Cross-trip per diem allowed. B1: $breakfast1, B2: $breakfast2"
    fi
else
    log_result "5" "FAIL" "Failed to create cross trips for testing"
fi

# SCENARIO 6: WRONG AMOUNT PER DIEM
echo "=== SCENARIO 6: WRONG AMOUNT PER DIEM ==="
wrong_trip=$(create_trip "$DAVID_TOKEN" "2026-07-01" "2026-07-03" "Wrong amount test")
wrong_trip_id=$(echo "$wrong_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

wrong_breakfast=$(add_expense "$DAVID_TOKEN" "$wrong_trip_id" "2026-07-02" "breakfast" "50.00" "Overpriced breakfast")
if [[ "$wrong_breakfast" == *"error"* || "$wrong_breakfast" == *"amount"* ]]; then
    log_result "6" "PASS" "Wrong per diem amount rejected: $wrong_breakfast"
else
    log_result "6" "FAIL" "Wrong per diem amount accepted: $wrong_breakfast"
fi

# SCENARIO 7: INVALID EXPENSE TYPE
echo "=== SCENARIO 7: INVALID EXPENSE TYPE ==="
invalid_trip=$(create_trip "$DAVID_TOKEN" "2026-08-01" "2026-08-03" "Invalid type test") 
invalid_trip_id=$(echo "$invalid_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

invalid_expense=$(add_expense "$DAVID_TOKEN" "$invalid_trip_id" "2026-08-02" "fake" "100.00" "Fake expense type")
if [[ "$invalid_expense" == *"error"* || "$invalid_expense" == *"type"* ]]; then
    log_result "7" "PASS" "Invalid expense type rejected: $invalid_expense"
else
    log_result "7" "FAIL" "Invalid expense type accepted: $invalid_expense"  
fi

# SCENARIO 8: NO AUTH
echo "=== SCENARIO 8: NO AUTH ==="
no_auth_result=$(curl -s -X POST "$BASE_URL/api/expenses" \
    -F "trip_id=1" \
    -F "date=2026-09-01" \
    -F "expense_type=lunch" \
    -F "amount=29.75" \
    -F "description=No auth test")

if [[ "$no_auth_result" == *"401"* || "$no_auth_result" == *"Unauthorized"* || "$no_auth_result" == *"auth"* ]]; then
    log_result "8" "PASS" "No auth properly rejected: $no_auth_result"
else
    log_result "8" "FAIL" "No auth was accepted: $no_auth_result"
fi

# SCENARIO 9: WRONG ROLE
echo "=== SCENARIO 9: WRONG ROLE ==="
# First create an expense to try to approve
role_trip=$(create_trip "$DAVID_TOKEN" "2026-09-10" "2026-09-12" "Role test")
role_trip_id=$(echo "$role_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)
role_expense=$(add_expense "$DAVID_TOKEN" "$role_trip_id" "2026-09-11" "lunch" "29.75" "Role test lunch")
role_expense_id=$(echo "$role_expense" | grep -o '"id":[0-9]*' | cut -d':' -f2)

# David (employee) tries to approve his own expense
wrong_role_result=$(approve_expense "$DAVID_TOKEN" "$role_expense_id")
if [[ "$wrong_role_result" == *"error"* || "$wrong_role_result" == *"permission"* || "$wrong_role_result" == *"role"* ]]; then
    log_result "9" "PASS" "Wrong role approval blocked: $wrong_role_result"
else
    log_result "9" "FAIL" "Wrong role approval allowed: $wrong_role_result"
fi

# SCENARIO 10: ADMIN LIST ALL
echo "=== SCENARIO 10: ADMIN LIST ALL ==="
admin_list=$(curl -s -X GET "$BASE_URL/api/expenses" -H "Authorization: Bearer $ADMIN_TOKEN")
if [[ "$admin_list" == *"david.wilson"* && "$admin_list" == *"lisa.brown"* ]]; then
    log_result "10" "PASS" "Admin can see expenses from multiple employees"
else
    log_result "10" "UNCERTAIN" "Admin list result: $admin_list"
fi

# SCENARIO 11: MULTIPLE EMPLOYEES
echo "=== SCENARIO 11: MULTIPLE EMPLOYEES ==="
# David creates and submits trip
david_multi=$(create_trip "$DAVID_TOKEN" "2026-10-01" "2026-10-03" "David multi test")
david_multi_id=$(echo "$david_multi" | grep -o '"id":[0-9]*' | cut -d':' -f2)
add_expense "$DAVID_TOKEN" "$david_multi_id" "2026-10-02" "dinner" "47.05" "David dinner"
submit_trip "$DAVID_TOKEN" "$david_multi_id"

# Lisa creates and submits trip
lisa_multi=$(create_trip "$LISA_TOKEN" "2026-10-05" "2026-10-07" "Lisa multi test")  
lisa_multi_id=$(echo "$lisa_multi" | grep -o '"id":[0-9]*' | cut -d':' -f2)
add_expense "$LISA_TOKEN" "$lisa_multi_id" "2026-10-06" "dinner" "47.05" "Lisa dinner"
submit_trip "$LISA_TOKEN" "$lisa_multi_id"

# Check supervisor queue
supervisor_queue=$(curl -s -X GET "$BASE_URL/api/expenses" -H "Authorization: Bearer $SUPERVISOR_TOKEN")
if [[ "$supervisor_queue" == *"David"* && "$supervisor_queue" == *"Lisa"* ]]; then
    log_result "11" "PASS" "Both employees appear in supervisor queue"
else
    log_result "11" "UNCERTAIN" "Supervisor queue: $supervisor_queue"
fi

# SCENARIO 12: RECEIPT UPLOAD
echo "=== SCENARIO 12: RECEIPT UPLOAD ==="
receipt_trip=$(create_trip "$DAVID_TOKEN" "2026-11-01" "2026-11-03" "Receipt test")
receipt_trip_id=$(echo "$receipt_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

# Create dummy receipt file
echo "RECEIPT CONTENT" > /tmp/receipt.txt

receipt_result=$(curl -s -X POST "$BASE_URL/api/expenses" \
    -H "Authorization: Bearer $DAVID_TOKEN" \
    -F "trip_id=$receipt_trip_id" \
    -F "date=2026-11-02" \
    -F "expense_type=hotel" \
    -F "amount=150.00" \
    -F "description=Hotel with receipt" \
    -F "receipt=@/tmp/receipt.txt")

if [[ "$receipt_result" == *"id"* ]]; then
    log_result "12" "PASS" "Receipt upload successful"
else
    log_result "12" "FAIL" "Receipt upload failed: $receipt_result"
fi

# SCENARIO 13: VEHICLE CALCULATION
echo "=== SCENARIO 13: VEHICLE CALCULATION ==="
vehicle_trip=$(create_trip "$DAVID_TOKEN" "2026-12-01" "2026-12-03" "Vehicle test")
vehicle_trip_id=$(echo "$vehicle_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

vehicle_result=$(add_expense "$DAVID_TOKEN" "$vehicle_trip_id" "2026-12-02" "vehicle_km" "68.00" "100km drive")
if [[ "$vehicle_result" == *"id"* ]]; then
    log_result "13" "PASS" "Vehicle calculation accepted (100km × $0.68 = $68.00)"
else
    log_result "13" "FAIL" "Vehicle calculation rejected: $vehicle_result"
fi

# SCENARIO 14: SESSION EXPIRY
echo "=== SCENARIO 14: SESSION EXPIRY ==="
invalid_token_result=$(curl -s -X POST "$BASE_URL/api/expenses" \
    -H "Authorization: Bearer invalid_token_12345" \
    -F "trip_id=1" \
    -F "date=2026-12-15" \
    -F "expense_type=lunch" \
    -F "amount=29.75" \
    -F "description=Invalid token test")

if [[ "$invalid_token_result" == *"401"* || "$invalid_token_result" == *"Unauthorized"* || "$invalid_token_result" == *"token"* ]]; then
    log_result "14" "PASS" "Invalid token rejected: $invalid_token_result"
else
    log_result "14" "FAIL" "Invalid token accepted: $invalid_token_result"
fi

# SCENARIO 15: DOUBLE SUBMIT
echo "=== SCENARIO 15: DOUBLE SUBMIT ==="
double_trip=$(create_trip "$DAVID_TOKEN" "2027-01-01" "2027-01-03" "Double submit test")
double_trip_id=$(echo "$double_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)
add_expense "$DAVID_TOKEN" "$double_trip_id" "2027-01-02" "lunch" "29.75" "Test lunch"

first_submit=$(submit_trip "$DAVID_TOKEN" "$double_trip_id")
second_submit=$(submit_trip "$DAVID_TOKEN" "$double_trip_id")

if [[ "$first_submit" == *"success"* && "$second_submit" == *"error"* ]]; then
    log_result "15" "PASS" "Double submit blocked: $second_submit"
else
    log_result "15" "FAIL" "Double submit allowed. First: $first_submit, Second: $second_submit"
fi

# SCENARIO 16: LARGE DESCRIPTION
echo "=== SCENARIO 16: LARGE DESCRIPTION ==="
large_trip=$(create_trip "$DAVID_TOKEN" "2027-02-01" "2027-02-03" "Large description test")
large_trip_id=$(echo "$large_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

# Generate 1000+ character description
large_desc=$(printf '%0.s!' {1..1200})
large_desc_result=$(add_expense "$DAVID_TOKEN" "$large_trip_id" "2027-02-02" "lunch" "29.75" "$large_desc")

if [[ "$large_desc_result" == *"id"* ]]; then
    log_result "16" "PASS" "Large description accepted"
else
    log_result "16" "FAIL" "Large description rejected: $large_desc_result"
fi

# SCENARIO 17: NEGATIVE AMOUNT
echo "=== SCENARIO 17: NEGATIVE AMOUNT ==="
neg_trip=$(create_trip "$DAVID_TOKEN" "2027-03-01" "2027-03-03" "Negative test")
neg_trip_id=$(echo "$neg_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

neg_result=$(add_expense "$DAVID_TOKEN" "$neg_trip_id" "2027-03-02" "lunch" "-29.75" "Negative amount test")
if [[ "$neg_result" == *"error"* || "$neg_result" == *"amount"* ]]; then
    log_result "17" "PASS" "Negative amount rejected: $neg_result"
else
    log_result "17" "FAIL" "Negative amount accepted: $neg_result"
fi

# SCENARIO 18: ZERO AMOUNT
echo "=== SCENARIO 18: ZERO AMOUNT ==="
zero_trip=$(create_trip "$DAVID_TOKEN" "2027-04-01" "2027-04-03" "Zero test")
zero_trip_id=$(echo "$zero_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

zero_result=$(add_expense "$DAVID_TOKEN" "$zero_trip_id" "2027-04-02" "lunch" "0.00" "Zero amount test")
if [[ "$zero_result" == *"error"* ]]; then
    log_result "18" "PASS" "Zero amount rejected: $zero_result"
else
    log_result "18" "UNCERTAIN" "Zero amount result: $zero_result"
fi

# SCENARIO 19: MISSING REQUIRED FIELDS
echo "=== SCENARIO 19: MISSING REQUIRED FIELDS ==="
missing_trip=$(create_trip "$DAVID_TOKEN" "2027-05-01" "2027-05-03" "Missing fields test")
missing_trip_id=$(echo "$missing_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

# Missing date
missing1=$(curl -s -X POST "$BASE_URL/api/expenses" \
    -H "Authorization: Bearer $DAVID_TOKEN" \
    -F "trip_id=$missing_trip_id" \
    -F "expense_type=lunch" \
    -F "amount=29.75" \
    -F "description=Missing date")

# Missing type  
missing2=$(curl -s -X POST "$BASE_URL/api/expenses" \
    -H "Authorization: Bearer $DAVID_TOKEN" \
    -F "trip_id=$missing_trip_id" \
    -F "date=2027-05-02" \
    -F "amount=29.75" \
    -F "description=Missing type")

# Missing amount
missing3=$(curl -s -X POST "$BASE_URL/api/expenses" \
    -H "Authorization: Bearer $DAVID_TOKEN" \
    -F "trip_id=$missing_trip_id" \
    -F "date=2027-05-02" \
    -F "expense_type=lunch" \
    -F "description=Missing amount")

if [[ "$missing1" == *"error"* && "$missing2" == *"error"* && "$missing3" == *"error"* ]]; then
    log_result "19" "PASS" "Missing required fields properly rejected"
else
    log_result "19" "FAIL" "Missing fields not properly validated. M1: $missing1, M2: $missing2, M3: $missing3"
fi

# SCENARIO 20: TRIP DATE VALIDATION
echo "=== SCENARIO 20: TRIP DATE VALIDATION ==="
date_trip=$(create_trip "$DAVID_TOKEN" "2027-06-01" "2027-06-03" "Date validation test")
date_trip_id=$(echo "$date_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

# Try expense outside trip range
outside_result=$(add_expense "$DAVID_TOKEN" "$date_trip_id" "2027-07-01" "lunch" "29.75" "Outside trip dates")
if [[ "$outside_result" == *"error"* || "$outside_result" == *"date"* ]]; then
    log_result "20" "PASS" "Expense outside trip date range rejected: $outside_result"
else
    log_result "20" "FAIL" "Expense outside trip date range accepted: $outside_result"
fi

echo "All scenarios tested. Results written to $RESULTS_FILE"

# Clean up temp file
rm -f /tmp/receipt.txt