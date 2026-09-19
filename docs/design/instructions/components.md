# PanganKita Design Components

Read `docs/DESIGN.md` and `foundations.md` first when component styling is
relevant.

## Component philosophy

Prefer reusable, focused Flutter components.

Do not:

- create a universal component with dozens of optional parameters;
- create one-off copies of the same visual primitive per feature;
- nest card inside card inside card without a clear hierarchy need;
- turn every label into a pill;
- shadow every surface.

## Primary CTA

Use for the single main action on a screen.

Examples:

```text
Reservasi
Konfirmasi Reservasi
Tandai Siap
Verifikasi Pickup
Buat Listing
Publikasikan
```

Style:

- Forest Green;
- white label;
- approximately 48 logical px minimum height;
- 12 radius or controlled pill shape;
- obvious disabled state;
- strong contrast.

Pressed state may use Dark Green.

## Secondary CTA

Use for secondary actions:

- edit;
- see location;
- adjust;
- navigation.

Prefer:

- white/cream surface;
- Forest Green text/border.

## Destructive CTA

Use only for genuinely destructive actions:

- cancel reservation;
- cancel listing;
- remove data.

Danger treatment must not visually dominate normal primary flow.

## Inputs

Default:

- white surface;
- Light Gray border;
- ~48 logical px target height;
- 12 radius;
- Charcoal input text;
- clear placeholder;
- Forest Green focus state.

Validation:

- explain the issue in text;
- place error near the affected field;
- do not rely on red outline alone.

## Search

Search should be immediately understandable and visually quieter than actual
listing content.

Do not allow a search container to dominate the Discover hierarchy.

## Chips and filters

Use for compact choices such as:

- category;
- distance;
- pickup time;
- availability.

Rules:

- avoid excessive chip rows;
- selected state must use label + surface/color;
- do not use chips as decorative status everywhere;
- critical information must not exist only inside horizontally scrolling chips.

## Status system

### Listing

```text
Draft
Active
Sold Out
Expired
Cancelled
```

### Reservation

```text
Reserved
Ready for Pickup
Completed
Cancelled
No-show / Expired
```

Never show contradictory states.

Never rely only on color.

## Food listing card

The listing card is the core Discover component.

Information priority:

1. food image;
2. listing/food name;
3. surplus price;
4. original price / savings;
5. pickup deadline;
6. distance/area;
7. merchant;
8. quantity/availability;
9. urgency cue.

Visual direction:

- white surface;
- 16 radius;
- subtle neutral border;
- normally no shadow;
- controlled food-image clipping;
- concise metadata;
- one or two badges maximum where possible.

Do not let sustainability copy outrank food, price, or deadline.

### Price presentation

Recommended:

```text
Rp 22.000       ← primary
Rp 50.000       ← muted / strikethrough
Hemat 56%       ← optional compact cue
```

Do not invent deceptive discount values.

## Pickup deadline component

Pickup deadline is first-class information.

Use:

- clock icon;
- absolute deadline;
- optional remaining time.

Example:

```text
Pickup sebelum 20.30
45 menit lagi
```

If space is constrained, retain the absolute deadline.

Do not use flashing/pulsing urgency.

## Seller food-information card

Purpose: structure seller-provided information without implying certification.

Potential fields:

- condition;
- packaging;
- storage;
- allergen;
- preparation/production info when applicable;
- pickup/consumption note when approved.

Clearly label seller-provided information.

Do not overload feed cards with all safety fields.

## Pickup code card

Display:

- reservation status;
- merchant;
- absolute pickup deadline;
- short code;
- QR when implemented;
- amount due;
- concise instruction.

Example:

```text
SIAP DIAMBIL

PK-7824

Tunjukkan kode ini kepada kasir
sebelum 20.30
```

Pickup code typography must be highly legible.

Do not imply payment is already settled when the MVP uses pay-at-pickup.

## Quantity control

Quantity controls must:

- show current value clearly;
- expose disabled min/max state;
- have large enough touch targets;
- never imply authoritative inventory mutation until the domain operation
  succeeds.

## Metric tile

Use only for meaningful operational/impact metrics.

Good:

```text
4 pesanan selesai
4 dari 6 porsi diambil
1 porsi masih tersedia
```

Avoid unsupported environmental or zero-waste claims.

## Empty state

Use a calm explanation and one useful next action.

Example:

```text
Belum ada makanan surplus di sekitar sini.
```

Possible actions:

- change area;
- clear filters;
- refresh.

## Loading

Prefer:

- simple skeleton;
- preserved valid content during refresh;
- no indefinite spinner where avoidable.

## Error

Use:

- plain-language explanation;
- retry where useful;
- preserved context.

Never show raw exceptions.

## Offline

Explain when authoritative actions require network confirmation.

Do not visually show a reservation/pickup mutation as final success while the
authoritative operation has not succeeded.
