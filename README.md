# PanganKita Flutter prototype

PanganKita is an Indonesia-first, pickup-oriented surplus-food project. This
repository currently contains a **local Flutter prototype**, not a live
marketplace. Listings, businesses, locations, prices, pickup codes, and
reservations shown in the app are examples.

## Run the prototype

Install the Flutter version specified in [`app/AGENTS.md`](app/AGENTS.md), then
start an Android emulator or connect a device. From `app/`:

```powershell
flutter pub get
flutter devices
flutter run
```

The app opens in Consumer mode. Select a listing in **Jelajahi**, confirm a
sample reservation, and find its pickup code under **Reservasi**. Return to
the reservation list, switch to **Mode Bisnis**, open **Reservasi**, mark the
reservation ready, and enter that code to simulate pickup completion. Switch
back to Consumer mode to see it in history. The Business dashboard also lets
you create and publish a sample listing that appears in Consumer discovery.

Both modes share in-memory mock repositories. Changes last only while the app
process is running; fully stopping and restarting the app restores the sample
data. Mode switching is a demo control, not account verification. Pickup-code
matching is local and is not secure verification. No real reservation or
payment is sent to a merchant; the intended MVP payment method is payment at
pickup using a method accepted by the merchant.

The prototype has no backend, sign-in, database, live location or maps,
payment gateway, production analytics, or push notifications. Consumer
**Dampak** and **Profil** are labelled as unavailable prototype destinations.

## Check the app

Run the application quality gate from `app/`:

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

From the repository root, run `git diff --check`. Product and architecture
context is in [`PRD.md`](PRD.md), [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md),
and [`docs/IMPLEMENTATION.md`](docs/IMPLEMENTATION.md).
