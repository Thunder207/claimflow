#!/bin/bash

# ClaimFlow Comprehensive Testing Script
echo "=== ClaimFlow Comprehensive Testing Script ==="
echo "Date: $(date)"
echo "URL: https://claimflow-e0za.onrender.com"

BASE_URL="https://claimflow-e0za.onrender.com"

# Function to login and get token
login_user() {
    local email=$1
    local password=$2
    local response=$(curl -s -X POST "$BASE_URL/api/auth/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$email\",\"password\":\"$password\"}")
    
    echo "$response" | sed -n 's/.*"sessionId":"\([^"]*\)".*/\1/p'
}

# Function to test API endpoint
test_api() {
    local method=$1
    local endpoint=$2
    local token=$3
    local data=$4
    local description=$5
    
    echo "Testing: $description"
    if [ "$method" = "POST" ] && [ -n "$data" ]; then
        response=$(curl -s -X POST "$BASE_URL$endpoint" \
            -H "Authorization: Bearer $token" \
            -H "Content-Type: application/json" \
            -d "$data")
    elif [ "$method" = "GET" ]; then
        response=$(curl -s "$BASE_URL$endpoint" \
            -H "Authorization: Bearer $token")
    elif [ "$method" = "PUT" ] && [ -n "$data" ]; then
        response=$(curl -s -X PUT "$BASE_URL$endpoint" \
            -H "Authorization: Bearer $token" \
            -H "Content-Type: application/json" \
            -d "$data")
    fi
    
    echo "Response: $response"
    echo ""
    
    # Return success/failure
    if [[ $response == *"success"* ]] || [[ $response == *"id"* ]] || [[ $response == *"name"* ]]; then
        echo "✅ PASS: $description"
        return 0
    else
        echo "❌ FAIL: $description"
        return 1
    fi
}

echo "=== Getting Session Tokens ==="

# Login all users
echo "Logging in Anna Lee..."
ANNA_TOKEN=$(login_user "anna.lee@company.com" "anna123")
echo "Anna Token: [$ANNA_TOKEN]"

echo "Logging in Lisa Brown..."
LISA_TOKEN=$(login_user "lisa.brown@company.com" "lisa123") 
echo "Lisa Token: [$LISA_TOKEN]"

echo "Logging in John Smith..."
JOHN_TOKEN=$(login_user "john.smith@company.com" "manager123")
echo "John Token: [$JOHN_TOKEN]"

echo "Logging in Sarah Johnson..."
SARAH_TOKEN=$(login_user "sarah.johnson@company.com" "sarah123")
echo "Sarah Token: [$SARAH_TOKEN]"

echo "Logging in Mike Davis..."
MIKE_TOKEN=$(login_user "mike.davis@company.com" "mike123")
echo "Mike Token: [$MIKE_TOKEN]"

echo "Logging in David Wilson..."
DAVID_TOKEN=$(login_user "david.wilson@company.com" "david123")
echo "David Token: [$DAVID_TOKEN]"

# Verify tokens work
echo -e "\n=== Verifying Tokens ==="
curl -s "$BASE_URL/api/auth/me" -H "Authorization: Bearer $ANNA_TOKEN"
echo ""

echo -e "\n=== SCENARIO 1: Happy Path — AT Submission to Payment ==="

# Step 1: Anna creates Travel Authorization
echo "Step 1: Creating Travel Authorization..."
AUTH_DATA='{
    "name": "Ottawa Client Meeting", 
    "destination": "Ottawa, ON",
    "start_date": "2026-03-10",
    "end_date": "2026-03-12", 
    "purpose": "Client meeting"
}'

AUTH_RESPONSE=$(curl -s -X POST "$BASE_URL/api/travel-auth" \
    -H "Authorization: Bearer $ANNA_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$AUTH_DATA")

echo "Auth Creation Response: $AUTH_RESPONSE"
AUTH_ID=$(echo "$AUTH_RESPONSE" | sed -n 's/.*"id":\([0-9]*\).*/\1/p')
echo "AUTH_ID: $AUTH_ID"

if [ -n "$AUTH_ID" ]; then
    echo "✅ PASS: Travel Authorization created with ID $AUTH_ID"
else
    echo "❌ FAIL: Could not create Travel Authorization"
    exit 1
fi

echo ""
echo "=== Testing complete for now - continuing with comprehensive testing... ==="