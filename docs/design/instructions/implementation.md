# PanganKita Design Implementation Instructions

Read `docs/DESIGN.md` first.

This file governs Flutter mapping, mock-data architecture, screenshot usage,
Codex context selection, and design-review discipline.

## Flutter implementation principle

The Stitch export is a visual reference, not Flutter source.

Do not port generated HTML/Tailwind literally.

Prefer idiomatic Flutter composition and reusable focused components.

## Theme/token layer

Before building many screens, centralize:

- raw brand colors;
- semantic colors;
- text styles;
- spacing;
- radii;
- component theme defaults;
- focus/error treatment;
- motion durations when used.

Feature widgets should consume semantic tokens rather than raw literals.

Conceptual examples:

```dart
PanganKitaColors.brandPrimary
PanganKitaColors.surfaceWarm
PanganKitaSpacing.md
PanganKitaRadii.card
```

Actual names are implementation decisions.

Keep the token layer small and KISS-compliant.

## Likely shared component responsibilities

Potential reusable pieces:

```text
PanganKita theme
page scaffold
app bar / location header
primary button
secondary button
destructive button
food listing card
price block
deadline indicator
status badge
filter chip
quantity selector
seller information card
pickup code card
empty state
error state
loading skeleton
bottom navigation
section header
metric tile
```

Do not create a god component.

Do not duplicate the same visual primitive per feature.

## Mock / dummy data

Current prototype data is deterministic dummy data.

Examples:

- merchant names;
- user names;
- food names;
- prices;
- discounts;
- addresses;
- pickup times;
- distance;
- map positions;
- inventory;
- reservation codes;
- statistics;
- impact examples.

Illustrative examples such as:

```text
Mon Petit Bakery
PK-7824
Rp 22.000
800 m
```

are not real merchants or transactions.

### Required architecture

Do not hardcode fixture values throughout widgets.

Preferred:

```text
widget
  ↓
typed model / view model
  ↓
mock repository / deterministic fixture
```

Future:

```text
widget
  ↓
same feature/domain contract
  ↓
real repository
  ↓
API/backend
```

The mock repository should be replaceable without redesigning the screen.

## Avoid fake infrastructure

Do not build:

- fake payment gateway;
- fake OAuth server;
- fake distributed backend;
- fake socket system;

just to make the prototype feel production-like.

Use the simplest deterministic state source needed for the design/prototype.

## Design vs domain state

The UI displays state; it does not create authoritative domain truth.

Examples:

- green `Ready` styling does not make a reservation ready;
- a countdown does not override server time later;
- a disabled button does not replace authorization;
- displayed inventory is not reserved until the operation succeeds.

Even local mock transitions should follow plausible PRD state rules.

## Prototype interaction

During the mock phase:

- navigation may use local deterministic fixtures;
- reservation actions may update local mock state;
- listing creation may update in-memory/local fixture state;
- pickup confirmation may simulate valid transitions;
- restart persistence is optional unless the prototype test needs it.

Do not simulate impossible state transitions for convenience.

## Reference screenshots

Canonical selected references:

```text
docs/design/reference/discover.png
docs/design/reference/listing-detail.png
docs/design/reference/active-reservation-pickup.png
docs/design/reference/merchant-dashboard.png
```

Inspect only the screenshot relevant to the active task unless cross-screen
comparison is necessary.

Screenshots are not pixel-perfect contracts.

Flutter may improve:

- whitespace;
- component consistency;
- accessibility;
- responsive behavior;
- copy;
- state clarity.

## Stitch ZIP policy

Do not give Codex the full Stitch ZIP as normal context.

Do not commit generated Stitch HTML solely for coding-agent reference.

Reasons:

- generated HTML/Tailwind is not Flutter implementation;
- generated metadata has conflicting typography;
- generated copy may contain unsupported claims;
- large exports waste context;
- accidental markup details can bias architecture.

Keep:

```text
PRD.md
docs/DESIGN.md
docs/design/instructions/
docs/design/reference/
official brand assets
```

The full Stitch archive may stay outside the repository as an archival source.

## Codex context protocol

For a Flutter design task, normally read:

```text
AGENTS.md
app/AGENTS.md
relevant PRD.md section(s)
docs/DESIGN.md
only relevant design instruction file(s)
one relevant screenshot
```

Examples:

### Discover

```text
docs/DESIGN.md
foundations.md
components.md
consumer.md
states-accessibility.md
implementation.md
reference/discover.png
```

### Listing Detail

```text
docs/DESIGN.md
foundations.md
components.md
consumer.md
states-accessibility.md
implementation.md
reference/listing-detail.png
```

### Merchant dashboard

```text
docs/DESIGN.md
foundations.md
components.md
business.md
states-accessibility.md
implementation.md
reference/merchant-dashboard.png
```

Do not load consumer/business instructions when they are unrelated.

## Design review checklist

Before accepting a screen, verify:

### Product

- matches relevant PRD requirement;
- no post-MVP feature creep;
- mock values come from fixture/model layer;
- state transitions are plausible.

### Brand

- approved logo;
- correct palette;
- Geist Sans + Satoshi;
- no unofficial recolor;
- no excessive green/orange.

### Hierarchy

- primary action obvious;
- pickup deadline visible where relevant;
- price and merchant clear;
- secondary content quieter.

### Cleanliness

- unnecessary card removed;
- unnecessary border removed;
- unnecessary chip removed;
- enough whitespace;
- one dominant CTA where practical.

### Accessibility

- contrast;
- text scaling;
- no color-only meaning;
- touch targets;
- semantic labels;
- narrow-width behavior.

### Product integrity

- no hygiene-certification claim;
- no `100% safe` claim;
- no unsupported CO2 claim;
- no zero-waste claim;
- measured vs estimated distinguished.

### Responsive

- 320;
- 360;
- 390;
- 412 logical px;
- long Bahasa Indonesia;
- keyboard/insets.

## Anti-patterns

Do not:

- reproduce every Stitch container literally;
- nest excessive cards;
- shadow every element;
- turn every label into a chip;
- overuse Warm Orange;
- place sustainability statistics above food/price/deadline;
- add AI labels or fake smart scores;
- present illustrative data as live;
- imply real payment settlement;
- imply PanganKita food-safety certification;
- hardcode fixtures throughout widgets;
- treat screenshots as more authoritative than the PRD.

## Fidelity standard

A Flutter implementation is faithful when:

- it clearly looks like PanganKita;
- brand identity is preserved;
- accepted composition is recognizable;
- implementation is cleaner than the static reference where possible;
- critical transaction information is easy to scan;
- responsive/accessibility behavior is stronger than the screenshot;
- generated-design mistakes are not copied;
- product behavior remains governed by `PRD.md`.

Pixel-perfect reproduction of generated Stitch HTML is not the goal.
