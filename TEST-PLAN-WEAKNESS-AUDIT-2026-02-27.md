# ClaimFlow Weakness Audit Test Plan
**Date:** Feb 27, 2026  
**Purpose:** Identify system vulnerabilities and weaknesses before fixing
**Focus:** New employees, org setup, admin precision, audit trails, claim integrity

## Test Categories

### 1. New Employee Vulnerabilities (5 tests)
- **T1-NEW-01**: Create new employee → immediate expense claim (bypass training/setup?)
- **T1-NEW-02**: New employee with no manager assigned → approval workflow breaks?  
- **T1-NEW-03**: New employee creates AT before profile completion → data integrity?
- **T1-NEW-04**: Duplicate employee emails → authentication/authorization chaos?
- **T1-NEW-05**: New employee deletes themselves mid-workflow → orphaned records?

### 2. Admin Settings Precision (5 tests) 
- **T2-ADM-01**: Change per diem by $1 → rounding errors in calculations?
- **T2-ADM-02**: Set variance threshold to $0.01 → everything flags as variance?
- **T2-ADM-03**: Change per diem mid-AT → existing AT calculations wrong?
- **T2-ADM-04**: Negative per diem values → system breaks or accepts?
- **T2-ADM-05**: Extreme values ($99999) → UI/calculation overflow?

### 3. Audit Trail Gaps (5 tests)
- **T3-AUD-01**: Admin changes per diem → audit log captures old/new values?
- **T3-AUD-02**: Manager approves then unapproves → audit trail complete?
- **T3-AUD-03**: Employee edits submitted trip → changes tracked properly?
- **T3-AUD-04**: Bulk admin changes → individual audit entries or missed?
- **T3-AUD-05**: System errors during save → partial audit logs?

### 4. Claim Integrity Stress (5 tests)
- **T4-CLM-01**: Submit trip with $0 totals → validation catches or allows?
- **T4-CLM-02**: Overlapping trip dates → system prevents or allows double-claim?
- **T4-CLM-03**: Claim expenses before AT approved → workflow violation?
- **T4-CLM-04**: Delete AT after trip submitted → orphaned trip data?
- **T4-CLM-05**: Manager changes AT after employee starts trip → sync issues?

## Expected Vulnerabilities
- **Data integrity**: Orphaned records, referential integrity
- **Validation gaps**: Edge cases, boundary conditions  
- **Audit completeness**: Missing change tracking
- **Workflow bypasses**: State transition violations
- **Precision errors**: Rounding, calculation drift

## Execution Plan
1. Deploy current HEAD to test environment
2. Run each test systematically  
3. Document EVERY weakness found
4. Report to Tony before fixing anything
5. Prioritize fixes by severity

**RULE: IDENTIFY FIRST, FIX SECOND**