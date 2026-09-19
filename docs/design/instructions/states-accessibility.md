# PanganKita States, Accessibility & Content Integrity

Read `docs/DESIGN.md` first.

This file governs responsive behavior, accessibility, localization, system
states, and high-risk copy.

## Responsive baseline

Primary design width:

```text
~390 logical px
```

Must remain usable at:

```text
320
360
390
412 logical px
```

Also verify:

- portrait;
- relevant landscape behavior;
- keyboard open;
- system/safe-area insets;
- increased text scale;
- long Indonesian names;
- long addresses;
- large prices;
- loading/error/empty content.

No page-level horizontal scrolling.

## Accessibility

All affected UI must consider:

- Flutter semantics;
- accessible names;
- screen-reader flow;
- sufficient contrast;
- comfortable touch targets;
- text scaling;
- logical focus order;
- non-color status cues;
- reduced motion;
- readable validation/errors;
- meaningful deadline text.

Interactive targets should normally be at least approximately `48 × 48`
logical pixels.

Icon-only actions require semantic labels.

Critical content must not clip at large text sizes.

## Urgency

Never communicate urgency using color alone.

Use combinations such as:

```text
clock icon + "Pickup sebelum 20.30"
clock icon + "45 menit lagi"
inventory icon + "2 tersisa"
```

Absolute pickup time remains available even when a countdown exists.

Do not use flashing/pulsing urgency.

## Loading state

Prefer:

- simple skeletons;
- preserved valid content during background refresh;
- no indefinite blocking spinner where avoidable.

## Empty state

Use calm, actionable language.

Example:

```text
Belum ada makanan surplus di sekitar sini.
```

Offer one useful next action:

- change area;
- clear filters;
- refresh.

## Error state

Use:

- plain explanation;
- retry where useful;
- preserved context.

Never expose raw technical exceptions.

## Offline state

Explain when authoritative network confirmation is required.

Do not show a mutation as final success before it is authoritative.

## Disabled state

Disabled controls must:

- remain readable;
- have clear state;
- avoid looking broken;
- not be the only mechanism protecting an unauthorized or invalid operation.

UI disablement does not replace backend/domain validation.

## Localization

Primary language:

```text
Bahasa Indonesia
```

Architecture must remain ready for English.

Do not hardcode user-facing strings throughout widgets.

Test long Bahasa Indonesia copy.

Legal/safety wording must not be machine-translated without review.

## Copy tone

Use:

- clear;
- warm;
- practical;
- respectful;
- concise;
- non-judgmental language.

Preferred terms:

```text
Makanan surplus
Makanan yang belum terjual
Pickup sebelum ...
Informasi dari Penjual
Informasi Kondisi Makanan
Informasi Penyimpanan
Informasi Alergen
```

Avoid:

```text
leftovers
makanan sisa orang
waste food
makanan untuk orang miskin
```

Do not use guilt as a conversion tactic.

## Food-safety wording

PanganKita currently does not operate an independent food-safety certification
program.

Never imply:

- PanganKita certified food as safe;
- PanganKita certified merchant hygiene;
- food is guaranteed safe;
- an official hygiene standard exists when it does not.

Avoid:

```text
Mitra Terverifikasi Higienis
Jaminan Higienitas Mitra
100% aman
PanganKita-certified safe
```

Use neutral seller-information language:

```text
Informasi dari Penjual
Informasi Kondisi Makanan
Informasi Penyimpanan
Informasi Alergen
```

A `Terverifikasi` business label is acceptable only when it represents an
implemented business/account verification process.

## Environmental / impact wording

Do not display unsupported conversions such as:

```text
680g CO2e saved
355kg carbon prevented
trees saved
zero-waste achieved
100% environmental impact
hunger reduced
```

unless a later approved methodology supports the exact calculation and claim.

Safe current concepts:

- completed pickups;
- completed portions/quantity;
- listed vs completed quantity;
- estimated consumer savings;
- completed transaction value represented.

Always distinguish:

```text
measured
calculated
estimated
```

## Data honesty in prototypes

Prototype values are illustrative.

Do not make dummy merchant names, ratings, addresses, statistics, or maps look
like verified production evidence outside the prototype context.
