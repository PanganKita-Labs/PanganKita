# Architecture Foundations

Read `docs/ARCHITECTURE.md` first.

This document defines the architectural principles used to evaluate structural
decisions in the PanganKita Flutter application.

## KISS

Prefer the smallest design that correctly solves the current requirement.

Complexity must be earned by a real problem.

Avoid turning one operation into:

```text
controller
→ service
→ use case
→ manager
→ adapter
→ gateway
→ repository
```

when a smaller structure is sufficient.

A simple class or function is often better than a pattern stack.

## YAGNI

Do not implement infrastructure because it may be useful later.

During the prototype, do not add without a current requirement:

- dependency-injection framework;
- event bus;
- generic networking framework;
- cache framework;
- offline database;
- WebSocket infrastructure;
- production auth infrastructure;
- payment abstraction;
- analytics abstraction;
- generic use-case framework;
- code generation.

Design cheap replacement seams where useful, but do not build the future system
in advance.

## DRY

Remove meaningful duplication, not all duplication.

> Duplication is sometimes cheaper than the wrong abstraction.

Prefer temporary duplication when:

- only two small implementations exist;
- their behavior may diverge;
- the abstraction needs many flags;
- the shared name would be vague;
- reuse is speculative.

Extract when:

- the concept is genuinely the same;
- behavior must remain consistent;
- reuse already exists;
- tests benefit from one stable boundary.

Do not build a generic abstraction merely because two blocks currently look
similar.

## SOLID

Apply SOLID pragmatically.

SOLID is a set of design tools, not a requirement to create an interface for
every class.

An abstraction is justified when it creates a real boundary such as:

- multiple meaningful implementations;
- external infrastructure;
- a useful test seam;
- a stable cross-feature contract;
- isolated domain behavior.

Do not create structures such as:

```text
ListingServiceInterface
ListingServiceImpl
ListingServiceFactory
ListingServiceProvider
```

when one focused implementation is sufficient.

## Composition over inheritance

Prefer composition for application behavior.

Framework inheritance such as:

```dart
StatelessWidget
StatefulWidget
```

is normal.

Avoid deep app-specific inheritance trees.

## Abstraction threshold

Before adding an abstraction, require at least one strong reason:

- multiple current implementations;
- meaningful repeated logic;
- external dependency boundary;
- test seam;
- isolated domain rule;
- stable public contract.

Weak reasons include:

```text
"clean architecture says so"
"we may need it later"
"the folder tree looks nicer"
"every class should have an interface"
"this looks more enterprise"
```

Do not abstract from fear of future change.

## Complexity budget

Every abstraction has a cost:

- another concept to name;
- another file to navigate;
- another dependency edge;
- another API to maintain;
- another place for behavior to hide.

Prefer an abstraction only when its benefit exceeds that cost.

## Symmetry is not a requirement

Do not create:

```text
data/
domain/
presentation/
```

inside every feature solely because another feature has those folders.

Do not create empty classes, interfaces, folders, or barrels to make the
repository symmetrical.

## Premature optimization

Do not optimize speculative performance problems.

Measure or demonstrate the problem first.

Prefer clear code over clever caching, memoization, or lifecycle complexity
until performance evidence justifies it.

## Architectural consistency

Do not introduce a second architectural style inside one feature without a
deliberate decision.

If existing architecture supports the requirement, extend it.

If it does not, document the concrete limitation before changing the pattern.

## Anti-patterns

Avoid:

- architecture astronautics;
- interface-per-class;
- use-case-per-button;
- factory-per-object;
- manager/service/facade layers with no distinct responsibility;
- speculative extension points;
- generic base classes without current reuse;
- premature micro-abstractions;
- premature optimization;
- folder symmetry for appearance;
- global mutable singleton state;
- hidden service locators.

## Decision question

Before adding architectural machinery, ask:

> What current problem does this solve?

If the answer is only:

> “We may need it later.”

do not add it yet.
