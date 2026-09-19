# Phase 02 — Consumer Discovery & Listing Detail

**Status:** Blocked by Phase 01
**Scope:** Consumer discovery prototype
**Backend:** Out of scope

## Goal

Implement the first useful consumer journey:

```text
Discover → Listing Detail
```

using deterministic mock listings and the accepted PanganKita design direction.

## Required context

Read:

```text
AGENTS.md
app/AGENTS.md
docs/IMPLEMENTATION.md
this phase file
relevant PRD discovery/listing/search/filter requirements
docs/DESIGN.md
docs/design/instructions/foundations.md
docs/design/instructions/components.md
docs/design/instructions/consumer.md
docs/design/instructions/states-accessibility.md
docs/design/instructions/implementation.md
docs/design/reference/discover.html
docs/design/reference/listing-detail.html
```

Use these PNGs only when genuinely necessary:

```text
docs/design/reference/discover.png
docs/design/reference/listing-detail.png
```

Use Graphify before non-trivial cross-file work.

## In scope

Implement:

- consumer Discover screen;
- selected/current prototype area presentation;
- search UI;
- useful category/filter UI supported by mock data;
- listing-card component(s);
- time-sensitive/nearby section organization;
- listing navigation;
- Listing Detail screen;
- price/original-price/savings presentation;
- merchant identity;
- distance/area;
- quantity/availability;
- pickup window/deadline;
- seller-provided condition/storage/allergen information where fixture supports
  it;
- pickup-location presentation;
- reservation CTA leading to the next-flow boundary;
- loading/empty/error rendering required by these screens.

## Explicitly out of scope

Do not implement yet:

- completed reservation creation;
- pickup QR/code;
- reservation history;
- merchant experience;
- real location permission;
- real geocoding/maps;
- real search service;
- API calls;
- production inventory;
- payment.

The reservation CTA may navigate to a controlled placeholder/boundary for Phase
03, but must not fake a production reservation result.

## Discover hierarchy

Keep the screen centered on marketplace utility.

Priority:

1. area/location context;
2. search;
3. filters/categories;
4. urgent/relevant listings;
5. nearby listings;
6. secondary content.

Optional impact/tips/map teasers may be omitted if they reduce clarity.

Do not reproduce every Stitch section merely because it exists in HTML.

## Listing-card requirements

A user should be able to scan:

```text
food
price
merchant
pickup deadline
distance/area
availability
```

Keep badges/chips restrained.

Use Warm Orange for controlled urgency, not decorative saturation.

## Listing Detail hierarchy

The user should quickly answer:

```text
What is it?
Who sells it?
How much?
Where?
When is pickup?
Can I reserve?
```

Use one obvious reservation CTA.

Seller-provided information must not imply independent PanganKita safety
certification.

## Mock filtering/search

Filtering/search may be local against deterministic fixtures.

Behavior must be predictable and testable.

Avoid fuzzy/AI search in this phase.

## Required states

Cover at least:

- populated;
- empty;
- loading representation;
- recoverable error representation.

Offline-specific refinement belongs to Phase 05 unless already trivial.

## Required tests

Test meaningful behavior such as:

- Discover renders deterministic listings;
- search/filter changes visible results;
- tapping a listing opens the correct detail;
- Listing Detail renders the selected model;
- pickup deadline/price/merchant information is present;
- empty result state works;
- invalid/missing fixture state fails gracefully where applicable.

## Acceptance criteria

- accepted Discover composition is recognizable;
- accepted Listing Detail composition is recognizable;
- implementation is cleaner than generated Stitch markup;
- no hardcoded fixture values are spread across widgets;
- no unsupported safety/environmental claims;
- no real backend dependency;
- design tokens/components are reused instead of duplicated;
- relevant responsive widths remain usable;
- full quality gate passes.

## Exit criteria

Run the full quality gate.

Stop after reporting the diff, tests, and any deliberate deviations from the
reference.

Do not begin Phase 03 automatically.
