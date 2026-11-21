# Handoff

_Last updated: 2026-11-21 · Claude · cloud_

## Current goal
Returns desk for **A1 Essentials** (the live A1 team site, a1bmscteam.com). Built and pushed;
not merged, not deployed, migration not applied.

## Where the code is
- Live site source = `a1-crm` branch **`backup/sites-v234-source-20261120`** (Sites v234
  snapshot from the desktop, 2026-11-20). `a1-crm` `main` is old (Sept 26). Don't build on it.
- Returns work: `a1-crm` branch **`claude/essentials-returns`** (based on the v234 snapshot).
- Older first attempt on stale code: branch `claude/inspiring-hypatia-7mppb9` (superseded).

## Done (claude/essentials-returns)
- Migration `supabase/migrations/20261121150000_a1_estimate_returns.sql` (**not applied**):
  schema `a1_returns_private`, immutable returns numbered R+YYYYMM+4 digits, idempotent create,
  over-return check in the DB, access via `a1_numbering_private.require_estimate_creator()`.
  RPCs: `a1_create_estimate_return`, `a1_list_estimate_returns`, `a1_get_estimate_return`,
  `a1_estimate_returned_quantities`. Tested on local Postgres 16 with stubs.
- `/returns`, `/returns/new`, `/returns/[id]/warehouse`, `/returns/[id]/credit`. Returns tab in
  the Essentials sidebar, "New return" on Essentials home. `/returns/new?id=<estimate uuid>` opens
  an estimate directly. Not linked from the saved estimate page: that page is fingerprinted in
  `docs/legacy-route-wrappers.json`.
- Lookup by estimate number (`packet->>invoiceNumber`, e.g. E2026110012), with search fallback.
  Upload: A1 PDFs open the saved estimate via "Invoice number:"; QB PDFs are parsed in the
  browser (pdf.js). Rows are kept when qty × rate = amount.
- Sales tax refunded at the estimate's rate (same rounding as `estimateTotals`). Restocking fee
  per return. Credit = returned + tax − fee.
- Tests: 11 new; full suite 1248/1251 (the 3 failures were already there: frozen-baseline checks
  that need full git history). Lint has no new problems. Sites build OK. Browser QA done with a
  fake Supabase (desktop and phone).

## Decisions (from user)
- Both Workbench/Essentials and QuickBooks estimates. Inventory: paperwork only.
- Line edits: return qty, credit override, condition/reason. Restocking fee: $ per return.

## Next steps
- User: apply the migration in Supabase, then deploy the branch through the usual Sites process.
- Try a real QuickBooks estimate PDF and tune the parser if needed.
- Phone nav already overflowed before this change (Schedule/Assignments/Authorizations).
  The Returns tab adds 49px. Possible follow-up.
- Desktop Remote Control: the "Documents" folder shows as not usable from cloud sessions.
  Likely needs a Claude app update.

## Open questions
- Codex hook file format still unverified (see LOG 2026-11-13).
