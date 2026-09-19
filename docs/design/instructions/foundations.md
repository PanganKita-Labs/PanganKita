# PanganKita Design Foundations

Read `docs/DESIGN.md` first.

This file contains precise visual-foundation rules for all PanganKita Flutter
screens.

## Brandmark

Use only approved PanganKita logo/icon assets.

The official mark combines a stylized `P`, organic leaf forms, and a hand-held
cloche.

Requirements:

- preserve original proportions;
- preserve official clear space;
- keep the mark at 0 degrees;
- use approved full-color or inverse/white variants;
- maintain approximately 24 logical pixels minimum height when the full mark
  must remain legible.

Never:

- stretch;
- squash;
- rotate;
- unofficially recolor;
- redraw;
- add drop shadows;
- use the logo repeatedly as decoration.

## Canonical color tokens

Primary:

| Token | Name | Hex | Purpose |
|---|---|---:|---|
| `brandPrimary` | Forest Green | `#1B6B3A` | Brand identity, primary actions, selected states |
| `brandAccent` | Warm Orange | `#F5921B` | Urgency, savings, controlled highlights |
| `surfaceWarm` | Soft Cream | `#FAF6F0` | Main warm canvas |

Supporting:

| Token | Name | Hex | Purpose |
|---|---|---:|---|
| `brandPrimaryStrong` | Dark Green | `#0D4D2B` | Pressed/strong green treatment |
| `brandAccentSoft` | Light Orange | `#F8B75C` | Soft accent treatment |
| `textPrimary` | Charcoal | `#2D2D2D` | Main text |
| `borderNeutral` | Light Gray | `#E8E4DF` | Borders/dividers |

Derived neutral UI roles may include:

```text
surface
textSecondary
disabledSurface
disabledText
```

Feature widgets should consume semantic tokens, not repeated raw hex values.

## Functional colors

Functional semantics may extend beyond the brand palette when needed.

Suggested starting roles:

| Role | Suggested value |
|---|---:|
| Success | `#1B6B3A` |
| Warning / urgency | `#F5921B` |
| Danger | `#D32F2F` |
| Information | `#2B6CB0` |

Suggested tints:

```text
successTint #E8F5E9
warningTint #FFF4E5
dangerTint  #FDE8E8
```

Validate actual contrast pairings.

## Color usage

### Soft Cream

Use as the primary page canvas.

### White

Use selectively for:

- listing cards;
- focused information groups;
- forms;
- bottom sheets;
- dialogs;
- pickup-code surfaces.

Do not wrap every row in a white card.

### Forest Green

Use for:

- primary CTA;
- active navigation;
- selected important state;
- key positive/success treatment;
- brand identity.

Do not flood the interface with green.

### Warm Orange

Use selectively for:

- pickup urgency;
- time-sensitive cues;
- savings/discount;
- small emphasis.

Orange is an accent, not a default page background.

## Typography

Official brand typography:

```text
Geist Sans — display/headings
Satoshi    — body/supporting
```

Do not substitute Plus Jakarta Sans, DM Sans, or another family without a
deliberate documented brand decision.

Before bundling font files, verify redistribution/licensing.

Recommended mobile scale:

| Role | Family | Size / line | Weight |
|---|---|---|---|
| Display | Geist Sans | `36 / 44` | 700 |
| Headline L | Geist Sans | `28 / 34` | 700 |
| Headline M | Geist Sans | `22 / 28` | 600 |
| Headline S | Geist Sans | `18 / 24` | 600 |
| Title | Geist Sans | `16 / 24` | 600 |
| Body L | Satoshi | `16 / 24` | 400 |
| Body M | Satoshi | `14 / 20` | 400 |
| Body S | Satoshi | `12 / 16` | 400 |
| Label L | Satoshi | `14 / 20` | 600 |
| Label M | Satoshi | `12 / 16` | 600 |
| Price | Geist Sans | `20 / 24` | 700 |
| Pickup code | Geist Sans | `32 / 40` | 700 |

Use available real font weights rather than synthetic weights.

## Spacing

Use a 4px base rhythm:

```text
space-1   4
space-2   8
space-3  12
space-4  16
space-6  24
space-8  32
space-10 40
```

Page gutter:

```text
default 16
compact 320–360 width: 12 where necessary
```

Prefer whitespace over additional dividers.

## Shape

Canonical radii:

```text
radius-sm      8
radius-md     12
radius-lg     16
radius-xl     24
radius-pill  999
```

Recommended:

- cards: 16;
- buttons/inputs: 12;
- small tags: 8;
- compact chips: pill.

Do not vary radii randomly.

## Elevation and borders

PanganKita uses tonal layering first and shadow second.

Level 0:

```text
Soft Cream page
no shadow
```

Level 1:

```text
white surface
1px Light Gray border
normally no shadow
```

Level 2 is reserved for floating surfaces such as:

- sheets;
- dialogs;
- sticky action bars;
- confirmation overlays.

Use a single subtle ambient shadow only where necessary.

Avoid glassmorphism and dramatic Material elevation.

## Iconography

Use one coherent Flutter-compatible icon family.

Recurring concepts:

- location;
- clock/deadline;
- inventory;
- reservation;
- pickup;
- merchant;
- savings;
- warning;
- information;
- report/support.

Icons support meaning; they are not decoration.

Icon-only controls require semantic labels.

## Photography

Food imagery should make eligible surplus food feel appetizing and normal.

Prefer:

- realistic food;
- natural lighting;
- recognizable portions;
- merchant-relevant presentation.

Avoid imagery that implies:

- trash;
- scraps;
- spoiled food;
- someone else's leftovers.

Verify production asset rights before shipping.

## Motion

Use motion only when it improves understanding.

Good uses:

- reservation confirmation;
- listing published;
- pickup completed;
- bottom-sheet transitions;
- loading-to-content.

Avoid:

- long splash animations;
- decorative bouncing;
- pulsing urgency;
- motion that delays a pickup task.

Respect reduced-motion preferences.
