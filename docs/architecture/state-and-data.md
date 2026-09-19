# State, Data & Repository Architecture

Read `docs/ARCHITECTURE.md` first.

This document defines state ownership, repository seams, mock-data rules, DTO
policy, dependency injection, time handling, and future data-source boundaries.

## State ownership

Use the simplest state ownership appropriate to scope and lifetime.

### Local visual state

Use local Flutter state for things such as:

- selected chip;
- temporary expansion;
- text-field visibility;
- local form interaction.

A `StatefulWidget` is acceptable when it is the simplest correct tool.

Do not introduce a state-management framework for trivial local state.

### Feature state

Use one explicit feature-level state owner when several screens/widgets need to
coordinate meaningful state.

Examples:

- current reservation;
- merchant listing draft;
- reservation queue;
- local listing mutations.

The exact implementation may be:

- controller;
- notifier;
- view model;
- another small idiomatic Dart/Flutter mechanism.

Choose based on current complexity.

### Cross-feature state

Introduce cross-feature state only when a demonstrated requirement exists.

Do not create global mutable application state preemptively.

## State-management package policy

This architecture does **not** currently mandate:

```text
Riverpod
Bloc
Provider
Redux
MobX
GetX
```

Do not add one merely because the application may grow.

If simple/native state becomes insufficient, choose a package through an
explicit architecture decision based on current requirements.

## Repository pattern

Repository boundaries are useful when they isolate a data source that will
genuinely change.

Prototype:

```text
ListingRepository
      ↑
MockListingRepository
```

Future:

```text
ListingRepository
      ↑
ApiListingRepository
```

This is a justified abstraction because mock data is explicitly temporary.

Do not automatically add service/use-case/manager/facade layers around every
repository.

## Mock-data architecture

Current prototype data must be deterministic.

Preferred:

```text
presentation
    ↓
typed model / feature state
    ↓
repository contract
    ↓
mock repository
    ↓
fixtures
```

Fixture values must not be scattered directly through widgets.

Good:

```dart
Text(listing.businessName)
```

Avoid repeated production-widget literals such as:

```dart
Text('Mon Petit Bakery')
```

Fixtures may contain:

- merchants;
- listings;
- prices;
- inventory;
- pickup windows;
- addresses;
- reservation codes;
- distances;
- operational metrics.

These remain prototype data.

## Models

Models should represent meaningful product concepts.

Examples:

```text
Listing
MerchantSummary
Reservation
PickupWindow
```

Prefer focused immutable data structures.

Use enums/sealed state when they make invalid state harder to represent.

State names should match the PRD.

Avoid generic speculative bases:

```text
BaseEntity
BaseModel
SerializableEntity
AbstractDomainObject
```

## DTO policy

DTOs are generally unnecessary during mock-only work.

Introduce DTOs when:

- a real external API exists;
- external representation differs from domain representation;
- serialization concerns would otherwise leak upward.

Future:

```text
API JSON
↓
DTO
↓
domain model
↓
presentation
```

Do not expose raw API maps/JSON to widgets.

## Dependency injection

Do not introduce a DI framework during the prototype unless a real complexity
problem requires it.

Prefer constructor injection.

Conceptually:

```dart
DiscoverController(repository: listingRepository)
```

Top-level application composition may construct mock implementations.

Avoid hidden global service locators.

## Time and deadlines

Time is core to PanganKita.

Do not scatter calls to the system clock throughout domain logic.

When behavior materially depends on current time:

- pass the time into pure logic; or
- use a tiny replaceable clock abstraction when repeated use justifies it.

This keeps expiration/deadline behavior deterministic in tests.

Do not create a large time service solely for formatting.

## Persistence

In-memory state is acceptable for the current prototype.

Do not add SQLite, Hive, Isar, or another persistence layer only to make the
prototype appear production-ready.

Add persistence when a current requirement needs restart durability.

When persistence becomes necessary, define:

- what persists;
- why;
- expected lifetime;
- migration expectations.

## Backend boundary

The Flutter prototype must not assume a specific backend implementation.

Flutter should depend on narrow domain/repository contracts instead of concrete
HTTP details.

Desired future seam:

```text
MockListingRepository
        ↓ replace
ApiListingRepository
```

without redesigning feature widgets.

## Authentication boundary

Production authentication is outside the current prototype architecture.

Do not create:

- fake JWT services;
- token refresh infrastructure;
- secure-storage abstraction;
- OAuth providers.

Prototype role switching may remain local and explicit.

## Payment boundary

Current MVP baseline uses reservation in PanganKita and payment at pickup.

Do not create:

- payment repository;
- wallet state;
- payment SDK abstraction;
- settlement architecture;

during prototype conversion.

## Location/maps boundary

Dummy/static location data is sufficient for the current prototype.

Do not add a live maps/geolocation SDK solely to reproduce a visual mockup.

## Analytics boundary

Do not add production analytics during mock-design conversion.

When analytics is selected later, avoid scattering provider-specific calls
directly through widgets.
