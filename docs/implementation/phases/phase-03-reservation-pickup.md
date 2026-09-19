# Phase 03 — Reservation & Pickup Prototype

**Status:** Blocked by Phase 02
**Scope:** Consumer reservation/pickup flow on local mock state
**Backend:** Out of scope

## Goal

Extend the consumer journey from Listing Detail through a coherent prototype
reservation and pickup experience.

Target prototype flow:

```text
Listing Detail
→ Reservation Confirmation
→ Reserved
→ Ready for Pickup
→ Active Pickup
→ Completed
```

The state is local/deterministic and must not pretend to be production
transaction authority.

## Required context

Read:

```text
AGENTS.md
app/AGENTS.md
docs/IMPLEMENTATION.md
this phase file
relevant PRD reservation/listing/payment-at-pickup/state-machine requirements
docs/DESIGN.md
docs/design/instructions/foundations.md
docs/design/instructions/components.md
docs/design/instructions/consumer.md
docs/design/instructions/states-accessibility.md
docs/design/instructions/implementation.md
docs/design/reference/active-reservation-pickup.html
```

PNG fallback:

```text
docs/design/reference/active-reservation-pickup.png
```

Use Graphify first for non-trivial state/navigation changes.

## In scope

Implement:

- reservation confirmation screen;
- deterministic local reservation creation;
- reservation quantity/summary;
- pay-at-pickup explanation;
- active reservation presentation;
- pickup status;
- pickup deadline;
- merchant/address;
- pickup code;
- QR visual placeholder only if implemented honestly;
- amount due at pickup;
- simple reservation history/basic Reservations tab;
- legal mock state transitions required for demo;
- cancellation where supported by the PRD/prototype rules;
- completion state;
- expired/no-show representation where useful to state coverage.

## Explicitly out of scope

Do not implement:

- payment gateway;
- actual QR scanning backend;
- real server-generated secure pickup token;
- real inventory locking;
- multi-device concurrency;
- push notifications;
- real merchant confirmation service;
- fraud prevention backend.

A prototype QR/code must be explicitly fixture/local state and not described as
production-secure.

## Payment wording

MVP prototype baseline:

```text
reserve in PanganKita
pay at pickup using the merchant's accepted method
```

Do not show:

```text
Payment complete
Paid through PanganKita
Wallet charged
```

unless the prototype state is explicitly demonstrating a later hypothetical
flow, which is not part of this phase.

## Reservation state integrity

Use valid state progression only.

At minimum:

```text
Reserved
Ready for Pickup
Completed
Cancelled
Expired / No-show
```

Do not allow UI to jump through contradictory states merely for convenience.

The local prototype state controller/repository should own the transition;
visual widgets should render it.

## Pickup screen hierarchy

Priority:

1. status;
2. absolute pickup deadline;
3. merchant;
4. location/address;
5. pickup code;
6. amount due;
7. instructions;
8. cancel/report where allowed.

Relative countdown may supplement absolute time but not replace it.

## Required tests

Test:

- reservation confirmation uses selected listing/quantity;
- confirmation creates deterministic local reservation state;
- reservation appears in Reservations;
- valid state transitions render correctly;
- pickup code/merchant/deadline/amount are bound to model state;
- cancellation/expiry behavior where implemented;
- completion changes the visible state once;
- invalid transition is prevented or handled.

## Acceptance criteria

- consumer can demonstrate a coherent reservation-to-pickup journey;
- no real backend is required;
- state transitions are centralized, typed, and testable;
- payment-at-pickup language is accurate;
- pickup code is clearly prototype/local;
- no unsupported CO2 or safety certification language;
- active pickup design matches accepted direction;
- full quality gate passes.

## Exit criteria

Run the full quality gate and stop.

Do not begin merchant implementation automatically.
