# PanganKita Flutter Prototype Implementation Plan

**Document:** `docs/IMPLEMENTATION.md`
**Product:** PanganKita
**Status:** Flutter prototype conversion orchestrator
**Scope:** Accepted design → tested Flutter prototype using deterministic mock data
**Backend:** Explicitly out of scope for this plan

> This plan controls implementation order. It does not replace `PRD.md`,
> `docs/DESIGN.md`, or the repository `AGENTS.md` hierarchy.

## 1. Purpose

This document is the implementation director for converting the accepted
PanganKita product/design baseline into a maintainable Flutter prototype.

The six phases are intentionally incremental. Each phase must be completed,
reviewed, and pass the repository quality gate before Codex proceeds to the next
phase.

This plan is **not** the backend implementation plan.

## 2. Source-of-truth hierarchy

When instructions disagree, use:

1. `PRD.md` — product behavior, requirements, scope, state, safety, privacy.
2. Official PanganKita Brand Guidelines — visual identity.
3. `AGENTS.md` — repository-wide engineering rules.
4. `app/AGENTS.md` — Flutter-specific engineering rules.
5. `docs/DESIGN.md` — design orchestration.
6. Relevant `docs/design/instructions/*.md`.
7. Current `docs/implementation/phases/phase-XX-*.md`.
8. Matching HTML design reference.
9. Matching PNG screenshot as visual fallback.

A phase file narrows implementation scope; it does not override higher-level
product, brand, security, or engineering rules.

## 3. Prototype-only boundary

All six phases use deterministic mock data.

Included:

```text
Flutter architecture
theme/design system
consumer UI
reservation/pickup UI
merchant UI
mock repositories
deterministic fixtures
local prototype state transitions
responsive behavior
accessibility
tests
polish
```

Not included:

```text
real backend/API
database/PostgreSQL
production authentication server
payment gateway
real merchant onboarding/verification service
live reservation concurrency
real maps/location SDK
push notifications
production analytics
production deployment infrastructure
```

Do not introduce backend infrastructure during these phases unless this plan is
explicitly revised.

## 4. Phase order

| Phase | Focus | Primary result |
|---|---|---|
| 01 | Foundation | Theme, app shell, typed mock architecture, shared primitives |
| 02 | Consumer discovery | Discover + listing detail on mock data |
| 03 | Reservation & pickup | Reservation confirmation, active pickup, history/basic reservation flow |
| 04 | Business experience | Merchant dashboard, listing creation/management, reservation queue, pickup verification |
| 05 | Cross-cutting quality | Accessibility, responsive states, localization structure, error/loading/offline behavior |
| 06 | Prototype polish | End-to-end consistency, cleanup, test hardening, final prototype review |

Codex must not skip ahead because a later phase appears easy.

## 5. Per-phase execution rule

For every phase:

1. Read this file.
2. Read only the current phase file.
3. Read `AGENTS.md` and `app/AGENTS.md`.
4. Read only the relevant PRD sections.
5. Read `docs/DESIGN.md`.
6. Read only the relevant scoped design instruction files.
7. Read matching HTML reference first.
8. Inspect PNG only if a genuinely visual ambiguity remains.
9. Use Graphify first for non-trivial cross-file/architecture work as required by
   repository instructions.
10. Implement only current-phase scope.
11. Add/update tests for changed behavior.
12. Run the full quality gate.
13. Stop and report the result. Do not continue automatically.

## 6. HTML-first reference policy

Normal reference order:

```text
docs/design/reference/<screen>.html
        ↓
cheap/searchable layout + copy reference

docs/design/reference/<screen>.png
        ↓
fallback only for visual ambiguity
```

Do not load the original Stitch ZIP for normal implementation.

Do not port generated HTML/Tailwind literally into Flutter.

## 7. Mock-data architecture rule

UI widgets should not own fixture values directly.

Target shape:

```text
presentation
    ↓
typed model / view state
    ↓
repository contract
    ↓
mock repository / deterministic fixtures
```

Later backend integration should be able to replace the mock implementation
without redesigning feature widgets.

Do not build fake network/payment/auth infrastructure just to imitate
production.

## 8. Quality gate

Run from `app/` after every phase:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
dart run dart_code_linter:metrics analyze --fatal-style --fatal-performance --fatal-warnings lib
dart run dart_code_linter:metrics check-unused-code --analyze-private-members lib
dart run dart_code_linter:metrics check-unused-files lib
dart run dart_code_linter:metrics check-unnecessary-nullable lib
dart run dartrics analyze lib
flutter test --coverage
```

Then from repository root:

```powershell
git diff --check
```

A phase is not complete while any required command fails.

## 9. Commit discipline

Prefer one reviewable commit per completed phase or a small number of coherent
commits when the phase is too large for one safe change.

Suggested commit style:

```text
feat(app): establish prototype foundations
feat(app): implement consumer discovery flow
feat(app): implement reservation pickup flow
feat(app): implement merchant prototype flow
refactor(app): harden responsive accessible states
chore(app): polish Flutter prototype
```

Actual commit boundaries should follow the completed diff.

## 10. Stop conditions

Codex must stop and ask/report rather than guess when:

- PRD and design instructions conflict;
- a required reference is missing;
- a requested screen depends on undefined product behavior;
- food-safety wording requires unsupported assumptions;
- a later-phase feature is necessary to complete current scope;
- implementing the phase would require a real backend;
- a quality gate fails and the root cause is not understood;
- a proposed dependency materially changes architecture.

## 11. Completion definition

This implementation plan is complete only after Phase 06 passes.

Completion means:

- accepted consumer prototype flow exists;
- accepted merchant prototype flow exists;
- deterministic mock data drives screens;
- shared design system is in place;
- responsive/accessibility baseline is verified;
- required tests pass;
- no unsupported safety/environmental claims remain;
- no real backend is required for the demo;
- repository quality gate is green.

Backend/API work begins under a separate future implementation plan.
