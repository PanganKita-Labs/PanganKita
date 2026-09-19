# Phase 01 — Flutter Prototype Foundation

**Status:** Completed
**Scope:** Foundation only
**Backend:** Out of scope

## Goal

Establish the smallest clean Flutter foundation required for the later
PanganKita prototype screens.

At the end of this phase, the app should have a stable design/theme layer,
navigation shell, typed mock-data architecture, and a small set of shared UI
primitives. It should **not** contain the full consumer or merchant experience.

## Required context

Read:

```text
AGENTS.md
app/AGENTS.md
docs/IMPLEMENTATION.md
relevant PRD architecture / MVP / role / testing sections
docs/DESIGN.md
docs/design/instructions/foundations.md
docs/design/instructions/components.md
docs/design/instructions/states-accessibility.md
docs/design/instructions/implementation.md
```

HTML/PNG screen references are optional in this phase. Inspect only if needed to
validate foundational component direction.

Use Graphify first for non-trivial structural changes.

## In scope

- remove/replace the disposable Flutter counter scaffold where appropriate;
- establish app entry/root structure;
- establish centralized theme/design tokens;
- prepare Geist Sans + Satoshi integration only if licensing/assets are already
  valid and available;
- otherwise provide a safe fallback and leave a documented font integration
  seam without inventing font files;
- establish core navigation shell structure;
- establish role-aware prototype entry structure without production auth;
- establish typed feature/domain models needed by upcoming prototype screens;
- establish repository interfaces/contracts where useful;
- establish deterministic mock fixture source(s);
- establish simple local prototype state ownership;
- create a minimal set of shared components needed repeatedly;
- preserve strict linting and tests.

## Explicitly out of scope

Do not implement:

- full Discover;
- full Listing Detail;
- reservation confirmation;
- pickup code flow;
- merchant dashboard;
- create-listing form;
- real authentication;
- API clients;
- database;
- payment gateway;
- maps SDK;
- notification integration;
- analytics service.

Do not prebuild speculative abstractions for future backend services.

## Architecture constraints

Keep the architecture proportional to a small-team prototype.

Prefer clear feature boundaries over a deeply layered enterprise structure.

Target conceptual dependency direction:

```text
UI
↓
feature state/controller/view model where needed
↓
repository contract
↓
mock repository
↓
deterministic fixtures
```

Avoid:

```text
widget → giant global singleton
widget → hardcoded fixture strings everywhere
widget → fake HTTP client
```

## Design-system foundation

Centralize at minimum:

- brand colors;
- semantic colors;
- typography roles;
- spacing;
- radii;
- basic component theme defaults.

Do not scatter raw brand hex values through feature widgets.

Use official values from the design instructions.

## Minimum shared primitives

Create only primitives justified by near-term screens, such as:

- page scaffold;
- primary button;
- secondary button;
- status/urgency treatment;
- section heading;
- basic card surface;
- loading/empty/error shell if naturally shared.

Do not create a giant component library in advance.

## Mock-data rules

Fixtures must be:

- deterministic;
- plausible;
- clearly prototype-only;
- typed;
- reusable across later flows.

Do not imply fixture merchants/users are real.

Do not include unsupported CO2, zero-waste, or food-safety certification claims.

## Navigation baseline

Prepare navigation for the intended prototype destinations without necessarily
implementing all target screens yet.

Consumer target destinations:

```text
Discover
Reservations
Impact
Profile
```

Business target destinations:

```text
Listings
Reservations
Impact
Business
```

A placeholder destination is acceptable only when clearly temporary and when it
does not pretend the feature is implemented.

## Required tests

At minimum, test:

- app root builds;
- theme/root initialization succeeds;
- deterministic mock repository returns expected stable fixture(s);
- initial navigation destination is correct;
- role-aware shell behavior where implemented.

Do not write tests that only duplicate framework behavior.

## Acceptance criteria

- no default counter-demo behavior remains if foundation replacement makes it
  obsolete;
- project still starts cleanly;
- theme tokens are centralized;
- no raw duplicate brand colors are introduced across the foundation;
- mock data is not embedded directly in screen widgets;
- core model/repository seams are typed;
- no production backend dependency exists;
- strict analyzer/linter passes;
- tests pass.

## Exit criteria

Run the full quality gate from `docs/IMPLEMENTATION.md`.

Then stop.

Do not begin Phase 02 in the same Codex task unless the user explicitly requests
multiple phases together.
