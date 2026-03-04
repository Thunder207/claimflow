#!/bin/bash
BASE="https://claimflow-e0za.onrender.com"
RESULTS="/Users/tony/.openclaw/workspace/expense-app/stress-results-raw.txt"
> "$RESULTS"

log() { echo "$@" | tee -a "$RESULTS"; }

# Step 1: Get auth tokens (try both endpoints)
log "=== AUTHENTICATION ==="
for EP in "/api/auth/login" "/api/login"; do
  R=$(curl -s -X POST "$BASE$EP" -H 'Content-Type: application/json' -d '{"email":"anna.lee@company.com","password":"anna123"}')
  log "Endpoint $EP: $R"
  if echo "$R" | jq -r '.sessionId' 2>/dev/null | grep -v null | grep -q .; then
    log "Using endpoint: $EP"
    LOGIN_EP="$EP"
    break
  fi
done

if [ -z "$LOGIN_EP" ]; then
  log "FATAL: Cannot find login endpoint"
  exit 1
fi

ANNA=$(curl -s -X POST "$BASE$LOGIN_EP" -H 'Content-Type: application/json' -d '{"email":"anna.lee@company.com","password":"anna123"}' | jq -r '.sessionId')
MIKE=$(curl -s -X POST "$BASE$LOGIN_EP" -H 'Content-Type: application/json' -d '{"email":"mike.davis@company.com","password":"mike123"}' | jq -r '.sessionId')
LISA=$(curl -s -X POST "$BASE$LOGIN_EP" -H 'Content-Type: application/json' -d '{"email":"lisa.brown@company.com","password":"lisa123"}' | jq -r '.sessionId')
JOHN=$(curl -s -X POST "$BASE$LOGIN_EP" -H 'Content-Type: application/json' -d '{"email":"john.smith@company.com","password":"manager123"}' | jq -r '.sessionId')

log "ANNA=$ANNA"
log "MIKE=$MIKE"
log "LISA=$LISA"
log "JOHN=$JOHN"

# Discover available endpoints first
log ""
log "=== ENDPOINT DISCOVERY ==="
for path in /api/my-expenses /api/expense-claims /api/pending-expenses /api/expenses /api/settings/transit /api/transit-claims /api/travel-authorizations /api/hwa-claims /api/receipts /api/dashboard /api/users /api/employees; do
  CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE$path" -H "Authorization: Bearer $ANNA")
  log "GET $path -> $CODE"
done

log ""
log "=== PHASE 1: LOAD & THROUGHPUT ==="

# S1.1: 50 rapid expense claims
log "--- S1.1: 50 rapid expense claims ---"
TMPDIR=$(mktemp -d)
for i in $(seq 1 50); do
  (
    CODE=$(curl -s -o "$TMPDIR/resp_$i.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
      -H "Authorization: Bearer $ANNA" \
      -H "Content-Type: application/json" \
      -d "{\"purpose\":\"Stress Test $i\",\"date\":\"2026-03-03\",\"items\":[{\"category\":\"Purchase/Supply\",\"amount\":$((i+10)),\"km\":0,\"vendor\":\"Vendor$i\",\"description\":\"Stress item $i\",\"expense_type\":\"purchase\"}]}")
    echo "$i:$CODE" >> "$TMPDIR/codes.txt"
  ) &
done
wait
OK1=$(grep -c ":201\|:200" "$TMPDIR/codes.txt" 2>/dev/null || echo 0)
FAIL1=$(grep -vc ":201\|:200" "$TMPDIR/codes.txt" 2>/dev/null || echo 0)
log "S1.1: $OK1 success, $FAIL1 failed out of 50"
cat "$TMPDIR/codes.txt" | sort -t: -k1 -n | head -5 >> "$RESULTS"
cat "$TMPDIR/resp_1.txt" >> "$RESULTS" 2>/dev/null
log ""

# If JSON didn't work, try multipart
if [ "$OK1" -eq 0 ]; then
  log "JSON didn't work, trying multipart..."
  CODE=$(curl -s -o "$TMPDIR/mp_resp.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
    -H "Authorization: Bearer $ANNA" \
    -F "purpose=Stress Test MP" -F "date=2026-03-03" \
    -F 'items=[{"category":"Purchase/Supply","amount":50,"km":0,"vendor":"TestVendor","description":"MP test","expense_type":"purchase"}]')
  log "Multipart attempt: $CODE"
  cat "$TMPDIR/mp_resp.txt" >> "$RESULTS"
  log ""
fi

# S1.2: 100 logins in 60 seconds
log "--- S1.2: 100 rapid logins ---"
> "$TMPDIR/login_codes.txt"
for i in $(seq 1 100); do
  (
    CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE$LOGIN_EP" \
      -H 'Content-Type: application/json' \
      -d '{"email":"anna.lee@company.com","password":"anna123"}')
    echo "$CODE" >> "$TMPDIR/login_codes.txt"
  ) &
  if [ $((i % 20)) -eq 0 ]; then wait; fi
done
wait
OK2=$(grep -c "200" "$TMPDIR/login_codes.txt" 2>/dev/null || echo 0)
FAIL2=$(wc -l < "$TMPDIR/login_codes.txt")
FAIL2=$((FAIL2 - OK2))
log "S1.2: $OK2 success, $FAIL2 failed out of 100"

# S1.3: 20 concurrent from different users
log "--- S1.3: 20 concurrent from 4 users ---"
TOKENS=("$ANNA" "$MIKE" "$LISA" "$JOHN")
> "$TMPDIR/multi_codes.txt"
for i in $(seq 1 20); do
  T=${TOKENS[$((i % 4))]}
  (
    CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
      -H "Authorization: Bearer $T" \
      -H "Content-Type: application/json" \
      -d "{\"purpose\":\"Multi User $i\",\"date\":\"2026-03-03\",\"items\":[{\"category\":\"Other\",\"amount\":$((i*5)),\"km\":0,\"vendor\":\"V$i\",\"description\":\"Multi $i\",\"expense_type\":\"other\"}]}")
    echo "$CODE" >> "$TMPDIR/multi_codes.txt"
  ) &
done
wait
OK3=$(grep -c "200\|201" "$TMPDIR/multi_codes.txt" 2>/dev/null || echo 0)
log "S1.3: $OK3 success out of 20"

# S1.4: 50 concurrent GETs
log "--- S1.4: 50 concurrent GETs ---"
> "$TMPDIR/get_codes.txt"
for i in $(seq 1 50); do
  (
    CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/api/my-expenses" -H "Authorization: Bearer $ANNA")
    echo "$CODE" >> "$TMPDIR/get_codes.txt"
  ) &
done
wait
OK4=$(grep -c "200" "$TMPDIR/get_codes.txt" 2>/dev/null || echo 0)
log "S1.4: $OK4 success out of 50"

# S1.7: Claim with 50 line items
log "--- S1.7: 50 line items in one claim ---"
ITEMS="["
for i in $(seq 1 50); do
  [ $i -gt 1 ] && ITEMS="$ITEMS,"
  ITEMS="$ITEMS{\"category\":\"Other\",\"amount\":$i,\"km\":0,\"vendor\":\"V$i\",\"description\":\"Item $i\",\"expense_type\":\"other\"}"
done
ITEMS="$ITEMS]"
CODE=$(curl -s -o "$TMPDIR/big_claim.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d "{\"purpose\":\"50 Items Test\",\"date\":\"2026-03-03\",\"items\":$ITEMS}")
log "S1.7: HTTP $CODE"
head -c 200 "$TMPDIR/big_claim.txt" >> "$RESULTS"
log ""

# S1.8: 10KB description
log "--- S1.8: 10KB description ---"
LONGDESC=$(python3 -c "print('A'*10000)")
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d "{\"purpose\":\"$LONGDESC\",\"date\":\"2026-03-03\",\"items\":[{\"category\":\"Other\",\"amount\":10,\"km\":0,\"vendor\":\"V\",\"description\":\"test\",\"expense_type\":\"other\"}]}")
log "S1.8: HTTP $CODE"

# S1.11: Unicode bomb
log "--- S1.11: Unicode bomb ---"
CODE=$(curl -s -o "$TMPDIR/unicode.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d '{"purpose":"Unicode Test","date":"2026-03-03","items":[{"category":"Other","amount":10,"km":0,"vendor":"🔥中文العربية‮RTL‬emoji🎉","description":"Unicode test","expense_type":"other"}]}')
log "S1.11: HTTP $CODE"
head -c 200 "$TMPDIR/unicode.txt" >> "$RESULTS"
log ""

# S1.12: 50 concurrent sessions same user
log "--- S1.12: 50 concurrent sessions ---"
> "$TMPDIR/sess_tokens.txt"
for i in $(seq 1 50); do
  (
    TOK=$(curl -s -X POST "$BASE$LOGIN_EP" -H 'Content-Type: application/json' \
      -d '{"email":"anna.lee@company.com","password":"anna123"}' | jq -r '.sessionId')
    echo "$TOK" >> "$TMPDIR/sess_tokens.txt"
  ) &
  if [ $((i % 10)) -eq 0 ]; then wait; fi
done
wait
UNIQUE=$(sort -u "$TMPDIR/sess_tokens.txt" | grep -v null | wc -l)
TOTAL=$(wc -l < "$TMPDIR/sess_tokens.txt")
log "S1.12: $TOTAL sessions, $UNIQUE unique tokens"

log ""
log "=== PHASE 2: SECURITY ==="

# S2.1: No auth
log "--- S2.1: No auth header ---"
for ep in /api/my-expenses /api/pending-expenses /api/expense-claims /api/settings/transit; do
  CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE$ep")
  log "No auth $ep -> $CODE"
done

# S2.2: Invalid token
log "--- S2.2: Invalid token ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/api/my-expenses" -H "Authorization: Bearer fake-token-12345")
log "S2.2: HTTP $CODE"

# S2.3: Employee accesses admin settings
log "--- S2.3: Employee writes admin settings ---"
CODE=$(curl -s -o "$TMPDIR/admin_set.txt" -w "%{http_code}" -X PUT "$BASE/api/settings/transit" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d '{"monthly_pass_amount":999}')
log "S2.3: HTTP $CODE"
cat "$TMPDIR/admin_set.txt" >> "$RESULTS"
log ""

# S2.4: Employee approves own expense - need to find anna's expense ID first
log "--- S2.4: Self-approve ---"
ANNA_EXPENSES=$(curl -s "$BASE/api/my-expenses" -H "Authorization: Bearer $ANNA")
ANNA_EXP_ID=$(echo "$ANNA_EXPENSES" | jq -r '.[0].id // .[0].expense_id // .expenses[0].id // .data[0].id // empty' 2>/dev/null)
log "Anna expense ID: $ANNA_EXP_ID"
if [ -n "$ANNA_EXP_ID" ]; then
  CODE=$(curl -s -o "$TMPDIR/self_approve.txt" -w "%{http_code}" -X POST "$BASE/api/expenses/$ANNA_EXP_ID/approve" \
    -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json")
  log "S2.4 self-approve: HTTP $CODE"
  cat "$TMPDIR/self_approve.txt" >> "$RESULTS"
  log ""
fi

# S2.5: Cross-user data access
log "--- S2.5: Cross-user access ---"
MIKE_EXPENSES=$(curl -s "$BASE/api/my-expenses" -H "Authorization: Bearer $MIKE")
MIKE_EXP_ID=$(echo "$MIKE_EXPENSES" | jq -r '.[0].id // .[0].expense_id // .expenses[0].id // .data[0].id // empty' 2>/dev/null)
if [ -n "$MIKE_EXP_ID" ]; then
  CROSS=$(curl -s "$BASE/api/expenses/$MIKE_EXP_ID" -H "Authorization: Bearer $ANNA")
  log "S2.5 Anna accessing Mike's expense $MIKE_EXP_ID: $(echo "$CROSS" | head -c 200)"
fi

# S2.8: SQL injection in login
log "--- S2.8: SQL injection ---"
for PAYLOAD in "' OR 1=1 --" "'; DROP TABLE users;--" "\" OR \"\"=\"" "admin'--"; do
  CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE$LOGIN_EP" \
    -H 'Content-Type: application/json' \
    -d "{\"email\":\"$PAYLOAD\",\"password\":\"x\"}")
  log "SQLi '$PAYLOAD' -> $CODE"
done

# S2.9: XSS in purpose
log "--- S2.9-S2.10: XSS attacks ---"
CODE=$(curl -s -o "$TMPDIR/xss.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d '{"purpose":"<script>alert(\"xss\")</script>","date":"2026-03-03","items":[{"category":"Other","amount":10,"km":0,"vendor":"<img onerror=alert(1) src=x>","description":"<svg onload=alert(1)>","expense_type":"other"}]}')
log "S2.9-10 XSS: HTTP $CODE"
cat "$TMPDIR/xss.txt" | head -c 300 >> "$RESULTS"
log ""

# S2.12: SQL in amount
log "--- S2.12: SQL in expense fields ---"
CODE=$(curl -s -o "$TMPDIR/sqli_exp.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d '{"purpose":"SQLi Test","date":"2026-03-03","items":[{"category":"Other","amount":"1; DROP TABLE expenses;--","km":0,"vendor":"test","description":"test","expense_type":"other"}]}')
log "S2.12: HTTP $CODE"

# S2.13: SQL in query params
log "--- S2.13: SQL in query params ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/api/my-expenses?status=' UNION SELECT * FROM employees--" -H "Authorization: Bearer $ANNA")
log "S2.13: HTTP $CODE"

# S2.14: Path traversal
log "--- S2.14: Path traversal ---"
for P in "../../../etc/passwd" "..%2F..%2F..%2Fetc%2Fpasswd" "....//....//etc/passwd"; do
  CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/api/receipts/$P" -H "Authorization: Bearer $ANNA")
  log "Path traversal '$P' -> $CODE"
done

# S2.16: JSON injection
log "--- S2.16: JSON injection ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d '{"purpose":"JSON inj","date":"2026-03-03","items":[{"category":"Other","amount":10,"km":0,"vendor":"test","description":"test","expense_type":"other","__proto__":{"admin":true},"constructor":{"prototype":{"isAdmin":true}}}]}')
log "S2.16 JSON injection: HTTP $CODE"

log ""
log "=== PHASE 3: DATA INTEGRITY ==="

# S3.1: Double approve
log "--- S3.1: Double approve ---"
# Get a pending expense
PENDING=$(curl -s "$BASE/api/pending-expenses" -H "Authorization: Bearer $JOHN")
log "Pending expenses sample: $(echo "$PENDING" | head -c 300)"
PEND_ID=$(echo "$PENDING" | jq -r '.[0].id // .[0].expense_id // .expenses[0].id // .data[0].id // empty' 2>/dev/null)
if [ -n "$PEND_ID" ]; then
  log "Double-approving expense $PEND_ID..."
  (curl -s -o "$TMPDIR/dbl1.txt" -w "%{http_code}" -X POST "$BASE/api/expenses/$PEND_ID/approve" \
    -H "Authorization: Bearer $JOHN" -H "Content-Type: application/json" > "$TMPDIR/dbl1_code.txt") &
  (curl -s -o "$TMPDIR/dbl2.txt" -w "%{http_code}" -X POST "$BASE/api/expenses/$PEND_ID/approve" \
    -H "Authorization: Bearer $JOHN" -H "Content-Type: application/json" > "$TMPDIR/dbl2_code.txt") &
  wait
  log "S3.1 Double approve: $(cat "$TMPDIR/dbl1_code.txt") / $(cat "$TMPDIR/dbl2_code.txt")"
  log "Resp1: $(cat "$TMPDIR/dbl1.txt" | head -c 200)"
  log "Resp2: $(cat "$TMPDIR/dbl2.txt" | head -c 200)"
fi

# S3.7: Expense totals
log "--- S3.7: Expense totals verification ---"
ALL_EXP=$(curl -s "$BASE/api/my-expenses" -H "Authorization: Bearer $ANNA")
log "My expenses sample: $(echo "$ALL_EXP" | head -c 500)"

log ""
log "=== PHASE 4: ERROR RECOVERY ==="

# S4.1: Empty POST body
log "--- S4.1: Empty POST body ---"
CODE=$(curl -s -o "$TMPDIR/empty.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json")
log "S4.1: HTTP $CODE - $(cat "$TMPDIR/empty.txt" | head -c 200)"

# S4.2: Missing required fields
log "--- S4.2: Missing required fields ---"
CODE=$(curl -s -o "$TMPDIR/missing.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d '{"purpose":"Missing items"}')
log "S4.2: HTTP $CODE - $(cat "$TMPDIR/missing.txt" | head -c 200)"

# S4.3: Invalid JSON
log "--- S4.3: Invalid JSON ---"
CODE=$(curl -s -o "$TMPDIR/badjson.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d '{not valid json at all}')
log "S4.3: HTTP $CODE - $(cat "$TMPDIR/badjson.txt" | head -c 200)"

# S4.4: Wrong content type
log "--- S4.4: Wrong content type ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: text/plain" \
  -d 'just plain text')
log "S4.4: HTTP $CODE"

# S4.5: Negative amount
log "--- S4.5: Negative amount ---"
CODE=$(curl -s -o "$TMPDIR/neg.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d '{"purpose":"Neg test","date":"2026-03-03","items":[{"category":"Other","amount":-50,"km":0,"vendor":"V","description":"neg","expense_type":"other"}]}')
log "S4.5: HTTP $CODE - $(cat "$TMPDIR/neg.txt" | head -c 200)"

# S4.6: Non-existent expense ID
log "--- S4.6: Non-existent ID ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE/api/expenses/999999/approve" \
  -H "Authorization: Bearer $JOHN" -H "Content-Type: application/json")
log "S4.6: HTTP $CODE"

# S4.7: Invalid date
log "--- S4.7: Invalid date ---"
CODE=$(curl -s -o "$TMPDIR/baddate.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d '{"purpose":"Bad date","date":"not-a-date","items":[{"category":"Other","amount":10,"km":0,"vendor":"V","description":"test","expense_type":"other"}]}')
log "S4.7: HTTP $CODE - $(cat "$TMPDIR/baddate.txt" | head -c 200)"

# S4.8: 100K char purpose
log "--- S4.8: 100K char field ---"
HUGE=$(python3 -c "print('B'*100000)")
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" \
  -d "{\"purpose\":\"$HUGE\",\"date\":\"2026-03-03\",\"items\":[{\"category\":\"Other\",\"amount\":10,\"km\":0,\"vendor\":\"V\",\"description\":\"test\",\"expense_type\":\"other\"}]}")
log "S4.8: HTTP $CODE"

# S4.9: Recovery after bad request
log "--- S4.9: Recovery test ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/api/my-expenses" -H "Authorization: Bearer $ANNA")
log "S4.9: After all bad requests, normal GET -> HTTP $CODE"

log ""
log "=== PHASE 5: API COMPLETENESS ==="

# S5.1: All endpoints require auth
log "--- S5.1: Auth required on all endpoints ---"
for ep in /api/my-expenses /api/pending-expenses /api/expense-claims /api/settings/transit /api/transit-claims /api/travel-authorizations /api/hwa-claims /api/dashboard; do
  CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE$ep")
  log "No auth $ep -> $CODE"
done

# S5.4: Consistent error format
log "--- S5.4: Error format consistency ---"
ERR1=$(curl -s "$BASE/api/my-expenses")
ERR2=$(curl -s -X POST "$BASE$LOGIN_EP" -H 'Content-Type: application/json' -d '{"email":"bad","password":"bad"}')
log "Error format 1 (no auth): $(echo "$ERR1" | head -c 200)"
log "Error format 2 (bad login): $(echo "$ERR2" | head -c 200)"

# S5.5: No sensitive data in errors
log "--- S5.5: No sensitive data in errors ---"
ERR3=$(curl -s -X POST "$BASE/api/expense-claims" -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" -d '{bad}')
log "Error response: $(echo "$ERR3" | head -c 300)"
echo "$ERR3" | grep -qi "stack\|traceback\|at .*\.js\|node_modules\|sqlite\|postgres" && log "⚠️ SENSITIVE DATA IN ERROR!" || log "No sensitive data leaked"

# S5.6: CORS headers
log "--- S5.6: CORS headers ---"
CORS=$(curl -s -I -X OPTIONS "$BASE/api/my-expenses" -H "Origin: http://evil.com" -H "Access-Control-Request-Method: GET")
log "CORS headers: $(echo "$CORS" | grep -i 'access-control')"

# S5.7: Content-Type headers
log "--- S5.7: Content-Type headers ---"
CT=$(curl -s -I "$BASE/api/my-expenses" -H "Authorization: Bearer $ANNA" | grep -i content-type)
log "Content-Type for JSON endpoint: $CT"

# S5.10: Settings admin-only
log "--- S5.10: Settings admin-only ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$BASE/api/settings/transit" \
  -H "Authorization: Bearer $ANNA" -H "Content-Type: application/json" -d '{"amount":999}')
log "S5.10 Employee PUT settings: HTTP $CODE"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/api/settings/transit" -H "Authorization: Bearer $ANNA")
log "S5.10 Employee GET settings: HTTP $CODE"

log ""
log "=== PHASE 2 EXTRA: MIME spoofing, path traversal receipt ==="
# S2.15: MIME type spoofing - create a fake exe
echo 'MZ' > "$TMPDIR/malware.exe"
mv "$TMPDIR/malware.exe" "$TMPDIR/malware.jpg"
CODE=$(curl -s -o "$TMPDIR/mime_resp.txt" -w "%{http_code}" -X POST "$BASE/api/expense-claims" \
  -H "Authorization: Bearer $ANNA" \
  -F "purpose=MIME test" -F "date=2026-03-03" \
  -F 'items=[{"category":"Other","amount":10,"km":0,"vendor":"V","description":"test","expense_type":"other"}]' \
  -F "receipt=@$TMPDIR/malware.jpg")
log "S2.15 MIME spoofing: HTTP $CODE"

log ""
log "=== DONE ==="
log "Server health check: $(curl -s -o /dev/null -w "%{http_code}" "$BASE/api/my-expenses" -H "Authorization: Bearer $ANNA")"

# Cleanup
rm -rf "$TMPDIR"
