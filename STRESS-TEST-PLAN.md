# ClaimFlow — Maximum Stress & Penetration Test Plan
**Date:** March 3, 2026  
**URL:** https://claimflow-e0za.onrender.com  
**Purpose:** Push every limit — load, security, data integrity, edge cases, error recovery

---

## Phase 1: Load & Throughput (12 tests)

### 1A: Rapid-Fire API Bombardment
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S1.1 | 50 expense claims in 30 seconds | 50 parallel curl POST requests from one user | All 50 created, unique IDs, no 500 errors | |
| S1.2 | 100 logins in 60 seconds | 100 simultaneous login requests | All succeed, unique session tokens | |
| S1.3 | 20 users submit simultaneously | 20 concurrent expense submissions (round-robin 4 accounts) | All succeed, correct employee attribution | |
| S1.4 | 50 GET requests at once | 50 parallel /api/my-expenses calls | All return 200, consistent data | |
| S1.5 | 10 PDF generations at once | 10 concurrent PDF download requests | All return valid PDFs or graceful queue | |
| S1.6 | Sustained load: 5 req/sec for 2 min | 600 mixed API calls over 2 minutes | <1% error rate, no crashes | |

### 1B: Payload Limits
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S1.7 | Claim with 50 line items | Single claim group with 50 items | Accepted or graceful limit error | |
| S1.8 | 10KB description field | Extremely long description text | Truncated or accepted, no crash | |
| S1.9 | 5MB receipt upload | Large image file as receipt | Compressed or rejected gracefully | |
| S1.10 | 100 claims in history | User with 100+ expenses, load history | Page loads, no timeout | |
| S1.11 | Unicode bomb in vendor | Vendor: emoji + Chinese + Arabic + RTL text | Stored and displayed safely | |
| S1.12 | Maximum concurrent sessions | Login same user 50 times | All sessions work or old ones invalidated | |

## Phase 2: Security & Injection (16 tests)

### 2A: Authentication & Authorization
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S2.1 | No auth header | Call /api/my-expenses without Authorization | 401 Unauthorized | |
| S2.2 | Invalid token | Use fake/expired session token | 401 Unauthorized | |
| S2.3 | Employee accesses admin settings | Anna calls PUT /api/settings/transit | 403 Forbidden | |
| S2.4 | Employee approves own expense | Anna calls POST /api/expenses/:id/approve on her own | Rejected | |
| S2.5 | Employee accesses other's data | Anna calls API with Mike's expense ID | Filtered/blocked | |
| S2.6 | Supervisor accesses other team | Lisa tries to approve John's team expenses | Blocked by hierarchy | |
| S2.7 | Token reuse after logout | Logout then use old token | 401 Unauthorized | |
| S2.8 | SQL in login email | Email: `' OR 1=1 --` | Login fails, no data leak | |

### 2B: Injection Attacks
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S2.9 | XSS in claim purpose | Purpose: `<script>alert('xss')</script>` | Sanitized, no script execution | |
| S2.10 | XSS in vendor field | Vendor: `<img onerror=alert(1) src=x>` | Sanitized in display | |
| S2.11 | XSS in rejection reason | Reason: `<script>document.cookie</script>` | Sanitized when shown to employee | |
| S2.12 | SQL injection in expense | Amount: `1; DROP TABLE expenses;--` | Rejected, DB intact | |
| S2.13 | SQL in search/filter | Query param: `' UNION SELECT * FROM employees--` | Rejected, no data leak | |
| S2.14 | Path traversal in receipt | Filename: `../../../etc/passwd` | Rejected, no file system access | |
| S2.15 | MIME type spoofing | Upload .exe renamed to .jpg | Rejected or stored safely (no execution) | |
| S2.16 | JSON injection in items | Items array with nested malicious JSON | Parsed safely, no injection | |

## Phase 3: Data Integrity Under Stress (12 tests)

### 3A: Race Conditions
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S3.1 | Double-approve same expense | Two approve requests 10ms apart | Only first succeeds, second gets "already processed" | |
| S3.2 | Approve + reject same expense | Approve and reject simultaneously | One wins, consistent final state | |
| S3.3 | Submit same transit month twice | Two POST /api/transit-claims for Jan simultaneously | One succeeds, one gets duplicate error | |
| S3.4 | HWA double-spend | Two $400 HWA claims simultaneously (balance $500) | One succeeds ($400), second rejected (only $100 left) or both fit | |
| S3.5 | Concurrent TA same dates | Same user creates two TAs for same dates | Overlap detected on one | |
| S3.6 | Edit while approving | Employee edits trip while supervisor approves | One operation wins cleanly | |

### 3B: Data Consistency
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S3.7 | Expense totals match | Sum individual expenses = dashboard total | Exact match | |
| S3.8 | HWA balance = max - (pending + approved) | Calculate manually vs API response | Exact match | |
| S3.9 | Claim group count matches | expense count in group = items submitted | Exact match | |
| S3.10 | Approved expenses in history | Count approved in employee view vs supervisor view | Match | |
| S3.11 | Receipt BLOB integrity | Upload receipt, retrieve it, compare size | Same file | |
| S3.12 | PDF contains all items | Generate PDF, count items vs database | Match | |

## Phase 4: Error Recovery & Resilience (10 tests)

### 4A: Malformed Requests
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S4.1 | Empty POST body | POST /api/expense-claims with no body | 400 Bad Request | |
| S4.2 | Missing required fields | POST expense claim without purpose | 400 with clear error message | |
| S4.3 | Invalid JSON in items | items: `{not valid json}` | 400 with parse error | |
| S4.4 | Wrong content type | POST with text/plain instead of multipart | 400 or appropriate error | |
| S4.5 | Negative amount | Submit expense with amount: -50 | Rejected | |
| S4.6 | Non-existent expense ID | POST /api/expenses/999999/approve | 404 Not Found | |
| S4.7 | Invalid date format | date: "not-a-date" | 400 or handled gracefully | |
| S4.8 | Extremely long string fields | 100,000 char purpose field | Truncated or rejected, no OOM | |

### 4B: Recovery
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S4.9 | App recovers after bad request | Send malformed request, then valid one | Valid request succeeds | |
| S4.10 | DB intact after injection attempt | Run SELECT count after SQL injection attempts | Same count as before | |

## Phase 5: API Completeness & Consistency (10 tests)
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S5.1 | All endpoints require auth | Hit every endpoint without token | All return 401 | |
| S5.2 | GET endpoints return JSON | All GET endpoints | Valid JSON responses | |
| S5.3 | POST endpoints validate input | All POST endpoints with empty body | 400 with error messages | |
| S5.4 | Consistent error format | All error responses | `{error: "message"}` or `{success: false, error: "message"}` | |
| S5.5 | No sensitive data in errors | Trigger errors | No stack traces, DB paths, or internal details exposed | |
| S5.6 | CORS headers correct | Check response headers | Appropriate CORS policy | |
| S5.7 | Content-Type headers correct | Check all responses | Correct content types (JSON, PDF, image) | |
| S5.8 | Receipt endpoint returns correct MIME | Fetch receipt | Content-Type matches actual file type | |
| S5.9 | PDF endpoint returns application/pdf | Fetch PDF | Content-Type: application/pdf | |
| S5.10 | Settings API admin-only | All settings endpoints as employee | 403 on write, read may vary | |

## Phase 6: Browser & Frontend Stress (8 tests)
| # | Test | Method | Expected | Pass/Fail |
|---|------|--------|----------|-----------|
| S6.1 | Rapid tab switching | Switch between Expenses/Travel Auth/Trips/History 20 times | No memory leak, no errors | |
| S6.2 | 20 line items in one claim | Add 20 line items to claim form | Form handles it, total correct | |
| S6.3 | localStorage full | Fill localStorage, try to add draft | Graceful error or still works | |
| S6.4 | Rapid Add to Draft | Add 10 drafts in 30 seconds | All 10 saved, total correct | |
| S6.5 | Back/forward navigation | Use browser back/forward | No broken state | |
| S6.6 | Double-click all buttons | Double-click every action button | No duplicate submissions | |
| S6.7 | Refresh during submission | Refresh while "Submitting..." | No partial state, can retry | |
| S6.8 | Session expires mid-use | Delete session from localStorage, try action | Redirect to login or clear error | |

---

## Total: 68 maximum stress tests across 6 phases

## Execution Strategy

### For API tests (Phases 1-5): Use curl/shell scripts
```bash
# Parallel execution pattern
for i in $(seq 1 50); do
  curl -s -X POST ... -H "Authorization: Bearer $TOKEN" &
done
wait
```

### For browser tests (Phase 6): Use browser automation

### For security tests (Phase 2): Manual curl with crafted payloads

## Success Criteria
- **Zero crashes** — server stays up through all tests
- **Zero data corruption** — all counts/totals match after stress
- **Zero security breaches** — no injection, no unauthorized access
- **<1% error rate** under sustained load
- **All error responses graceful** — no stack traces, no 500s on bad input
- **100% auth enforcement** — every endpoint rejects unauthorized calls

## Risk Assessment
After testing, categorize each finding:
- 🔴 **Critical** — data loss, security breach, crash
- 🟠 **High** — data integrity issue, auth bypass
- 🟡 **Medium** — bad UX under stress, slow response
- 🟢 **Low** — cosmetic, non-blocking
