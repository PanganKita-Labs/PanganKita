# PanganKita Backend Agent Instructions

These instructions apply to all work under `backend/` once that subsystem
exists.

Read the repository-root `AGENTS.md` first. This file defines the intended
backend contract in advance without requiring a backend to be created before it
is actually needed.

Do not create backend infrastructure merely because this file exists.

## Backend responsibility

The backend becomes authoritative for server-owned concerns such as:

- authentication/session validation;
- authorization;
- business ownership and permissions;
- listing persistence;
- inventory truth;
- reservation concurrency;
- reservation/listing lifecycle transitions;
- server-governed expiry;
- abuse/rate limits;
- durable audit-relevant events;
- persistence and migration behavior.

The Flutter client may improve UX but must not replace server enforcement.

## Architecture

Use feature/domain ownership and shallow boundaries.

Do not begin with speculative microservices.

Prefer a cohesive application until measured scale, deployment, security, or
organizational requirements justify separation.

Do not create repository/service/factory layers merely for ceremony.

Infrastructure adapters should remain behind clear contracts when that boundary
provides real testability or portability.

Keep business rules independent from HTTP framework details where practical.

## API contracts

API inputs and outputs must be validated.

Prefer typed/versioned schemas.

Do not expose raw database rows directly as public API contracts.

When changing an API contract:

1. update the schema;
2. update route/application behavior;
3. update authorization;
4. update Flutter/client decoding/types;
5. update tests;
6. update documentation;
7. document compatibility or migration implications.

Do not silently change response meaning.

## Authentication and authorization

Authentication proves identity; authorization controls access.

Enforce authorization server-side.

Do not trust:

- client role flags;
- hidden buttons;
- user-supplied owner IDs;
- object IDs alone;
- client-provided business membership.

Use least privilege.

Authorization checks must be explicit and testable.

Avoid leaking whether a protected resource exists when the security model
requires non-disclosing behavior.

## Reservation concurrency

Reservation and inventory operations are correctness-critical.

The backend must prevent overselling under concurrent requests.

Do not rely on:

- client-side checks;
- read-then-write without concurrency control;
- in-memory locks in multi-instance environments;
- best-effort reconciliation as the primary correctness mechanism.

Use appropriate transactional/database mechanisms when persistence exists.

Important mutations should be designed for retry safety and duplicate request
handling where applicable.

## State machines

Listing, reservation, pickup, cancellation, and expiry transitions should be
explicit.

For each state machine define:

- states;
- allowed transitions;
- actor/permission for each transition;
- invariants;
- side effects;
- terminal states;
- expiry behavior;
- inventory behavior.

Reject illegal transitions.

Test transition matrices where practical.

## Time

Server time governs authoritative expiration and time-sensitive state
transitions.

Store timestamps unambiguously, preferably in UTC or another explicitly defined
canonical form.

Do not compare formatted strings.

Do not trust client timestamps for authorization or reservation validity.

Consider multiple Indonesian time zones at presentation boundaries.

## Money

Do not use binary floating point for money.

Use an explicitly safe representation and document currency assumptions.

Pricing, discount, fee, tax, refund, settlement, merchant-revenue, and
consumer-savings rules require tests.

Do not implement dynamic pricing without separately approved requirements.

## Food-safety data

The backend may store seller-provided food information, but storage does not
make the information independently verified.

Do not introduce fields or workflows that imply certification or legal
compliance unless the product process supports that claim.

Food eligibility and safety-related validation must be based on approved
requirements, not invented rules.

## Input validation

Treat every external input as untrusted.

Validate:

- body/query/path values;
- enums;
- identifiers;
- lengths;
- numeric bounds;
- timestamps;
- file metadata;
- pagination;
- sort/filter values.

Use positive allowlists where practical.

Do not rely on client validation.

## File/image uploads

When uploads exist, enforce appropriate controls server-side:

- MIME allowlist;
- extension checks;
- magic-byte/file-signature validation;
- decode validation;
- maximum bytes;
- maximum dimensions;
- metadata/EXIF policy;
- generated names;
- storage isolation;
- signed access where appropriate;
- deletion and retention;
- malware/content scanning if risk justifies it.

Do not use user-provided filenames as storage authority.

Do not store arbitrary uploads in executable application paths.

## Database and migrations

Do not introduce a database before the backend requirement exists.

When persistence exists:

- migrations must be ordered and reviewable;
- migrations must be tested;
- schema ownership must be clear;
- constraints should enforce critical invariants where appropriate;
- indexes should be justified by access patterns;
- retention/deletion behavior should be explicit;
- destructive migrations require recovery/rollback planning.

Do not use production data for tests.

## Security

Never log or expose:

- passwords;
- password hashes unnecessarily;
- tokens;
- authorization headers;
- signing secrets;
- database URLs with credentials;
- private object-storage credentials;
- precise private locations without need;
- sensitive user/business data.

Use secure password hashing if passwords are stored.

Use secure random token generation.

Do not disable TLS verification.

Rate-limit abuse-prone endpoints where justified.

Validate proxy/client-IP trust before using forwarded headers for security
decisions.

## Privacy

Collect the minimum data required.

Define purpose and retention for sensitive fields.

Location data requires special care.

Avoid storing raw precise location histories when a less precise/current value
is enough.

Do not reuse operational data for analytics or research without an approved
purpose and privacy model.

## Error contracts

Use stable error codes/contracts where useful.

Do not return stack traces, SQL details, secrets, or internal infrastructure
information to clients.

Distinguish validation, authentication, authorization, not-found, conflict,
rate-limit, and server errors where useful.

Do not leak protected resource existence through inconsistent error behavior.

## Observability

Use structured logs and metrics.

Prefer correlation/request IDs when useful.

Observability should help answer operational questions without exposing
sensitive content.

Do not log entire request/response bodies by default.

Define metrics for system health separately from product analytics.

## Background work

Do not introduce queues, workers, cron jobs, WebSockets, or distributed
coordination speculatively.

Add them only when a concrete product/runtime requirement cannot be handled
cleanly by the current architecture.

Time-based expiry behavior must remain correct even if opportunistic cleanup is
used.

## External services

Wrap external providers behind focused adapters when doing so gives clear
testability, replacement, or failure-isolation benefits.

Set explicit timeouts.

Handle retries carefully.

Do not blindly retry non-idempotent operations.

Tests must not call paid or production external services.

## Testing

Add tests with behavior.

Prioritize:

- domain state transitions;
- authorization;
- reservation concurrency;
- inventory invariants;
- validation;
- idempotency/retries;
- expiry;
- money calculations;
- upload validation;
- privacy/security-sensitive behavior;
- migration behavior.

Use deterministic fixtures.

Use disposable test databases for integration tests.

Never test destructive operations against production data.

## Dependency policy

Before adding a backend dependency:

1. inspect existing capabilities;
2. explain why the standard library/current stack is insufficient;
3. choose one focused maintained dependency;
4. review license/security implications;
5. avoid overlapping libraries;
6. lock versions according to the chosen ecosystem;
7. run relevant tests and security checks.

Do not choose a framework or database merely because it is familiar. Follow
approved architecture decisions once they exist.

## CI parity

When the backend is introduced, add backend quality gates appropriate to the
chosen stack.

At minimum, the eventual gate should cover:

- dependency installation from lock data;
- formatting;
- lint/static analysis;
- type checking when supported;
- unit/integration tests;
- migration validation;
- security-sensitive tests;
- build/package validation where relevant.

Do not invent exact commands until the backend stack exists.

## Backend completion

Before finishing backend work:

- run focused tests;
- run the backend's established full quality gate;
- validate migrations when affected;
- validate authorization when affected;
- verify concurrency-sensitive behavior when affected;
- refresh Graphify after validated structural source changes;
- inspect the final diff;
- report exact results.

Do not claim an unestablished backend command or framework-specific check exists.
