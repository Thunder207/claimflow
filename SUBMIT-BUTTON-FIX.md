# Submit Trip Button Fix

## Root Cause
The click handler for `#btn-submit-trip` was attached inside a `DOMContentLoaded` event listener at the bottom of a large inline `<script>` block (line ~2782). Since the script is synchronous and at the end of `<body>`, the timing of `DOMContentLoaded` relative to handler registration was unreliable — the event could fire before the listener was fully registered in some browser/load scenarios.

## Fix Applied
- Replaced the `document.addEventListener('DOMContentLoaded', ...)` wrapper with an immediately-invoked function expression (IIFE) that attaches click handlers directly, since the DOM elements already exist by the time this code runs.
- Replaced debug `alert('Submitting...')` with `console.log()`.
- Kept legitimate error alerts (trip creation failures) intact.

## Verification
- `node test-e2e-runner.js`: **16/16 tests pass** (10 employee + 6 supervisor)
- Submit trip flow works end-to-end via API

## Date
2026-02-17
