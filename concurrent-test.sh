#!/bin/bash
BASE="https://claimflow-e0za.onrender.com"
RESULTS=""

log() { RESULTS+="$1\n"; }

# Phase 1: Login all 4 users
echo "=== Phase 1: Login ==="
ANNA_RESP=$(curl -s -X POST "$BASE/api/login" -H 'Content-Type: application/json' -d '{"email":"anna.lee@company.com","password":"anna123"}')
MIKE_RESP=$(curl -s -X POST "$BASE/api/login" -H 'Content-Type: application/json' -d '{"email":"mike.davis@company.com","password":"mike123"}')
LISA_RESP=$(curl -s -X POST "$BASE/api/login" -H 'Content-Type: application/json' -d '{"email":"lisa.brown@company.com","password":"lisa123"}')
JOHN_RESP=$(curl -s -X POST "$BASE/api/login" -H 'Content-Type: application/json' -d '{"email":"john.smith@company.com","password":"manager123"}')

echo "Anna: $ANNA_RESP"
echo "Mike: $MIKE_RESP"
echo "Lisa: $LISA_RESP"
echo "John: $JOHN_RESP"

ANNA_TOKEN=$(echo "$ANNA_RESP" | jq -r '.sessionId // .token // empty')
MIKE_TOKEN=$(echo "$MIKE_RESP" | jq -r '.sessionId // .token // empty')
LISA_TOKEN=$(echo "$LISA_RESP" | jq -r '.sessionId // .token // empty')
JOHN_TOKEN=$(echo "$JOHN_RESP" | jq -r '.sessionId // .token // empty')

echo "Tokens: ANNA=$ANNA_TOKEN MIKE=$MIKE_TOKEN LISA=$LISA_TOKEN JOHN=$JOHN_TOKEN"
