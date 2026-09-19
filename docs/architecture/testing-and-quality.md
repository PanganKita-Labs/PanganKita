# Testing, Quality & Structural Verification

Read `docs/ARCHITECTURE.md` first.

This document defines testing boundaries, test doubles, quality gates,
structural verification, and Graphify expectations.

## Testing principle

Test behavior at the narrowest useful level.

Do not test private implementation details merely to increase coverage.

## Unit tests

Use unit tests for:

- state transitions;
- calculations;
- validation;
- repository behavior;
- deterministic filtering/ranking logic;
- pure time/deadline logic.

Keep these tests fast and deterministic.

## Widget tests

Use widget tests for:

- meaningful rendering;
- interaction;
- navigation;
- state-dependent presentation;
- loading/empty/error states;
- important accessibility/semantic behavior where practical.

Avoid tests that simply restate Flutter framework behavior.

## Integration / E2E

Do not add broad E2E coverage before a stable meaningful journey exists.

Once a full prototype journey becomes stable, critical end-to-end/integration
coverage is appropriate.

Prefer a small number of meaningful journeys over a large brittle suite.

## Test doubles

Prefer simple fakes/mocks only where necessary.

The deterministic prototype repositories may often be sufficient for tests.

Do not build elaborate mocking infrastructure when a small in-memory fake is
clearer.

## Determinism

Tests involving:

- current time;
- deadlines;
- expiration;
- ranking;
- fixture values;

must remain deterministic.

Avoid uncontrolled direct clock access in pure domain logic.

## Quality gate

Architecture must work with the repository quality gate.

Do not suppress quality rules to preserve an architectural preference.

Current work should continue to satisfy:

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

Then from the repository root:

```powershell
git diff --check
```

A structural change is not complete while required checks fail.

## Lint compatibility

Do not weaken lint rules simply because a chosen architecture produces
warnings.

If architecture repeatedly conflicts with quality rules, reconsider the
architecture.

## Complexity

Configured complexity thresholds are hard constraints.

Do not silence complexity findings by merely moving the same complexity into a
different file.

Reduce responsibility or simplify behavior.

## Graphify

Use Graphify according to repository agent instructions for non-trivial
structural work.

Especially useful before:

- moving feature boundaries;
- changing many imports;
- extracting shared concepts;
- changing routing;
- replacing repositories;
- broad state-management refactors.

Typical commands:

```text
graphify query "<question>" --graph graphify-out/graph.json
graphify path "<A>" "<B>" --graph graphify-out/graph.json
graphify explain "<symbol>" --graph graphify-out/graph.json
```

If no graph exists:

```text
graphify extract . --code-only
```

After validated structural source changes:

```text
graphify update .
```

The graph informs engineering judgment; it does not replace it.

## Structural review questions

Before accepting a non-trivial change, ask:

- Did this add a new dependency direction?
- Did it create a feature cycle?
- Did implementation detail leak across a boundary?
- Did code move into `shared/` without real reuse?
- Did a barrel expose internal implementation?
- Did state become more global than necessary?
- Did testability improve or degrade?
- Is the new abstraction justified by a current problem?

## Coverage

Coverage is evidence, not the goal.

Prioritize meaningful tests for:

- critical state transitions;
- repository contracts;
- consumer flow;
- merchant flow;
- error and empty states.

Do not write low-value tests solely to inflate a percentage.
