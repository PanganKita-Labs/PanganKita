# Phase 04 — Business / Merchant Prototype

**Status:** Blocked by Phase 03
**Scope:** Merchant-side prototype on deterministic local mock state
**Backend:** Out of scope

## Goal

Implement a coherent merchant experience for managing surplus listings and
prototype reservations.

Target flow:

```text
Merchant Dashboard
→ Create Listing
→ Preview/Publish
→ Active Listing
→ Reservation Queue
→ Mark Ready
→ Verify Pickup
→ Completed
```

## Required context

Read:

```text
AGENTS.md
app/AGENTS.md
docs/IMPLEMENTATION.md
this phase file
relevant PRD business/listing/reservation/role/state requirements
docs/DESIGN.md
docs/design/instructions/foundations.md
docs/design/instructions/components.md
docs/design/instructions/business.md
docs/design/instructions/states-accessibility.md
docs/design/instructions/implementation.md
docs/design/reference/merchant-dashboard.html
```

PNG fallback:

```text
docs/design/reference/merchant-dashboard.png
```

Use Graphify first for non-trivial cross-feature/state work.

## In scope

Implement:

- business navigation shell/destination if not already complete;
- merchant dashboard/listings overview;
- deterministic merchant identity fixture;
- business/account verification display only if backed by prototype state;
- create-listing form;
- listing preview;
- publish to local mock repository/state;
- active/draft/closed listing presentation where appropriate;
- listing detail/manage view;
- reservation queue;
- reservation detail;
- mark-ready transition;
- pickup verification using local prototype code/state;
- completion update;
- concise operational metrics based on current mock state;
- basic business settings/profile shell only where useful.

## Explicitly out of scope

Do not implement:

- real business verification service;
- document/KYC provider;
- production staff accounts;
- real payment settlement;
- real POS integration;
- live inventory sync;
- backend QR/token verification;
- production analytics;
- delivery logistics;
- donation network;
- national admin console.

## Listing creation

Keep the form practical.

Potential fields:

- photo reference;
- title;
- category;
- short description;
- original price;
- surplus price;
- quantity;
- pickup start;
- pickup deadline;
- seller-provided condition;
- storage info when relevant;
- allergen info when relevant;
- pickup notes.

Do not invent legal/regulatory fields not defined by the PRD.

## Verification wording

`Terverifikasi` may represent prototype business/account verification.

It must not imply:

- food-safe certification;
- hygiene certification;
- independent inspection of every listing.

## Merchant metrics

Prefer operational facts derived from mock state:

```text
4 pesanan selesai
4 dari 6 porsi diambil
1 porsi tersedia
1 listing berakhir
```

Do not show unsupported zero-waste/carbon claims.

## Shared mock state

Consumer and merchant flows should operate on compatible deterministic state
where practical.

For example, a locally created merchant listing may appear in consumer
discovery if that interaction is part of the prototype and can remain simple.

Do not build complex event infrastructure for this.

## Required tests

Test:

- dashboard renders merchant/listing fixture data;
- create listing validation;
- preview reflects entered state;
- publish creates expected local listing;
- listing appears in merchant state;
- reservation queue maps state correctly;
- mark-ready transition works;
- pickup verification completes once;
- invalid/repeated transitions are safe;
- metrics reflect fixture/local state rather than hardcoded display numbers.

## Acceptance criteria

- accepted merchant dashboard direction is recognizable;
- create/manage/reservation/pickup loop can be demonstrated;
- merchant and consumer state concepts are consistent;
- business verification language is accurate;
- no production backend dependency;
- no unsupported safety/environmental claims;
- full quality gate passes.

## Exit criteria

Run the full quality gate and stop.

Do not begin cross-cutting hardening automatically.
