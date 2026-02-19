# Overnight Optimization Plan — 2026-02-18

## Execution Order (SEQUENTIAL — one at a time)

### Phase 1: Backup & Audit (NO CODE CHANGES)
- Git tag backup
- Document all screens, workflows, API endpoints
- Note known bugs, incomplete features, TODOs
- Map file/folder structure
- Output audit report

### Phase 2: Code Cleanup & Solidification
- Remove dead code
- Consistent naming conventions
- Error handling audit (try/catch, form validation, edge cases)
- Extract duplicated logic into utilities
- File organization
- Remove hardcoded secrets
- Verify nothing broken

### Phase 3: Workflow Testing & Validation
- Test ALL workflows end-to-end
- Core expenses: create, edit, delete, submit, approve, reject, resubmit
- Trip expenses: create trip, AT flow, expense logging, submission blocking
- Edge cases: empty states, double-click, long text, invalid data, session expiry, permissions
- Document and fix issues

### Phase 4: Industry Benchmarking (Concur, Expensify, Navan)
- Compare submission experience, approval workflow, trip management, dashboard, mobile
- Create prioritized improvement list (quick wins, medium effort, future backlog)
- Implement ONLY quick wins

### Phase 5: Visual Polish & UI Consistency
- Spacing, padding, margins consistency
- Button styles, font sizes, color usage
- Status badges consistent everywhere
- Empty states with helpful CTAs
- Loading states (spinners/skeletons)
- Success toasts, confirmation dialogs
- Responsive check (mobile, tablet, desktop)

### Phase 6: Final Verification
- Full workflow retest
- Compare to Phase 1 audit
- Summary report of all changes
- Final git tag

## Rules
- Never delete features or change core logic without confirmation
- Backup before each phase (git tag)
- If unsure → document as recommendation, don't implement
- Stability > new features
- Running changelog of every modification
