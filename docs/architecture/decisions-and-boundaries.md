# Architecture Decisions & Current Boundaries

Read `docs/ARCHITECTURE.md` first.

This document records current architectural guardrails and how significant
changes should be evaluated.

## Current prototype boundary

The active implementation plan converts the accepted design into a Flutter
prototype using deterministic mock data.

Current scope includes:

- Flutter app structure;
- theme/design system;
- feature UI;
- mock repositories;
- deterministic fixtures;
- local prototype state transitions;
- tests;
- accessibility/responsiveness.

It does not include production infrastructure.

## Dependency policy

Add a package only when it provides clear value over:

- Dart standard library;
- Flutter SDK;
- a small amount of straightforward maintainable code.

Evaluate:

- maintenance activity;
- license;
- Flutter/Dart compatibility;
- platform support;
- transitive dependency weight;
- API stability;
- architectural lock-in.

Do not add a package solely to avoid a small helper.

## Code generation

Do not introduce code generation without a demonstrated benefit.

Possible future reasons:

- serialization;
- routing;
- immutable-model generation.

Code generation adds:

- toolchain complexity;
- build steps;
- dependency coupling;
- repository noise.

Handwritten models are preferred for the current prototype unless generation
clearly improves maintainability.

## State-management framework

No state-management package is currently mandated.

Adding one is an architectural decision, not an implementation convenience.

A proposal should explain:

- what existing state problem cannot remain simple;
- why native/current ownership is insufficient;
- why the selected package fits the problem;
- migration cost;
- testing impact.

## Dependency injection framework

No DI framework is currently required.

Constructor injection is preferred.

Do not add a service locator or DI container merely to centralize object
construction.

## Persistence

Prototype state may remain in memory.

Do not add persistent local storage unless restart durability becomes a current
requirement.

## Backend

The Flutter prototype must remain independent of a specific backend
implementation.

Real networking belongs to a later backend/API integration plan.

## Authentication

Production authentication is outside current prototype architecture.

Do not introduce fake JWT, token-refresh, OAuth, or secure-session systems.

## Payment

Current MVP baseline is reservation in PanganKita with payment at pickup.

Do not create payment/wallet/settlement architecture during prototype
conversion.

## Maps and geolocation

Static/dummy location is sufficient for the prototype.

Do not add a live map/geolocation SDK solely to reproduce Stitch visuals.

## Analytics

Do not add production analytics until a provider/privacy model is deliberately
chosen.

When instrumentation is eventually introduced, provider-specific calls should
not be scattered directly through UI widgets.

## WebSockets / real-time infrastructure

Do not introduce WebSocket/event-stream infrastructure during the mock
prototype.

Local deterministic transitions are enough for current validation.

## Significant architecture changes

A significant change should document:

```text
problem
current limitation
options considered
chosen change
trade-offs
migration impact
```

Examples requiring deliberate review:

- state-management framework;
- DI framework;
- persistence;
- networking;
- code generation;
- changed feature boundaries;
- new cross-feature dependency;
- changed repository contracts;
- major routing architecture change.

Do not silently introduce a second architectural style.

## Stop conditions

Stop and report instead of guessing when:

- PRD and architecture appear incompatible;
- a change requires production infrastructure outside the active phase;
- a new dependency materially changes architecture;
- a cross-feature cycle appears necessary;
- the only way forward seems to require a global singleton/service locator;
- the architecture rules conflict with strict quality gates;
- a requested abstraction has no clear current responsibility.

## Current non-goals

Do not add merely for future readiness:

```text
generic use-case framework
event bus
service locator
offline database
generic caching layer
fake HTTP stack
WebSocket layer
payment abstraction
auth token system
analytics provider abstraction
deep-link platform
codegen framework
```

Future needs may change these decisions. When they do, update architecture
deliberately rather than bypassing the documented boundary.
