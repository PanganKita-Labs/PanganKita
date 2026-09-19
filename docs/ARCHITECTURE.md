# PanganKita Flutter Architecture

**Document:** `docs/ARCHITECTURE.md`\
**Product:** PanganKita\
**Status:** Architecture director / orchestration layer\
**Scope:** Flutter application architecture

> Build the smallest architecture that keeps PanganKita easy to understand,
> test, and change.

## Purpose

This file is the architecture director.

Detailed execution rules live under `docs/architecture/`.

Do not load every architecture document for every task. Read only the files
relevant to the current structural decision.

## Source-of-truth order

When instructions conflict:

1. `PRD.md`
2. Official PanganKita Brand Guidelines
3. `AGENTS.md`
4. `app/AGENTS.md`
5. `docs/ARCHITECTURE.md`
6. relevant `docs/architecture/*.md`
7. `docs/DESIGN.md` and relevant scoped design instructions
8. `docs/IMPLEMENTATION.md` and the active implementation phase
9. accepted HTML/PNG design references

Architecture supports product behavior. It must not silently redefine the PRD.

## Architectural style

PanganKita uses:

> **Feature-first organization with lightweight internal layering.**

The intended feature shape is:

```text
feature/
├── data/
├── domain/
└── presentation/
```

Create a layer only when it contains real responsibilities.

Do not create empty folders or abstractions merely to make the repository look
symmetrical.

## Core principles

Use these principles pragmatically:

```text
KISS  → choose the smallest correct design
YAGNI → do not build speculative infrastructure
DRY   → remove meaningful duplication, not all duplication
SOLID → use boundaries where they solve real problems
```

Prefer composition over deep application-specific inheritance.

> Duplication is sometimes cheaper than the wrong abstraction.

## Architecture routing

Read the relevant scoped document before structural work:

| Work | Required architecture file |
|---|---|
| KISS, YAGNI, DRY, SOLID, abstraction thresholds, anti-overengineering | `architecture/foundations.md` |
| Folder structure, feature ownership, dependency direction, core/shared, barrels | `architecture/project-structure.md` |
| Repositories, mock data, state ownership, DI, DTOs, persistence, backend seams | `architecture/state-and-data.md` |
| Widget boundaries, presentation responsibilities, navigation, naming, utilities | `architecture/ui-and-widgets.md` |
| Unit/widget/E2E boundaries, test doubles, quality gates, Graphify | `architecture/testing-and-quality.md` |
| Dependencies, codegen, auth/payment/maps/analytics boundaries, architecture changes | `architecture/decisions-and-boundaries.md` |

For cross-cutting work, read each relevant file.

Do not load unrelated architecture files merely for completeness.

## High-level dependency direction

Within a feature, prefer:

```text
presentation
     ↓
   domain
     ↑
    data
```

Conceptually:

```text
UI
↓
feature state owner
↓
repository contract
↑
mock repository today
real repository later
```

Cross-feature dependencies should remain narrow and acyclic.

Prefer:

```text
feature
  ↓
shared/core
```

Avoid feature dependency cycles.

## Current prototype boundary

The current Flutter implementation uses deterministic mock data.

Preferred flow:

```text
presentation
    ↓
typed domain/view state
    ↓
repository contract
    ↓
mock repository
    ↓
fixtures
```

Do not spread fixture values directly through widgets.

Do not introduce production backend, auth, payment, live maps, analytics,
WebSockets, or persistence merely to make the prototype appear production-like.

## Barrel policy summary

Controlled barrel files are allowed.

> Barrel files are boundaries, not convenience dumping grounds.

Use them only to expose a deliberate public feature surface.

Do not create:

- barrel files for every folder;
- mega `core.dart` / `shared.dart` barrels;
- long re-export chains;
- exports that hide circular dependencies.

## State-management summary

Use the simplest state ownership appropriate to scope.

```text
local visual state
→ local Flutter state

shared feature state
→ explicit feature-level owner

cross-feature state
→ only when a demonstrated requirement exists
```

No state-management package is mandated yet.

Do not add Riverpod, Bloc, Provider, Redux, MobX, GetX, or another framework
merely because the app may grow.

## Architecture-change rule

Significant changes require explicit justification.

Examples:

- adding a state-management framework;
- adding dependency injection;
- adding persistence;
- introducing real networking;
- changing feature boundaries;
- adding code generation;
- changing repository contracts.

For non-trivial structural work, use Graphify as required by repository agent
instructions before making broad changes.

## Conflict resolution

If a scoped architecture document conflicts with this director, preserve this
director and the higher source-of-truth order.

If architecture conflicts with the PRD, the PRD wins.

If a structural decision is not covered, choose the smallest design consistent
with existing boundaries rather than inventing a new architecture style.

Do not silently guess when the choice would materially affect the codebase.

## Definition of architectural quality

The architecture is healthy when a developer can quickly answer:

- Where does this feature live?
- Who owns this state?
- Where does this data come from?
- Which implementation can be replaced later?
- What may this feature depend on?
- Why does this abstraction exist?
- How should this behavior be tested?

without tracing through unnecessary layers.

PanganKita architecture should be:

```text
predictable
small
explicit
testable
easy to navigate
replaceable where genuinely needed
```

The goal is not architectural sophistication.

The goal is to make PanganKita easy to build correctly.
