# Dropdown Fix Results — 2026-02-17

## Bug
The trip dropdown option text showed `0 expenses, $0.00` even when draft expenses existed for that trip. The `updateTripDropdownText()` function only counted draft expenses, ignoring server-side expense counts.

## Root Cause
`updateTripDropdownText()` calculated count/total from `draftTripExpenses` only, overwriting the combined server+draft counts that `loadTrips()` correctly set.

## Fix Applied
1. Added `serverTripData` global cache — populated during `loadTrips()` with each trip's server-side `expense_count` and `calculated_total`
2. Updated `updateTripDropdownText()` to combine `serverTripData[tripId]` counts with draft expense counts
3. Dropdown now shows accurate combined totals after:
   - Initial page load (drafts restored from localStorage)
   - Adding an expense to a trip
   - Removing an expense from a trip

## QA Validation

| Check | Result |
|-------|--------|
| E2E tests (test-e2e-runner.js) | ✅ 16/16 passed |
| JavaScript syntax | ✅ No errors |
| Balanced braces/parens/brackets | ✅ All balanced |
| Debug alerts | ✅ None found |
| Submit trip flow | ✅ Works (verified via E2E: create trip → add 5 expenses → submit → supervisor approve all) |
