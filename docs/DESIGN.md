# PanganKita Design System & Mobile UX Specification

**Document:** `docs/DESIGN.md`\
**Product:** PanganKita\
**Status:** Design director / orchestration layer\
**Primary implementation:** Flutter, Android-first\
**Primary language:** Bahasa Indonesia\

> **Design principle:** Make time-sensitive surplus food feel valuable, trustworthy, easy to understand, and easy to pick up.

## Purpose

This file is the design director for PanganKita.

It intentionally stays concise. Detailed execution rules live under
`docs/design/instructions/`.

Do not load every design instruction file for every task. Read only the files
relevant to the active work.

## Source-of-truth hierarchy

When design sources disagree, use this order:

1. `PRD.md` — product behavior, scope, state, safety, privacy, and requirements.
2. Official PanganKita Brand Guidelines — logo, palette, typography, brand integrity.
3. `docs/DESIGN.md` — design orchestration and routing.
4. `docs/design/instructions/*.md` — precise visual/interaction execution rules.
5. `docs/design/reference/*.png` — accepted visual composition references.
6. Stitch-generated HTML or generated design metadata — reference only.

The Stitch export is not production source code.

Do not port generated Tailwind/HTML literally into Flutter.

## Accepted visual direction

PanganKita should feel:

- warm;
- calm;
- modern;
- food-oriented;
- approachable;
- trustworthy;
- clean;
- practical;
- locally relevant;
- time-aware without feeling stressful.

It should not look like:

- a university mockup;
- a charity application;
- an environmental-awareness poster;
- a generic green sustainability dashboard;
- a banking dashboard;
- a neon eco-tech product;
- a speculative AI application;
- a clone of another surplus marketplace.

The interface should make these questions immediately understandable:

```text
WHAT food is available
HOW MUCH it costs
WHERE it is
WHEN it must be picked up
```

## Canonical brand summary

Primary palette:

```text
Forest Green  #1B6B3A
Warm Orange   #F5921B
Soft Cream    #FAF6F0
```

Supporting palette:

```text
Dark Green    #0D4D2B
Light Orange  #F8B75C
Charcoal      #2D2D2D
Light Gray    #E8E4DF
```

Typography:

```text
Geist Sans — heading/display
Satoshi    — body/supporting
```

Use only approved PanganKita logo/icon assets.

Never stretch, rotate, unofficially recolor, redraw, or add shadows to the logo.

Brand fidelity never overrides accessibility.

## Design instruction routing

Read the relevant scoped file before implementation:

| Work | Required scoped design file |
|---|---|
| Theme, tokens, color, type, spacing, shape, imagery, motion | `design/instructions/foundations.md` |
| Buttons, cards, inputs, filters, status, pickup code, empty/error UI | `design/instructions/components.md` |
| Consumer navigation and consumer screens | `design/instructions/consumer.md` |
| Merchant/business navigation and screens | `design/instructions/business.md` |
| Responsive behavior, accessibility, localization, safety/impact wording | `design/instructions/states-accessibility.md` |
| Flutter mapping, mock data, Codex context, implementation review | `design/instructions/implementation.md` |

For a cross-cutting task, read each relevant scoped file.

Do not load unrelated scoped files merely for completeness.

## Visual references

Accepted screenshots live under:

```text
docs/design/reference/
├── discover.png
├── listing-detail.png
├── active-reservation-pickup.png
├── merchant-dashboard.png
└── README.md
```

A screenshot is a visual reference, not a pixel-perfect contract.

The Flutter implementation may improve:

- whitespace;
- responsiveness;
- accessibility;
- state clarity;
- copy;
- component consistency;

while preserving the accepted PanganKita visual direction.

Inspect only the screenshot relevant to the current screen unless the task
requires comparison across several screens.

## Product-integrity rules

Do not introduce UI that implies:

- PanganKita independently certifies food safety;
- a merchant is hygiene-certified by PanganKita;
- food is guaranteed safe;
- unsupported CO2/carbon reduction;
- unsupported zero-waste achievement;
- unsupported hunger reduction;
- real payment settlement when MVP uses payment at pickup;
- prototype fixture data is live production data.

Business/account verification may use `Terverifikasi` only when an implemented
business-verification process supports it. It must not imply food-safety
certification.

## Dummy-data rule

The current prototype uses deterministic dummy/mock data.

Do not hardcode fixture values throughout widgets.

Preferred direction:

```text
widget
  ↓
typed model / view model
  ↓
mock repository / deterministic fixture
```

The future backend should be able to replace the mock repository without
redesigning the UI.

## Core UX principles

- Pickup deadline is first-class information.
- Price, food, merchant, location, and deadline outrank decorative impact copy.
- Use one obvious primary action per screen/section where practical.
- Prefer whitespace over extra cards/borders.
- Avoid excessive chips, shadows, and nested containers.
- Use Forest Green and Warm Orange deliberately, not decoratively.
- Never rely on color alone for status or urgency.
- Preserve understandable loading, empty, error, offline, and stale states.
- Keep user-facing copy Bahasa Indonesia-first and localization-ready.
- Do not stigmatize surplus food.
- Do not use guilt as a conversion tactic.

## Codex / AI context protocol

For normal Flutter UI implementation, the coding agent should read:

```text
AGENTS.md
app/AGENTS.md
relevant PRD.md sections
docs/DESIGN.md
relevant docs/design/instructions/*.md files
one relevant docs/design/reference/*.png screenshot
```

Do not load the full Stitch ZIP or all design screenshots for every task.

Examples:

### Discover

Read:

```text
docs/DESIGN.md
docs/design/instructions/foundations.md
docs/design/instructions/components.md
docs/design/instructions/consumer.md
docs/design/instructions/states-accessibility.md
docs/design/instructions/implementation.md
docs/design/reference/discover.png
```

### Merchant dashboard

Read:

```text
docs/DESIGN.md
docs/design/instructions/foundations.md
docs/design/instructions/components.md
docs/design/instructions/business.md
docs/design/instructions/states-accessibility.md
docs/design/instructions/implementation.md
docs/design/reference/merchant-dashboard.png
```

## Conflict resolution

If a screenshot conflicts with `PRD.md`, the PRD wins.

If a screenshot or generated design file conflicts with the official brand
guidelines, the brand guidelines win.

If a scoped design instruction conflicts with this director, preserve the
higher-level source-of-truth order and report the discrepancy.

Do not silently guess.

## Design fidelity

A Flutter implementation is faithful when:

- it clearly looks like PanganKita;
- official brand identity is preserved;
- accepted screen composition is recognizable;
- implementation is cleaner rather than noisier than the reference;
- critical transaction information is easy to scan;
- responsive/accessibility behavior is stronger than the static mockup;
- generated-design mistakes are not copied into production;
- product behavior remains governed by `PRD.md`.

Pixel-perfect reproduction of generated Stitch HTML is not the goal.
