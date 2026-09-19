# PanganKita Flutter App Agent Instructions

These instructions apply to all work under `app/`.

Read the repository-root `AGENTS.md` first. It owns product direction,
Graphify usage, evidence discipline, repository-wide security/privacy, Git
workflow, and final reporting. This file specializes those rules for Flutter
and mobile implementation.

## App responsibility

`app/` owns the Flutter client.

The client is responsible for presentation, local interaction state, validated
client-side input, platform integration, API consumption, and user experience.

The client must not become the authoritative source for server-owned concerns
such as authorization, reservation concurrency, inventory truth, or
server-governed expiration once a backend exists.

## Flutter architecture

Use a feature-first, shallow architecture.

Prefer a structure that emerges only as real features appear:

```text
lib/
├── main.dart
├── app/
├── core/
└── features/
    ├── discovery/
    ├── listings/
    ├── reservations/
    └── pickup/
```

Do not pre-create empty architecture trees.

A modest feature may remain flat. Add subfolders only when they represent real
ownership boundaries.

Do not mechanically create all of these for every feature:

```text
data/
domain/
presentation/
repositories/
services/
use_cases/
entities/
models/
```

Widgets and presentation code must not own domain rules.

Prefer dependency direction:

```text
UI / widgets
    ↓
feature state / orchestration
    ↓
domain behavior
    ↓
repository/service contract
    ↓
API / persistence adapter
```

Business behavior should remain testable without rendering widgets.

## File and folder cohesion

A source file should have one primary reason to change.

Do not solve over-abstraction by creating god files.

Do not solve god files by creating meaningless one-function files.

The configured lint policy prefers one public widget per file. Respect the rule
instead of casually suppressing it.

Avoid catch-all `utils`, `helpers`, `common`, or `shared` folders unless their
responsibility is genuinely narrow and cohesive.

## Application bootstrap

Keep `main.dart` small.

It should primarily:

- initialize required framework/platform services;
- initialize approved dependencies;
- configure top-level error handling where needed;
- start the application.

Do not turn `main.dart` into a home for routing, product widgets, networking,
persistence, feature state, or uncontrolled global mutable state.

The root application widget composes the app; it does not implement product
features.

## State management

Do not add a state-management package merely because Flutter projects commonly
use one.

Choose state management only when actual requirements justify it.

When introduced:

- document why;
- keep business behavior outside widgets;
- avoid uncontrolled global mutable state;
- scope state to the smallest meaningful owner;
- keep loading/success/empty/error states explicit;
- make transitions testable;
- avoid mixing competing state-management paradigms without a strong reason.

## Domain modeling

Prefer typed domain models over loosely structured maps.

Use explicit models for meaningful concepts such as:

- user;
- business;
- listing;
- pickup window;
- inventory;
- reservation;
- report;
- impact record;
- ranking input.

Prefer immutable models where practical.

Do not let transport JSON shapes spread through the UI.

Avoid `dynamic`. When genuinely unavoidable at an external boundary, validate
and convert immediately.

## Reservation and inventory integrity

Reservation/inventory behavior is correctness-critical.

Preserve these principles unless an approved requirement changes them:

- quantity never becomes negative;
- reservation quantity never exceeds available inventory;
- inventory logic prevents overselling;
- reservation state transitions are explicit;
- illegal state transitions are rejected;
- cancellation/expiry restores inventory only when business rules permit it;
- completed pickup and inventory effects stay consistent;
- retries and duplicate actions are safe where applicable.

Do not implement “best effort” inventory correctness.

A future backend is authoritative for inventory, reservation concurrency,
authorization, and server-owned state transitions.

The Flutter client may provide optimistic UX but must reconcile with backend
truth.

## Listing and reservation lifecycle

Do not scatter contradictory lifecycle booleans such as:

```text
isActive
isExpired
isSoldOut
isCancelled
isCompleted
```

when an explicit state model would be clearer.

When lifecycle state machines exist, document and test:

- valid states;
- allowed transitions;
- actor permissions;
- invariants;
- terminal states;
- expiry behavior;
- cancellation behavior;
- inventory effects.

Cover legal and illegal transitions.

## Food safety and eligibility

Food-safety behavior is high risk.

Do not invent BPOM, Kementerian Kesehatan, storage, shelf-life, allergen,
liability, or certification requirements.

Prefer narrow wording such as:

```text
seller-provided food information
eligible unsold food
pickup deadline
storage information
allergen information
reported condition
```

Do not imply independent PanganKita safety certification unless an approved
process supports that claim.

Changes affecting eligibility, storage, allergens, pickup deadlines, condition
claims, seller responsibility, complaints, or moderation require explicit
product/evidence review.

## Trust and safety

Design for misuse rather than perfect actors.

Relevant risks include:

- fake listings;
- misleading photos;
- unsafe food;
- spam;
- duplicate accounts;
- business impersonation;
- reservation abuse;
- no-shows;
- harassment;
- ratings abuse;
- fraudulent reports;
- account takeover.

Do not add punitive automation without evidence and an appropriate review or
appeal path.

## Authentication and authorization

Authentication proves identity. Authorization controls actions.

Do not conflate them.

Client-side role checks may improve UX but cannot replace backend enforcement.

Do not add roles until their permissions are needed.

Keep permission checks explicit and testable.

## Location and privacy

Location is sensitive.

Do not request or collect continuous background location merely because the
product uses proximity.

Prefer the least precise and least persistent representation that satisfies the
feature.

When location is needed:

- explain why;
- request permission only when needed;
- handle denial gracefully;
- avoid logging precise coordinates;
- avoid exposing home locations;
- define retention explicitly;
- do not reuse location for unrelated analytics without approval.

Analytics must not become surveillance.

## File and image uploads

Listing images are untrusted input.

When uploads are implemented, define appropriate:

- MIME validation;
- extension checks;
- magic-byte validation;
- decode validation;
- maximum file size;
- dimension limits;
- EXIF/metadata policy;
- generated storage names;
- public/private storage behavior;
- signed URL behavior where needed;
- deletion and retention rules.

Never trust client-provided filenames or MIME headers alone.

## Accessibility

Accessibility is part of implementation, not final cleanup.

For affected UI:

- use Flutter semantics intentionally;
- provide accessible names for icon-only actions;
- support screen readers;
- preserve logical focus;
- support text scaling;
- maintain sufficient contrast;
- never rely on color alone;
- use comfortable tap targets;
- show clear validation and error messages;
- respect reduced motion where animation exists;
- avoid clipped content at larger text sizes.

Prefer standard accessible widgets over custom controls when they satisfy the
requirement.

## Responsive mobile UI

PanganKita is mobile-first.

For meaningful UI changes, consider at minimum:

```text
320 px logical width
360 px
390 px
412 px
```

Also consider:

- portrait;
- relevant landscape behavior;
- increased text scale;
- keyboard insets;
- system insets;
- long Indonesian copy;
- long business/listing names;
- loading states;
- empty states;
- error states.

Avoid page-level horizontal overflow and clipped critical content.

## Loading, empty, error, and retry states

Every data-backed screen should deliberately handle relevant states:

- initial loading;
- content;
- empty result;
- recoverable error;
- unrecoverable error where applicable;
- retry;
- network loss;
- stale data where applicable.

Do not leave users on indefinite spinners.

Do not expose raw technical exceptions to end users.

Preserve valid content during background refresh where practical.

## Localization

PanganKita is Indonesia-first.

Primary user-facing language is Bahasa Indonesia unless an approved product
decision changes it. Keep architecture ready for English.

Do not scatter user-facing strings across widgets once real product UI begins.

Keep labels, validation, errors, accessibility strings, notifications, and
date/time copy localization-ready.

Do not mechanically translate sensitive legal, food-safety, or handling copy
without review.

## Time and pickup windows

Time-sensitive pickup is central to PanganKita.

Do not:

- compare formatted time strings;
- silently mix time zones;
- calculate authoritative expiry only in UI code;
- trust the device clock for future server-owned state transitions.

Store timestamps unambiguously and convert for presentation at the UI boundary.

Test:

- pickup-window boundaries;
- expiry;
- cancellation near deadlines;
- date changes;
- time-zone behavior where applicable.

## Money and pricing

Do not use floating-point arithmetic for money.

Use integer minor units or another explicitly safe representation.

Research discount examples are not product pricing rules.

Future discounts, fees, taxes, refunds, settlement, merchant revenue, and
consumer savings require explicit rules and tests.

Do not add dynamic pricing without separately approved requirements.

## Matching and ranking

Matching/ranking is a future research and optimization direction, not permission
to add opaque AI.

Potential future inputs may include:

- remaining pickup time;
- distance;
- estimated travel time;
- remaining quantity;
- listing age;
- demand;
- pickup feasibility;
- category relevance.

Start deterministic and explainable.

Any ranking implementation must support:

- documented inputs;
- deterministic fallback;
- cold-start behavior;
- explainability;
- tests;
- fairness review;
- telemetry needed for evaluation;
- comparison against a baseline.

Do not claim improved outcomes until measured.

Do not add ML/AI merely to make the project appear advanced.

## Analytics and impact

Track only events with a defined use.

Potential event names may include:

```text
listing_created
listing_activated
listing_viewed
reservation_created
reservation_cancelled
pickup_completed
listing_expired
listing_sold_out
food_rescued_recorded
```

Do not track everything “just in case”.

Never place sensitive personal or precise location data into unrestricted event
properties.

Distinguish measured, calculated, and estimated values.

## Logging and errors

Production logging must be structured and privacy-conscious.

Do not leave `print` or `debugPrint` in production paths unless routed through
an approved logging abstraction.

Never log passwords, tokens, authorization headers, precise private locations,
private user content, or sensitive business data.

Do not swallow errors silently.

Prefer defined errors at feature boundaries and actionable UI states over raw
exceptions.

Do not use `catch (_) {}` without a documented reason.

## Async lifecycle safety

Do not:

- call `setState` after disposal;
- use stale `BuildContext` after an async gap;
- leak listeners, streams, or subscriptions;
- allow uncontrolled duplicate concurrent actions;
- allow repeated taps to create duplicate reservations;
- ignore futures without intent.

Fix underlying lifecycle problems instead of suppressing lint rules.

## Dependencies

Before adding a Dart/Flutter package:

1. inspect existing dependencies;
2. check whether Flutter/Dart/platform APIs already solve the requirement;
3. explain why the package is needed;
4. verify maintenance status;
5. review license implications;
6. avoid overlapping packages;
7. prefer one focused dependency;
8. update `pubspec.lock`;
9. run the relevant quality gate.

Do not add dependencies for trivial utilities.

Do not upgrade merely because newer versions exist.

Avoid unrelated dependency churn.

Dependabot may be added later when the dependency surface is mature enough to
justify automated update traffic.

## Toolchain baseline

Current project baseline:

```text
Flutter 3.47.4
Dart 3.13.3
```

Do not silently upgrade Flutter, Dart, Gradle, Android tooling, lint tooling, or
major dependencies.

If an upgrade is necessary:

- explain why;
- review breaking changes;
- update CI and documentation;
- regenerate required lock/config files;
- rerun the full gate.

Keep local and CI toolchains aligned.

## Strict analysis

The app intentionally uses:

- Very Good Analysis;
- Dart Code Linter;
- Dartrics;
- Dart analyzer strict modes.

Configured strict analyzer behavior includes:

```text
strict-casts
strict-inference
strict-raw-types
```

CI treats analyzer infos and warnings as fatal.

Do not weaken lint rules merely to make CI pass.

Avoid broad ignore blocks. A suppression is acceptable only when the rule is
demonstrably wrong for the exact case, the scope is minimal, and the reason is
documented.

## Complexity policy

Current intended thresholds:

```text
cognitive complexity
  warning: 10
  error:   15

cyclomatic complexity
  warning: 10
  error:   15

number of parameters
  warning: 4
  error:   6

method length
  warning: 50
  error:   80
```

Do not game metrics with meaningless helper extraction, obscure expressions, or
indirection that does not improve design.

Reduce complexity by clarifying responsibilities.

## Flutter completion gate

Run focused tests first, then the broad gate.

From `app/`:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
dart run dart_code_linter:metrics analyze --fatal-style --fatal-performance --fatal-warnings lib
dart run dart_code_linter:metrics check-unused-code --analyze-private-members lib
dart run dart_code_linter:metrics check-unused-files lib
dart run dart_code_linter:metrics check-unnecessary-nullable lib
dart run dartrics analyze lib
flutter test
```

Never claim a command passed unless it actually ran successfully.

If a mandatory command cannot run, report the exact attempted command and
blocker, distinguish environment failure from implementation failure, and do
not report the task complete.

## Formatting

`dart format` is canonical.

Do not fight formatter output manually.

A pre-commit hook may format staged Dart files, but hooks are convenience only
and can be bypassed.

CI must independently verify formatting.

## Testing strategy

Add tests with behavior. Do not defer all testing until final hardening.

Use unit tests for:

- domain rules;
- validation;
- state transitions;
- pricing;
- inventory;
- ranking/scoring;
- permissions;
- serialization;
- utilities.

Use widget tests for:

- meaningful widgets;
- validation;
- loading/error/empty states;
- accessibility semantics;
- important navigation behavior.

Use integration tests when real boundaries exist for:

- repository/API behavior;
- authentication;
- listing creation;
- inventory updates;
- reservation;
- cancellation;
- pickup;
- expiry.

### E2E timing

E2E is intentionally deferred until PanganKita has a stable, meaningful user
journey worth automating.

Do not add a large emulator/E2E pipeline prematurely.

When appropriate, prioritize:

- business creates listing;
- consumer discovers listing;
- consumer reserves;
- inventory remains correct;
- pickup completes;
- impact is recorded;
- cancellation;
- expiry;
- oversell/race prevention;
- unauthorized-action rejection;
- network-failure recovery.

Use deterministic isolated test data. Never run E2E against production data.

## Coverage

Do not optimize for meaningless 100% coverage.

Prioritize strong coverage for:

- domain rules;
- ranking;
- pricing;
- inventory;
- reservation state machines;
- permissions;
- food-safety validation;
- security-sensitive validation.

Introduce numeric coverage thresholds only after enough meaningful code exists
for the metric to represent quality.

## CI parity

Local policy and CI should stay aligned.

Current CI responsibilities may include:

```text
quality.yml
  formatting
  analyzer
  linting
  complexity
  unused code
  tests

android-build.yml
  Android build validation

dependency-review.yml
  dependency vulnerability review

lychee.yml
  documentation link validation

workflow-lint.yml
  GitHub Actions validation
```

When a durable local command becomes mandatory, add equivalent CI unless a
documented platform-specific reason prevents it.

Do not create CI that always fails against the accepted baseline. Fix the
baseline first.

## Android platform changes

Do not modify Gradle or Android platform files without a concrete requirement.

Touch Android build configuration only for legitimate needs such as:

- application ID or namespace;
- SDK configuration;
- signing;
- flavors;
- permissions;
- native dependencies;
- platform integration.

Platform changes require Android build validation.

## App-level completion

Before finishing app work:

- run focused tests;
- run the configured Flutter quality gate;
- run Android build validation when platform/build behavior changed;
- refresh Graphify when source relationships changed;
- inspect the final diff;
- report exact results.

Do not claim E2E was required or passed while E2E is not yet part of the active
project gate.
