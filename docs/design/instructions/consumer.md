# PanganKita Consumer Design Instructions

Read `docs/DESIGN.md` first.

This file governs consumer-facing mobile screens and their hierarchy.

## Consumer navigation

Starting navigation model:

```text
Discover
Reservations
Impact
Profile
```

`Impact` may be demoted or merged later if real product data does not justify a
top-level destination.

## Consumer design priorities

A consumer should quickly understand:

```text
what is available
how much it costs
where it is
when pickup ends
what action is next
```

Price and pickup feasibility outrank decorative sustainability messaging.

## Discover

**Visual reference:** `docs/design/reference/discover.png`

Purpose: show nearby active surplus listings and make pickup feasibility easy to
scan.

Priority:

1. selected/current area;
2. search/discovery;
3. relevant filters/categories;
4. time-sensitive listings;
5. nearby listings;
6. secondary educational/impact content.

Accepted direction:

- Soft Cream canvas;
- restrained white listing cards;
- prominent food imagery;
- Forest Green actions/navigation;
- Warm Orange for controlled urgency;
- compact search and filters;
- consistent bottom navigation.

### Density rule

The Stitch reference still contains several secondary regions.

During Flutter implementation, optional areas such as:

- impact strip;
- tips banner;
- map teaser;

may be demoted, combined, or omitted if they compete with active listings.

Do not remove core listing information.

## Filters

Potential useful filters:

- distance;
- category;
- pickup deadline/time;
- availability;
- price range when genuinely useful.

Do not add a filter for data the product does not reliably have.

## Listing Detail

**Visual reference:** `docs/design/reference/listing-detail.png`

Purpose: let a consumer decide confidently whether to reserve.

Above-the-fold questions:

```text
WHAT?
WHO sells it?
HOW MUCH?
WHERE?
WHEN is pickup?
CAN I reserve?
```

Recommended flow:

```text
food image
→ title + merchant
→ price / savings
→ pickup urgency
→ seller-provided food information
→ pickup location
→ quantity / reservation CTA
```

Use one strong reservation CTA.

Do not duplicate equivalent CTAs within the same viewport unless one is a
deliberate sticky action.

Never imply independent PanganKita food-safety certification.

## Reservation Confirmation

Show:

- item;
- quantity;
- amount;
- merchant;
- pickup location;
- pickup window;
- cancellation information;
- payment-at-pickup explanation;
- Confirm Reservation CTA.

MVP baseline:

```text
reserve in PanganKita
pay at pickup using the merchant's accepted method
```

Do not design an in-app payment gateway as an MVP requirement.

## Active Reservation / Pickup

**Visual reference:** `docs/design/reference/active-reservation-pickup.png`

Purpose: get the user to a successful pickup with minimal ambiguity.

Priority:

1. reservation status;
2. pickup deadline;
3. merchant;
4. location/address;
5. pickup code;
6. amount due;
7. instructions;
8. cancellation/report where allowed.

Requirements:

- code visually dominant;
- absolute deadline impossible to miss;
- countdown may supplement but not replace absolute time;
- location accessible;
- support/report available;
- no unsupported CO2 content;
- no food-safety certification wording.

## Reservation History

Clearly distinguish:

```text
Active
Completed
Cancelled
Expired / No-show
```

Use explicit labels and meaningful empty states.

## Consumer Impact

Keep impact useful but visually secondary to marketplace activity.

Allowed current concepts:

- completed pickups;
- completed portions/quantity;
- estimated money saved where methodology is clear.

Do not show unsupported:

- CO2 avoided;
- trees saved;
- hunger reduced;
- zero-waste claims.

Distinguish measured, calculated, and estimated values.

## Profile / Settings

Potential sections:

- account;
- language;
- location preferences;
- notifications;
- privacy/data controls;
- support/report;
- business entry where appropriate.

Do not ask for profile information without a defined product purpose.

## Consumer future screen derivation

Future consumer screens must use the same foundations/components:

- welcome / role entry;
- auth;
- location setup;
- filters;
- reservation confirmation;
- history;
- impact;
- profile;
- report flow.

Do not create a separate visual language for later consumer features.
