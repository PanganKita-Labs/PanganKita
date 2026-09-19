# Phase 05 — Cross-Cutting Quality & State Hardening

**Status:** Blocked by Phase 04
**Scope:** Frontend prototype hardening
**Backend:** Out of scope

## Goal

Harden the existing prototype across accessibility, responsive behavior,
localization structure, and non-happy-path UI.

This phase should primarily improve the implementation already built. It should
not add major new product features.

## Required context

Read:

```text
AGENTS.md
app/AGENTS.md
docs/IMPLEMENTATION.md
this phase file
relevant PRD accessibility/localization/error/privacy/UI-state requirements
docs/DESIGN.md
docs/design/instructions/foundations.md
docs/design/instructions/components.md
docs/design/instructions/consumer.md
docs/design/instructions/business.md
docs/design/instructions/states-accessibility.md
docs/design/instructions/implementation.md
```

Read HTML references only for screens being changed.

Use PNG only for visual ambiguity.

Use Graphify first for broad cross-cutting refactors.

## In scope

Review and improve:

- 320 logical px width;
- 360 width;
- 390 width;
- 412 width;
- text scaling;
- safe areas;
- keyboard/insets;
- long Indonesian strings;
- long merchant names/addresses;
- loading;
- empty;
- recoverable error;
- offline/stale representation where meaningful;
- disabled states;
- semantics labels;
- focus order where applicable;
- touch-target sizes;
- contrast;
- non-color status cues;
- reduced-motion behavior where motion exists;
- centralized localization/string structure;
- navigation consistency;
- repeated component drift;
- error-message quality;
- state restoration expectations only where already required by prototype.

## Explicitly out of scope

Do not add:

- new backend;
- real connectivity service just to simulate offline;
- new major product areas;
- payment;
- maps SDK;
- push notifications;
- analytics;
- large architecture rewrite without demonstrated need.

## Responsive expectations

No page-level horizontal scrolling.

Critical content must remain visible:

- food name;
- price;
- pickup deadline;
- reservation state;
- pickup code;
- merchant name;
- primary CTA.

Do not solve narrow widths by shrinking important text below usable sizes.

## Accessibility expectations

Check:

- semantics for meaningful icons/controls;
- accessible button labels;
- no color-only urgency/status;
- touch targets around 48×48 where practical;
- text scale without clipping;
- meaningful error text;
- logical reading order.

## Localization structure

Primary language remains Bahasa Indonesia.

Prepare clean string organization for eventual English without requiring full
English translation in this phase unless already planned.

Do not scatter new user-facing literals throughout widgets.

## Error/state discipline

Each meaningful data-backed screen should behave intentionally under:

```text
loading
data
empty
error
```

Offline/stale distinction should be represented only where it adds honest value
to the mock prototype.

Do not fake server authority.

## Required tests

Expand tests around:

- narrow-layout rendering without overflow;
- selected larger text scale;
- empty/error state rendering;
- important semantic labels where practical;
- critical navigation under changed states;
- component/state regressions found during review.

Avoid brittle pixel-perfect golden testing unless the repository has already
chosen that strategy.

## Acceptance criteria

- no known overflow at target widths;
- critical screens survive larger text;
- primary controls are accessible;
- states are explicit and consistent;
- localization structure is ready for future expansion;
- UI duplication is reduced where it was causing drift;
- no major feature creep;
- full quality gate passes.

## Exit criteria

Run the full quality gate.

Report remaining known prototype limitations.

Stop before Phase 06 unless explicitly instructed to continue.
