# UI, Widgets & Presentation Architecture

Read `docs/ARCHITECTURE.md` first.

This document defines presentation-layer structure, widget boundaries,
navigation ownership, naming, utilities, and UI responsibility.

For visual rules, also read `docs/DESIGN.md` and the relevant scoped design
instructions.

## Presentation responsibility

Presentation may:

- render domain/view state;
- accept interaction;
- invoke feature operations;
- display loading/empty/error states;
- navigate at feature boundaries.

Presentation must not become authoritative for:

- inventory rules;
- reservation legality;
- payment truth;
- permissions;
- server-side concurrency.

A visual state is a representation, not domain authority.

## Page composition

A page should read like a composition of meaningful sections.

Prefer:

```text
Page
├── Header
├── Summary
├── Main content
└── Primary action
```

over one huge `build()` containing every concern.

Do not mechanically split every few lines into another widget.

## Widget extraction

Extract a widget when doing so improves:

- readability;
- reuse;
- testability;
- rebuild scope;
- ownership clarity.

Do not extract only to satisfy aesthetic file symmetry.

## Avoid giant build methods

Do not mix all of these inside one large `build()`:

- data lookup;
- domain mutation;
- formatting;
- navigation;
- state transition logic;
- complete page rendering.

Push domain/state behavior out of rendering code when it becomes meaningful.

## Shared widgets

A widget becomes shared only after reuse is real or immediately required.

Examples that may be genuinely shared:

```text
PriceText
PickupDeadline
StatusBadge
PrimaryButton
```

Do not move one-feature components into `shared/` preemptively.

## Navigation architecture

Navigation should be understandable from application composition.

Rules:

- keep route definitions sufficiently centralized;
- feature widgets should not know unrelated route internals;
- pass stable identifiers/models deliberately;
- avoid global navigation as a substitute for state ownership.

Do not build future deep-link infrastructure before the product needs it.

## Utilities and extensions

Use small helpers with one clear purpose.

Good examples:

```text
currency formatting
pickup-time formatting
small date helpers
```

Avoid catch-all utility files.

An extension should improve readability, not hide important domain behavior.

## Error presentation

Do not expose:

- raw HTTP exceptions;
- stack traces;
- internal implementation details.

Presentation should translate technical failures into understandable UI state.

Do not silently swallow unexpected failures.

## Naming

Prefer product-specific names.

Good:

```text
discover_page.dart
listing_card.dart
reservation_status.dart
pickup_deadline.dart
```

Avoid vague names where a precise concept exists:

```text
manager.dart
helper.dart
common.dart
misc.dart
handler.dart
data.dart
```

Follow Dart snake_case and configured lint rules.

## File responsibility

There is no universal arbitrary line limit.

Refactor when a file:

- owns unrelated responsibilities;
- is hard to navigate;
- contains repeated logic;
- is difficult to test;
- has excessive UI nesting;
- exposes multiple public concepts that should be separate.

Configured complexity/lint thresholds remain hard repository constraints.

## Generated Stitch code

Do not copy generated Stitch HTML/Tailwind into Flutter.

Use generated HTML as a low-cost design reference only.

Flutter implementation should be idiomatic, responsive, accessible, and
consistent with the architecture/design contracts.

## UI anti-patterns

Avoid:

- feature business rules inside button callbacks;
- fixture literals spread through widgets;
- hidden global state;
- one-off copies of reusable visual primitives;
- god widgets;
- giant screens with multiple unrelated responsibilities;
- navigation logic scattered through low-level components;
- view code that directly knows future API serialization formats.
