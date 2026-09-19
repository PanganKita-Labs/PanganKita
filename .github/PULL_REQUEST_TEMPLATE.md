## Description

<!--
Explain the problem and the implemented change directly.
Focus on why the change is needed, not only what files changed.
-->

## Changes

<!-- List the important implementation changes. -->

-
-

## Type of change

- [ ] `feat` — new functionality
- [ ] `fix` — bug fix
- [ ] `docs` — documentation only
- [ ] `style` — formatting with no behavior change
- [ ] `refactor` — internal restructuring
- [ ] `perf` — measured performance improvement
- [ ] `test` — test-only change
- [ ] `chore` — maintenance
- [ ] `ci` — CI workflow change
- [ ] `build` — dependency or build-system change
- [ ] `research` — research, experiment, or validation work

## Areas affected

- [ ] Flutter application
- [ ] UI / design system
- [ ] Accessibility
- [ ] Localization
- [ ] Authentication / authorization
- [ ] Business onboarding or verification
- [ ] Food listings
- [ ] Inventory
- [ ] Reservations / pickup flow
- [ ] Location / maps
- [ ] Notifications
- [ ] Food eligibility / safety behavior
- [ ] Privacy / personal data
- [ ] Analytics / impact measurement
- [ ] Matching / ranking
- [ ] Backend / API
- [ ] Tests / fixtures
- [ ] CI / developer tooling
- [ ] Documentation
- [ ] Research

## Verification

<!--
Include the exact commands you ran and their results.
Remove commands that do not apply, and add relevant ones.
-->

```text
cd app

dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
dart run dart_code_linter:metrics analyze lib
dart run dartrics analyze lib
flutter test
```

## Screenshots or evidence

<!--
Required for visible UI changes.
Include before/after screenshots where useful.
Remove this section when it does not apply.
-->

## Product and domain integrity

- [ ] No reservation or inventory behavior changed
- [ ] Reservation/inventory changes preserve valid state transitions and prevent invalid quantities or overselling
- [ ] Food eligibility or safety behavior is unchanged, or the change is supported by documented requirements/evidence
- [ ] No unsupported regulatory, health, environmental, or competitor claims were introduced
- [ ] Location handling follows least-data and privacy principles
- [ ] Impact metrics distinguish measured values from estimates where applicable
- [ ] Matching/ranking behavior remains explainable and testable where applicable

## Mobile quality

- [ ] Loading, empty, error, and retry states are handled where relevant
- [ ] Visible UI works with text scaling
- [ ] Interactive controls have appropriate semantic labels
- [ ] Important information does not depend on color alone
- [ ] Tap targets and interaction states were considered
- [ ] User-facing strings are localization-ready
- [ ] Network failure or interrupted requests are handled where relevant

## Security and privacy

- [ ] No credentials, API keys, tokens, signing keys, or private configuration were committed
- [ ] Authorization is enforced at the appropriate boundary
- [ ] User-controlled input is validated
- [ ] Logs do not expose tokens, precise location, personal data, or other sensitive information
- [ ] New data collection is necessary and documented
- [ ] New dependencies were reviewed before being introduced

## Checklist

- [ ] My branch contains one focused concern
- [ ] I reviewed and understand every changed line
- [ ] I added or updated relevant tests
- [ ] I updated relevant documentation
- [ ] Formatting passes
- [ ] Flutter analysis passes with fatal infos and warnings
- [ ] Dart Code Linter passes for the affected code
- [ ] Complexity checks pass for the affected code
- [ ] Tests pass
- [ ] I manually tested affected user-facing behavior where applicable
- [ ] I considered accessibility
- [ ] I considered security and privacy
- [ ] I considered food-safety implications where relevant
- [ ] I did not introduce undocumented assumptions as product requirements
- [ ] AI-assisted changes were manually reviewed and verified

## Related issue

<!-- Example: Closes #123 -->
