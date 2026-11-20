# Handoff

_Last updated: 2026-11-20 · Claude · cloud (restocking fee added)_

## Current goal
A1 CRM (`prateekmrai/a1-crm`): new **Returns** section. Built and pushed to branch
`claude/inspiring-hypatia-7mppb9`. Not merged, not deployed, no PR yet.

## Done (a1-crm)
- Migration `supabase/migrations/0009_returns.sql` (**not applied yet**): adds `estimate_number`
  (EST-1001…) and `pdf_sha256` to `estimate_packets`, plus a new `estimate_returns` table
  (manager-only RLS, RET-5001…, idempotent create key).
- `/returns/new`: enter estimate number OR upload PDF/photo → pick lines → return qty,
  credit override, condition (resellable/damaged/defective), reason → Process refund.
  - Workbench PDFs: exact (fingerprint match, or date+total+line-count match to a saved
    estimate, else read by column position). QuickBooks PDFs: best effort, rows kept only
    if qty × rate = amount; manager edits everything. Photos: preview + type lines by hand.
- `/returns`: saved returns home → **Warehouse slip** (inbound receiving slip, no prices,
  "DO NOT RESTOCK" for damaged/defective) and **Customer estimate** (original lines,
  returned credit lines, updated total).
- Saved estimates page shows EST numbers and "Start a return"; nav + office desk tile added.
- Verified: 69 tests, lint, typecheck, build; full click-through in Chromium on a local fake
  Supabase (desktop + phone).

## Decisions (from user)
- Estimates come from both Workbench and QuickBooks; uploads are mostly Workbench PDFs.
- Inventory: paperwork only. CRM does not change item counts; stock goes back in QuickBooks.
- Line edits: return qty, override credit amount, condition/reason.
- Restocking fee: editable dollar amount per return (varies by customer), default $0,
  subtracted from the customer's credit. Stored in `estimate_returns.restocking_fee`;
  `credit_total` = net credit. Not remembered per customer (could add a customer default later).

## Next steps
- User applies migration 0009 in Supabase (SQL editor), then deploy the branch.
- Test with a real QuickBooks estimate PDF; tune the parser if lines aren't picked up.
- Workbench PDFs downloaded *before* saving online don't carry the EST number on the page.

## Open questions
- Codex hook file format still unverified (see LOG 2026-11-13).
