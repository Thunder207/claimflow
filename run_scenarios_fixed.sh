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
    local trip_name="$4"
    local destination="$5"
    
    curl -s -X POST "$BASE_URL/api/trips" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{\"trip_name\":\"$trip_name\",\"start_date\":\"$start_date\",\"end_date\":\"$end_date\",\"destination\":\"$destination\"}"
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
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d '{}'
}

approve_expense() {
    local token="$1"
    local expense_id="$2"
    
    curl -s -X PUT "$BASE_URL/api/expenses/$expense_id/approve" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d '{}'
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

echo "Starting fixed scenario tests..."

# SCENARIO 1: REJECTION FLOW
echo "=== SCENARIO 1: REJECTION FLOW ==="
trip1=$(create_trip "$DAVID_TOKEN" "2026-03-15" "2026-03-17" "Rejection Flow Test" "Test City")
echo "Trip1 result: $trip1"
trip1_id=$(echo "$trip1" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$trip1_id" ]]; then
    # Add expense
    expense1=$(add_expense "$DAVID_TOKEN" "$trip1_id" "2026-03-16" "breakfast" "23.45" "Hotel breakfast")
    echo "Expense1 result: $expense1"
    expense1_id=$(echo "$expense1" | grep -o '"id":[0-9]*' | cut -d':' -f2)
    
    if [[ -n "$expense1_id" ]]; then
        # Submit trip
        submit_result=$(submit_trip "$DAVID_TOKEN" "$trip1_id")
        echo "Submit result: $submit_result"
        
        # Supervisor rejects
        reject_result=$(reject_expense "$SUPERVISOR_TOKEN" "$expense1_id" "Need receipt")
        echo "Reject result: $reject_result"
        
        # Check if employee can resubmit (add another expense)
        resubmit_result=$(add_expense "$DAVID_TOKEN" "$trip1_id" "2026-03-16" "lunch" "29.75" "Lunch with receipt")
        echo "Resubmit result: $resubmit_result"
        
        if [[ "$reject_result" == *"success"* && "$resubmit_result" == *"id"* ]]; then
            log_result "1" "PASS" "Employee submitted trip → Supervisor rejected → Employee successfully resubmitted"
        else
            log_result "1" "FAIL" "Rejection flow failed. Reject: $reject_result, Resubmit: $resubmit_result"
        fi
    else
        log_result "1" "FAIL" "Failed to add expense to trip. Expense result: $expense1"
    fi
else
    log_result "1" "FAIL" "Failed to create initial trip. Trip result: $trip1"
fi

# SCENARIO 2: EMPTY TRIP  
echo "=== SCENARIO 2: EMPTY TRIP ==="
trip2=$(create_trip "$DAVID_TOKEN" "2026-04-01" "2026-04-03" "Empty Trip Test" "Test City")
trip2_id=$(echo "$trip2" | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo "Empty trip ID: $trip2_id"

if [[ -n "$trip2_id" ]]; then
    empty_submit=$(submit_trip "$DAVID_TOKEN" "$trip2_id")
    echo "Empty submit result: $empty_submit"
    if [[ "$empty_submit" == *"error"* || "$empty_submit" == *"expense"* || "$empty_submit" == *"Cannot"* ]]; then
        log_result "2" "PASS" "Empty trip submission properly blocked/warned: $empty_submit"
    else
        log_result "2" "FAIL" "Empty trip was allowed to submit: $empty_submit"
    fi
else
    log_result "2" "FAIL" "Failed to create empty trip for testing"
fi

# SCENARIO 3: PAST DATES
echo "=== SCENARIO 3: PAST DATES ==="
past_trip=$(create_trip "$DAVID_TOKEN" "2025-12-01" "2025-12-03" "Retroactive Claim Test" "Past City")
past_trip_id=$(echo "$past_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo "Past trip ID: $past_trip_id"

if [[ -n "$past_trip_id" ]]; then
    past_expense=$(add_expense "$DAVID_TOKEN" "$past_trip_id" "2025-12-02" "lunch" "29.75" "Client lunch")
    echo "Past expense result: $past_expense"
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
overlap1=$(create_trip "$DAVID_TOKEN" "2026-05-01" "2026-05-05" "Trip Overlap 1" "City A")
overlap1_id=$(echo "$overlap1" | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo "Overlap1 ID: $overlap1_id"

if [[ -n "$overlap1_id" ]]; then
    overlap2=$(create_trip "$DAVID_TOKEN" "2026-05-03" "2026-05-07" "Trip Overlap 2" "City B")
    overlap2_id=$(echo "$overlap2" | grep -o '"id":[0-9]*' | cut -d':' -f2)
    echo "Overlap2 ID: $overlap2_id, Result: $overlap2"
    
    if [[ -n "$overlap2_id" ]]; then
        log_result "4" "FAIL" "Overlapping trips were both created successfully - should be blocked"
    else
        log_result "4" "PASS" "Second overlapping trip was blocked: $overlap2"
    fi
else
    log_result "4" "FAIL" "Failed to create first trip for overlap test"
fi

# SCENARIO 5: PER DIEM CROSS-TRIP (this might be application dependent)
echo "=== SCENARIO 5: PER DIEM CROSS-TRIP ==="
cross1=$(create_trip "$DAVID_TOKEN" "2026-06-01" "2026-06-03" "Cross Trip A" "City X")
cross1_id=$(echo "$cross1" | grep -o '"id":[0-9]*' | cut -d':' -f2)

cross2=$(create_trip "$DAVID_TOKEN" "2026-06-04" "2026-06-06" "Cross Trip B" "City Y") 
cross2_id=$(echo "$cross2" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$cross1_id" && -n "$cross2_id" ]]; then
    # Same date breakfast claims (06-03 is end of first trip, might overlap)
    breakfast1=$(add_expense "$DAVID_TOKEN" "$cross1_id" "2026-06-03" "breakfast" "23.45" "Trip A breakfast")
    breakfast2=$(add_expense "$DAVID_TOKEN" "$cross2_id" "2026-06-03" "breakfast" "23.45" "Trip B breakfast")
    
    echo "Breakfast1: $breakfast1"
    echo "Breakfast2: $breakfast2"
    
    if [[ "$breakfast1" == *"id"* && "$breakfast2" == *"error"* ]]; then
        log_result "5" "PASS" "Cross-trip per diem blocked: $breakfast2"
    elif [[ "$breakfast1" == *"id"* && "$breakfast2" == *"id"* ]]; then
        log_result "5" "FAIL" "Cross-trip per diem allowed - both breakfasts created"
    else
        log_result "5" "UNCERTAIN" "Cross-trip test unclear. B1: $breakfast1, B2: $breakfast2"
    fi
else
    log_result "5" "FAIL" "Failed to create cross trips for testing. T1: $cross1, T2: $cross2"
fi

# SCENARIO 6: WRONG AMOUNT PER DIEM
echo "=== SCENARIO 6: WRONG AMOUNT PER DIEM ==="
wrong_trip=$(create_trip "$DAVID_TOKEN" "2026-07-01" "2026-07-03" "Wrong Amount Test" "Wrong City")
wrong_trip_id=$(echo "$wrong_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$wrong_trip_id" ]]; then
    wrong_breakfast=$(add_expense "$DAVID_TOKEN" "$wrong_trip_id" "2026-07-02" "breakfast" "50.00" "Overpriced breakfast")
    echo "Wrong breakfast result: $wrong_breakfast"
    if [[ "$wrong_breakfast" == *"error"* || "$wrong_breakfast" == *"rate must be"* || "$wrong_breakfast" == *"23.45"* ]]; then
        log_result "6" "PASS" "Wrong per diem amount rejected: $wrong_breakfast"
    else
        log_result "6" "FAIL" "Wrong per diem amount accepted: $wrong_breakfast"
    fi
else
    log_result "6" "FAIL" "Failed to create trip for wrong amount test"
fi

# SCENARIO 7: INVALID EXPENSE TYPE
echo "=== SCENARIO 7: INVALID EXPENSE TYPE ==="
invalid_trip=$(create_trip "$DAVID_TOKEN" "2026-08-01" "2026-08-03" "Invalid Type Test" "Invalid City") 
invalid_trip_id=$(echo "$invalid_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$invalid_trip_id" ]]; then
    invalid_expense=$(add_expense "$DAVID_TOKEN" "$invalid_trip_id" "2026-08-02" "fake_type" "100.00" "Fake expense type")
    echo "Invalid expense result: $invalid_expense"
    if [[ "$invalid_expense" == *"error"* || "$invalid_expense" == *"type"* ]]; then
        log_result "7" "PASS" "Invalid expense type rejected: $invalid_expense"
    else
        log_result "7" "FAIL" "Invalid expense type accepted: $invalid_expense"  
    fi
else
    log_result "7" "FAIL" "Failed to create trip for invalid type test"
fi

# SCENARIO 8: NO AUTH
echo "=== SCENARIO 8: NO AUTH ==="
no_auth_result=$(curl -s -X POST "$BASE_URL/api/expenses" \
    -F "trip_id=1" \
    -F "date=2026-09-01" \
    -F "expense_type=lunch" \
    -F "amount=29.75" \
    -F "description=No auth test")

echo "No auth result: $no_auth_result"
if [[ "$no_auth_result" == *"401"* || "$no_auth_result" == *"Unauthorized"* || "$no_auth_result" == *"Authentication required"* ]]; then
    log_result "8" "PASS" "No auth properly rejected: $no_auth_result"
else
    log_result "8" "FAIL" "No auth was accepted: $no_auth_result"
fi

# SCENARIO 9: WRONG ROLE
echo "=== SCENARIO 9: WRONG ROLE ==="
# Create expense to try to approve
role_trip=$(create_trip "$DAVID_TOKEN" "2026-09-10" "2026-09-12" "Role Test Trip" "Role City")
role_trip_id=$(echo "$role_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$role_trip_id" ]]; then
    role_expense=$(add_expense "$DAVID_TOKEN" "$role_trip_id" "2026-09-11" "lunch" "29.75" "Role test lunch")
    role_expense_id=$(echo "$role_expense" | grep -o '"id":[0-9]*' | cut -d':' -f2)
    
    if [[ -n "$role_expense_id" ]]; then
        # David (employee) tries to approve his own expense
        wrong_role_result=$(approve_expense "$DAVID_TOKEN" "$role_expense_id")
        echo "Wrong role result: $wrong_role_result"
        if [[ "$wrong_role_result" == *"error"* || "$wrong_role_result" == *"permission"* || "$wrong_role_result" == *"role"* || "$wrong_role_result" == *"Cannot"* ]]; then
            log_result "9" "PASS" "Wrong role approval blocked: $wrong_role_result"
        else
            log_result "9" "FAIL" "Wrong role approval allowed: $wrong_role_result"
        fi
    else
        log_result "9" "FAIL" "Failed to create expense for role test"
    fi
else
    log_result "9" "FAIL" "Failed to create trip for role test"
fi

# SCENARIO 10: ADMIN LIST ALL
echo "=== SCENARIO 10: ADMIN LIST ALL ==="
admin_list=$(curl -s -X GET "$BASE_URL/api/expenses" -H "Authorization: Bearer $ADMIN_TOKEN")
echo "Admin list contains David: $(echo "$admin_list" | grep -c "David Wilson")"
echo "Admin list contains other employees: $(echo "$admin_list" | grep -c -E "(Anna Lee|Mike Davis|Lisa Brown)")"

if [[ "$admin_list" == *"David Wilson"* ]]; then
    employee_count=$(echo "$admin_list" | grep -o '"employee_name"' | wc -l)
    if [[ "$employee_count" -gt 5 ]]; then
        log_result "10" "PASS" "Admin can see expenses from multiple employees ($employee_count total expenses)"
    else
        log_result "10" "UNCERTAIN" "Admin sees expenses but limited count ($employee_count)"
    fi
else
    log_result "10" "FAIL" "Admin cannot see employee expenses: $admin_list"
fi

# SCENARIO 11: MULTIPLE EMPLOYEES
echo "=== SCENARIO 11: MULTIPLE EMPLOYEES ==="
# David creates and submits trip
david_multi=$(create_trip "$DAVID_TOKEN" "2026-10-01" "2026-10-03" "David Multi Test" "Multi City A")
david_multi_id=$(echo "$david_multi" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$david_multi_id" ]]; then
    add_expense "$DAVID_TOKEN" "$david_multi_id" "2026-10-02" "dinner" "47.05" "David dinner"
    submit_trip "$DAVID_TOKEN" "$david_multi_id"
fi

# Lisa creates and submits trip
lisa_multi=$(create_trip "$LISA_TOKEN" "2026-10-05" "2026-10-07" "Lisa Multi Test" "Multi City B")  
lisa_multi_id=$(echo "$lisa_multi" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$lisa_multi_id" ]]; then
    add_expense "$LISA_TOKEN" "$lisa_multi_id" "2026-10-06" "dinner" "47.05" "Lisa dinner"
    submit_trip "$LISA_TOKEN" "$lisa_multi_id"
fi

# Check supervisor queue
supervisor_queue=$(curl -s -X GET "$BASE_URL/api/expenses" -H "Authorization: Bearer $SUPERVISOR_TOKEN")
david_in_queue=$(echo "$supervisor_queue" | grep -c "David Wilson" || echo "0")
lisa_in_queue=$(echo "$supervisor_queue" | grep -c "Lisa Brown" || echo "0")

echo "David expenses in supervisor queue: $david_in_queue"
echo "Lisa expenses in supervisor queue: $lisa_in_queue"

if [[ "$david_in_queue" -gt 0 && "$lisa_in_queue" -gt 0 ]]; then
    log_result "11" "PASS" "Both employees appear in supervisor queue (David: $david_in_queue, Lisa: $lisa_in_queue)"
else
    log_result "11" "UNCERTAIN" "Queue visibility unclear (David: $david_in_queue, Lisa: $lisa_in_queue)"
fi

# SCENARIO 12: RECEIPT UPLOAD
echo "=== SCENARIO 12: RECEIPT UPLOAD ==="
receipt_trip=$(create_trip "$DAVID_TOKEN" "2026-11-01" "2026-11-03" "Receipt Test Trip" "Receipt City")
receipt_trip_id=$(echo "$receipt_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$receipt_trip_id" ]]; then
    # Create dummy receipt file
    echo "DUMMY RECEIPT CONTENT - Hotel Stay" > /tmp/receipt.txt

    receipt_result=$(curl -s -X POST "$BASE_URL/api/expenses" \
        -H "Authorization: Bearer $DAVID_TOKEN" \
        -F "trip_id=$receipt_trip_id" \
        -F "date=2026-11-02" \
        -F "expense_type=hotel" \
        -F "amount=150.00" \
        -F "description=Hotel with receipt" \
        -F "receipt=@/tmp/receipt.txt")

    echo "Receipt upload result: $receipt_result"
    if [[ "$receipt_result" == *"id"* ]]; then
        log_result "12" "PASS" "Receipt upload successful: $receipt_result"
    else
        log_result "12" "FAIL" "Receipt upload failed: $receipt_result"
    fi
else
    log_result "12" "FAIL" "Failed to create trip for receipt test"
fi

# SCENARIO 13: VEHICLE CALCULATION
echo "=== SCENARIO 13: VEHICLE CALCULATION ==="
vehicle_trip=$(create_trip "$DAVID_TOKEN" "2026-12-01" "2026-12-03" "Vehicle Test Trip" "Vehicle City")
vehicle_trip_id=$(echo "$vehicle_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$vehicle_trip_id" ]]; then
    vehicle_result=$(add_expense "$DAVID_TOKEN" "$vehicle_trip_id" "2026-12-02" "vehicle_km" "68.00" "100km drive (100 × $0.68)")
    echo "Vehicle result: $vehicle_result"
    if [[ "$vehicle_result" == *"id"* ]]; then
        log_result "13" "PASS" "Vehicle calculation accepted (100km × $0.68 = $68.00): $vehicle_result"
    else
        log_result "13" "FAIL" "Vehicle calculation rejected: $vehicle_result"
    fi
else
    log_result "13" "FAIL" "Failed to create trip for vehicle test"
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

echo "Invalid token result: $invalid_token_result"
if [[ "$invalid_token_result" == *"401"* || "$invalid_token_result" == *"Unauthorized"* || "$invalid_token_result" == *"token"* || "$invalid_token_result" == *"Authentication required"* ]]; then
    log_result "14" "PASS" "Invalid token rejected: $invalid_token_result"
else
    log_result "14" "FAIL" "Invalid token accepted: $invalid_token_result"
fi

# SCENARIO 15: DOUBLE SUBMIT
echo "=== SCENARIO 15: DOUBLE SUBMIT ==="
double_trip=$(create_trip "$DAVID_TOKEN" "2027-01-01" "2027-01-03" "Double Submit Test" "Double City")
double_trip_id=$(echo "$double_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$double_trip_id" ]]; then
    add_expense "$DAVID_TOKEN" "$double_trip_id" "2027-01-02" "lunch" "29.75" "Test lunch for double submit"

    first_submit=$(submit_trip "$DAVID_TOKEN" "$double_trip_id")
    second_submit=$(submit_trip "$DAVID_TOKEN" "$double_trip_id")
    
    echo "First submit: $first_submit"
    echo "Second submit: $second_submit"

    if [[ "$second_submit" == *"error"* || "$second_submit" == *"already"* ]]; then
        log_result "15" "PASS" "Double submit blocked: $second_submit"
    else
        log_result "15" "FAIL" "Double submit allowed. First: $first_submit, Second: $second_submit"
    fi
else
    log_result "15" "FAIL" "Failed to create trip for double submit test"
fi

# SCENARIO 16: LARGE DESCRIPTION
echo "=== SCENARIO 16: LARGE DESCRIPTION ==="
large_trip=$(create_trip "$DAVID_TOKEN" "2027-02-01" "2027-02-03" "Large Description Test" "Large City")
large_trip_id=$(echo "$large_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$large_trip_id" ]]; then
    # Generate 1000+ character description
    large_desc=$(printf '%0.s!' {1..1200})
    large_desc_result=$(add_expense "$DAVID_TOKEN" "$large_trip_id" "2027-02-02" "lunch" "29.75" "$large_desc")
    
    echo "Large description result: ${large_desc_result:0:200}..."
    if [[ "$large_desc_result" == *"id"* ]]; then
        log_result "16" "PASS" "Large description accepted (1200+ chars)"
    elif [[ "$large_desc_result" == *"error"* ]]; then
        log_result "16" "PASS" "Large description properly rejected: ${large_desc_result:0:200}"
    else
        log_result "16" "UNCERTAIN" "Large description result unclear: ${large_desc_result:0:200}"
    fi
else
    log_result "16" "FAIL" "Failed to create trip for large description test"
fi

# SCENARIO 17: NEGATIVE AMOUNT
echo "=== SCENARIO 17: NEGATIVE AMOUNT ==="
neg_trip=$(create_trip "$DAVID_TOKEN" "2027-03-01" "2027-03-03" "Negative Test Trip" "Negative City")
neg_trip_id=$(echo "$neg_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$neg_trip_id" ]]; then
    neg_result=$(add_expense "$DAVID_TOKEN" "$neg_trip_id" "2027-03-02" "lunch" "-29.75" "Negative amount test")
    echo "Negative result: $neg_result"
    if [[ "$neg_result" == *"error"* || "$neg_result" == *"amount"* || "$neg_result" == *"positive"* ]]; then
        log_result "17" "PASS" "Negative amount rejected: $neg_result"
    else
        log_result "17" "FAIL" "Negative amount accepted: $neg_result"
    fi
else
    log_result "17" "FAIL" "Failed to create trip for negative amount test"
fi

# SCENARIO 18: ZERO AMOUNT
echo "=== SCENARIO 18: ZERO AMOUNT ==="
zero_trip=$(create_trip "$DAVID_TOKEN" "2027-04-01" "2027-04-03" "Zero Test Trip" "Zero City")
zero_trip_id=$(echo "$zero_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$zero_trip_id" ]]; then
    zero_result=$(add_expense "$DAVID_TOKEN" "$zero_trip_id" "2027-04-02" "lunch" "0.00" "Zero amount test")
    echo "Zero result: $zero_result"
    if [[ "$zero_result" == *"error"* ]]; then
        log_result "18" "PASS" "Zero amount rejected: $zero_result"
    elif [[ "$zero_result" == *"id"* ]]; then
        log_result "18" "UNCERTAIN" "Zero amount accepted - may be valid: $zero_result"
    else
        log_result "18" "FAIL" "Zero amount result unclear: $zero_result"
    fi
else
    log_result "18" "FAIL" "Failed to create trip for zero amount test"
fi

# SCENARIO 19: MISSING REQUIRED FIELDS
echo "=== SCENARIO 19: MISSING REQUIRED FIELDS ==="
missing_trip=$(create_trip "$DAVID_TOKEN" "2027-05-01" "2027-05-03" "Missing Fields Test" "Missing City")
missing_trip_id=$(echo "$missing_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$missing_trip_id" ]]; then
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

    echo "Missing date: $missing1"
    echo "Missing type: $missing2"  
    echo "Missing amount: $missing3"

    errors=0
    [[ "$missing1" == *"error"* ]] && ((errors++))
    [[ "$missing2" == *"error"* ]] && ((errors++))
    [[ "$missing3" == *"error"* ]] && ((errors++))

    if [[ $errors -eq 3 ]]; then
        log_result "19" "PASS" "Missing required fields properly rejected (all 3 failed)"
    elif [[ $errors -gt 0 ]]; then
        log_result "19" "PARTIAL" "Some missing fields rejected ($errors/3). M1: ${missing1:0:100}, M2: ${missing2:0:100}, M3: ${missing3:0:100}"
    else
        log_result "19" "FAIL" "Missing fields not properly validated. All requests succeeded"
    fi
else
    log_result "19" "FAIL" "Failed to create trip for missing fields test"
fi

# SCENARIO 20: TRIP DATE VALIDATION
echo "=== SCENARIO 20: TRIP DATE VALIDATION ==="
date_trip=$(create_trip "$DAVID_TOKEN" "2027-06-01" "2027-06-03" "Date Validation Test" "Date City")
date_trip_id=$(echo "$date_trip" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [[ -n "$date_trip_id" ]]; then
    # Try expense outside trip range (before)
    before_result=$(add_expense "$DAVID_TOKEN" "$date_trip_id" "2027-05-31" "lunch" "29.75" "Before trip dates")
    # Try expense outside trip range (after)  
    after_result=$(add_expense "$DAVID_TOKEN" "$date_trip_id" "2027-06-04" "dinner" "47.05" "After trip dates")
    
    echo "Before trip range: $before_result"
    echo "After trip range: $after_result"
    
    before_blocked=$([[ "$before_result" == *"error"* || "$before_result" == *"date"* ]] && echo "yes" || echo "no")
    after_blocked=$([[ "$after_result" == *"error"* || "$after_result" == *"date"* ]] && echo "yes" || echo "no")
    
    if [[ "$before_blocked" == "yes" && "$after_blocked" == "yes" ]]; then
        log_result "20" "PASS" "Expenses outside trip date range properly rejected"
    elif [[ "$before_blocked" == "yes" || "$after_blocked" == "yes" ]]; then
        log_result "20" "PARTIAL" "Some date validation working. Before blocked: $before_blocked, After blocked: $after_blocked"
    else
        log_result "20" "FAIL" "Expenses outside trip date range were accepted"
    fi
else
    log_result "20" "FAIL" "Failed to create trip for date validation test"
fi

echo "All scenarios tested. Results written to $RESULTS_FILE"

# Clean up temp file
rm -f /tmp/receipt.txt