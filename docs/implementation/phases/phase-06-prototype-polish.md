# Phase 06 — Prototype Integration & Polish

**Status:** Blocked by Phase 05
**Scope:** Final Flutter mock-data prototype integration
**Backend:** Out of scope

## Goal

Turn the completed phase work into one coherent, reviewable PanganKita Flutter
prototype ready for product validation and later backend planning.

This phase is integration and polish, not feature expansion.

## Required context

Read:

```text
AGENTS.md
app/AGENTS.md
docs/IMPLEMENTATION.md
this phase file
relevant PRD MVP/journey/quality/metrics sections
docs/DESIGN.md
all scoped design instructions that affect changed areas
```

Read only the HTML references for screens under review.

Use PNG references only where visual ambiguity remains.

Use Graphify for final cross-feature architecture inspection where required.

## In scope

Validate and polish:

### Consumer journey

```text
Discover
→ Listing Detail
→ Reservation Confirmation
→ Active Reservation / Pickup
→ Completed / History
```

### Merchant journey

```text
Dashboard
→ Create Listing
→ Publish
→ Manage Listing
→ Reservation Queue
→ Ready
→ Pickup Verification
→ Completed
```

### Cross-flow consistency

Review:

- shared fixture/model vocabulary;
- listing/reservation state consistency;
- navigation/back behavior;
- theme consistency;
- component reuse;
- copy consistency;
- mock-state reset/demo behavior;
- error/empty/loading consistency;
- business/account verification wording;
- payment-at-pickup wording;
- unsupported claim removal.

## Explicitly out of scope

Do not add:

- production backend;
- API integration;
- database;
- payment gateway;
- authentication server;
- live maps;
- push notifications;
- real analytics;
- delivery;
- donation/food-bank network;
- AI ranking/chatbot;
- nationwide operational systems.

Any desire for those belongs in the next implementation plan.

## Cleanup

Remove or resolve:

- dead demo code;
- unused prototype components;
- duplicate styling;
- stale fixtures;
- contradictory copy;
- temporary TODOs that should not survive the prototype baseline;
- unreachable placeholder screens;
- unused files;
- generated Stitch code accidentally copied into app source.

Keep deliberate future TODOs only when they have clear context.

## Design review

For each accepted reference screen verify:

- PanganKita identity is clear;
- hierarchy is recognizable;
- implementation is not noisier than the reference;
- primary CTA is obvious;
- price/deadline/location are easy to scan;
- accessibility/responsive behavior is stronger than static Stitch output.

Pixel-perfect reproduction is not required.

## Product-integrity review

Search the app for unsafe/unsupported language.

Do not ship prototype UI that claims:

```text
PanganKita food-safety certification
100% safe food
unsupported CO2 savings
zero-waste achieved
unsupported hunger reduction
real payment settlement
```

Verify dummy data is not presented as production evidence.

## Test hardening

Ensure tests cover the most important prototype journeys and state transitions.

Do not chase an arbitrary coverage percentage at the expense of meaningful
tests.

At minimum, critical tests should defend:

- app startup;
- discovery/listing selection;
- reservation creation;
- valid reservation state progression;
- merchant create-listing flow;
- merchant pickup completion;
- core empty/error state behavior;
- relevant model/repository invariants.

## Documentation cleanup

Update user/developer-facing prototype notes if necessary so a teammate can:

- run the app;
- understand mock-data behavior;
- understand what is intentionally not implemented;
- run quality checks.

Do not duplicate the PRD/design docs unnecessarily.

## Acceptance criteria

The prototype is ready when:

- consumer journey is demonstrable;
- merchant journey is demonstrable;
- deterministic mock data drives both;
- no real backend is required;
- major screens are responsive at target widths;
- accessibility baseline is in place;
- accepted visual direction is preserved;
- product-integrity wording is clean;
- dead demo code is removed;
- tests are meaningful and green;
- all quality checks pass.

## Final exit criteria

Run the full quality gate from `docs/IMPLEMENTATION.md`.

Also run:

```powershell
git diff --check
git status --short
```

Report:

- what the prototype now supports;
- what remains intentionally mock-only;
- any known limitations;
- any future backend integration seams;
- recommended next planning step.

Then stop.

The next workstream should be a **separate backend/API integration plan**, not
Phase 07 of this prototype-conversion plan.
