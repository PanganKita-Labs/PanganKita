# PanganKita — Product Requirements Document

**Document type:** Product Requirements Document (PRD)\
**Product:** PanganKita\
**Organization:** PanganKita Labs / `PanganKita-Labs`\
**Version:** 0.1\
**Status:** Implementation-ready baseline for prototype and MVP validation\
**Last updated:** 2026-09-19\
**Primary platform:** Flutter mobile application\
**Primary market:** Indonesia\
**Primary operating model:** Hyperlocal, pickup-first surplus-food marketplace\
**Primary SDG alignment:** SDG 12 — Responsible Consumption and Production, especially Target 12.3\

> **Core product principle:** Make saving eligible food easier than wasting it.

---

# 1. Document Control

## 1.1 Purpose

This PRD defines the product, engineering, quality, research, design, safety, and validation requirements for PanganKita.

It is intended to be usable by:

- product and project owners;
- Flutter developers;
- future backend developers;
- UI/UX designers;
- QA/testers;
- research team members;
- project supervisors/lecturers;
- future open-source contributors.

The document is deliberately more rigorous than a classroom feature list. It is intended to support a path from:

```text
research
→ prototype
→ MVP
→ hyperlocal pilot
→ evidence collection
→ product refinement
→ technical research
→ possible thesis contribution
```

## 1.2 Review cadence

Review this PRD:

- after major primary research;
- after any regulatory or food-safety validation;
- before committing major architectural dependencies;
- before pilot launch;
- after a meaningful pilot;
- before public beta;
- before thesis/research evaluation.

## 1.3 Approval responsibilities

| Area | Primary owner | Required reviewers |
|---|---|---|
| Product scope | Product/Lead Developer | UI/UX, Research, QA |
| Flutter architecture | Lead Developer | QA / technical reviewer |
| Food-safety requirements | Product + Research | qualified regulatory/domain source |
| Research methodology | Research owner | supervisor/lecturer where applicable |
| UI/UX | UI/UX owner | Product, QA |
| Release readiness | Lead Developer + QA | Product owner |
| Privacy/security | Lead Developer | QA / reviewer |
| Brand interpretation | UI/UX owner | project/team owner |

## 1.4 Change history

| Version | Date | Summary |
|---|---|---|
| 0.1 | 2026-09-19 | First integrated implementation-ready PRD from project brief, research, differentiation work, brand guidelines, and engineering decisions |

---

# 2. Executive Summary

PanganKita is an Indonesia-first, hyperlocal surplus-food marketplace designed to help food businesses recover value from eligible unsold food by connecting it with nearby consumers who can realistically pick it up before the listing deadline.

The product is not intended to solve all food waste in Indonesia. It targets a narrower and more measurable problem: **eligible food that remains unsold within a short selling window and risks losing commercial value or becoming waste because nearby demand is not connected quickly enough.**

The basic loop is:

```text
Business has eligible unsold food
            ↓
Creates a time-limited listing
            ↓
Nearby consumer discovers it
            ↓
Consumer reserves available quantity
            ↓
Business prepares the order
            ↓
Consumer picks up within the window
            ↓
Pickup is confirmed
            ↓
Transaction and impact are recorded
```

The marketplace concept itself is not novel. Surplus-food commerce already exists in Indonesia and internationally. PanganKita therefore must not position itself as “the first surplus-food app” or as a copy of an existing marketplace.

Its proposed product and research wedge is:

1. **food-only, time-critical focus;**
2. **hyperlocal pickup-first operation;**
3. **clear eligibility, deadline, and seller-provided food-information structure;**
4. **urgency-aware and pickup-feasibility-aware discovery/ranking;**
5. **measurable transaction, sell-through, pickup, and expiry outcomes;**
6. **a reusable, explainable matching/research engine that can be evaluated against simple baselines.**

The ranking concept is a hypothesis, not a proven advantage. PanganKita should compare conventional ranking such as newest-first, nearest-first, or highest-discount-first against a transparent urgency/pickup-feasibility approach.

The immediate product goal is not national scale. It is to prove that a small local marketplace can repeatedly complete the loop:

```text
eligible surplus
→ listing
→ discovery
→ reservation
→ pickup
→ recorded outcome
```

If that loop cannot be proven with real businesses and consumers, the team should reconsider the product or research direction rather than expanding feature scope.

---

# 3. Organization and Product Identity

## 3.1 Organization

**Organization name:** PanganKita Labs\
**GitHub organization:** `PanganKita-Labs`

**Organization description:**\
Building technology that gives surplus food a second chance before it becomes waste.

## 3.2 Product

**Product name:** PanganKita

**Product description:**\
PanganKita is a hyperlocal surplus-food marketplace that helps food businesses recover value from eligible unsold food by connecting it with nearby consumers before the pickup deadline.

## 3.3 Vision

Contribute to a food system in which edible surplus is more likely to retain value and reach people than become avoidable waste.

## 3.4 Mission

Build and validate practical digital tools that make time-sensitive surplus food easier for businesses to list, easier for nearby consumers to discover and reserve, and easier to measure after successful pickup.

## 3.5 Core values

- **Practical value first:** sustainability must be supported by a useful transaction, not guilt-based messaging.
- **Trust:** food information, deadlines, merchant identity, and transaction states must be clear.
- **Evidence:** distinguish measured outcomes from assumptions and estimates.
- **Responsibility:** food safety, privacy, accessibility, and security are product requirements.
- **Simplicity:** saving eligible food should require less friction than discarding it.
- **Transparency:** ranking, impact metrics, limitations, and research claims should be explainable.
- **Local proof before scale:** validate a small operating loop before designing national infrastructure.

## 3.6 Brand promise

**Turn Surplus Into Value.**

For businesses: recover value before eligible unsold food loses it.\
For consumers: access quality-positioned food at a more affordable price nearby.\
For the system: keep more eligible food in the consumption cycle and measure what actually happens.

## 3.7 Stakeholder value proposition

| Stakeholder | Value |
|---|---|
| Food business | Additional channel for eligible unsold stock, potential revenue recovery, simpler time-limited listing and pickup management |
| Consumer | Nearby discounted food, clear pickup timing, transparent seller/listing information |
| Research team | Measurable marketplace outcomes, testable ranking hypotheses, reproducible technical evaluation |
| Platform operator | Structured data about listings, reservations, pickups, expirations, reports, and marketplace health |
| Society / environment | Potential reduction in avoidable disposal of eligible unsold food, without claiming to solve all food waste |

---

# 4. Brand System and Design Constraints

The supplied PanganKita brand guidelines are the canonical visual identity.

## 4.1 Logo meaning

The brandmark combines:

- a stylized letter **P**;
- organic leaf forms;
- a hand-held food cloche.

The mark communicates a connected food ecosystem, food-cycle continuity, care, trust, collaboration, and service that helps surplus food reach the right people at the right time.

## 4.2 Official colors

### Primary palette

| Token role | Brand color | Hex |
|---|---|---|
| Primary | Forest Green | `#1B6B3A` |
| Accent | Warm Orange | `#F5921B` |
| Background / warm surface | Soft Cream | `#FAF6F0` |

### Supporting and neutral palette

| Brand color | Hex |
|---|---|
| Dark Green | `#0D4D2B` |
| Light Orange | `#F8B75C` |
| Charcoal | `#2D2D2D` |
| Light Gray | `#E8E4DF` |

The app should map these raw values into semantic theme roles rather than scattering literal colors through widgets.

Suggested semantic roles:

```text
brandPrimary
brandPrimaryStrong
brandAccent
brandAccentSoft
surfaceWarm
surface
surfaceMuted
textPrimary
textSecondary
border
success
warning
danger
focus
```

Status colors that are not part of the supplied brand palette may be introduced only where necessary for accessibility and clear semantics. They must not visually compete with the brand.

## 4.3 Typography

**Primary font:** Geist Sans\
**Supporting font:** Satoshi

Brand reference scale:

| Role | Brand reference |
|---|---|
| H1 | Geist, 40px reference |
| H2 | Geist, 28px reference |
| H3 | Satoshi, 20px reference |
| Body | Satoshi, 15px reference |
| Caption | Satoshi, 12px reference |

These are brand references, not fixed mobile pixel sizes. Flutter typography must support text scaling and platform accessibility.

Font licensing and redistribution must be verified before bundling font files into the repository or application.

## 4.4 Logo usage

Requirements:

- use approved PanganKita logo assets;
- preserve aspect ratio;
- preserve clear space based on the guideline’s `X` rule;
- minimum on-screen logo height: approximately **24px**;
- do not stretch;
- do not rotate;
- do not recolor outside approved variants;
- do not add drop shadows to the logo;
- use the appropriate full-color or inverse/white asset for contrast.

## 4.5 Product visual direction

The product should feel:

- warm;
- trustworthy;
- practical;
- modern;
- food-oriented;
- local;
- approachable;
- clear under time pressure.

Avoid:

- “charity app” visual language;
- guilt-driven waste imagery;
- excessive greenwashing;
- generic neon eco-tech gradients;
- dark cyber/AI styling;
- excessive illustrations that hide important timing, stock, or pickup information;
- random brand-color usage for decoration.

---

# 5. Problem Background

## 5.1 Terminology

### Food loss

Food loss generally refers to reductions in food quantity or quality earlier in the supply chain, such as production, post-harvest, storage, processing, and related stages.

### Food waste

Food waste is associated with later stages including retail, food service, and consumers.

### Food surplus

For PanganKita, **food surplus** means food that a business has not sold within its expected selling flow but that may still be eligible for sale/consumption according to applicable business and food-safety requirements.

Surplus is not automatically waste.

Surplus is not automatically safe.

Surplus is not equivalent to previously served food.

## 5.2 Indonesian context

Bappenas’ study for **2000–2019** estimated Indonesia’s food loss and waste at approximately **23–48 million tonnes per year**, equivalent to **115–184 kg per capita per year**, with estimated economic losses of **Rp213–551 trillion per year**. The same study identifies consumption as the stage with the largest estimated FLW generation. These numbers are historical estimates for 2000–2019 and must not be presented as exact current-2026 measurements.

The product does not target the entire FLW system. It focuses on a narrower part of food-service/retail surplus before disposal.

## 5.3 SDG context

UN SDG Target 12.3 calls for halving per-capita global food waste at retail and consumer levels by 2030 and reducing food losses along production and supply chains.

PanganKita aligns most directly with the **retail/food-service waste prevention logic** of SDG 12.3, but should not claim that use of the app itself proves material contribution to a national SDG target. Impact must be measured.

---

# 6. Problem Statement

## 6.1 Primary problem

Some food businesses have eligible unsold food with a short remaining selling/pickup window but lack a sufficiently fast, low-friction mechanism to expose that supply to nearby demand before the food loses value or is discarded.

## 6.2 Secondary problems

### Business side

- end-of-day or time-sensitive unsold inventory;
- unpredictable demand;
- limited time to manually advertise surplus;
- potential revenue loss;
- operational burden of coordinating ad-hoc buyers;
- uncertainty around food-safety communication;
- difficulty measuring recovered value or rescued quantity.

### Consumer side

- affordable food offers may be fragmented across stores or social channels;
- nearby surplus availability is hard to discover;
- timing may be unclear;
- consumers may distrust the meaning of “surplus”;
- pickup feasibility is not guaranteed merely because an item is nearby;
- food information, seller identity, price, and pickup deadline may be inconsistent.

### Marketplace side

- supply is perishable and time-bound;
- local liquidity matters;
- listings can expire quickly;
- reservation/no-show behavior can destroy value;
- overselling is unacceptable;
- distance alone is not enough if remaining pickup time is short.

## 6.3 Root causes to validate

- forecasting/production mismatch;
- inconsistent demand;
- weak last-minute discovery;
- operational friction;
- fragmented communication channels;
- insufficient consumer trust;
- inconvenient pickup windows;
- low local marketplace liquidity.

These are not equally validated for every target business. Primary research must identify which are materially important in the pilot segment.

---

# 7. Research and Validation Summary

## 7.1 Supported context

- Indonesia has a material FLW problem according to historical Bappenas estimates.
- Consumption is a major FLW stage in the cited Bappenas study.
- Surplus-food commerce already exists.
- Surplus Indonesia is a direct Indonesian reference/competitor.
- Current public Surplus materials show merchant surplus uploads, substantial discounting, e-wallet payment, pickup, and delivery.
- Surplus’ consumer app has expanded beyond food into broader recommerce/clearance categories.
- SDG 12.3 is a defensible primary sustainability alignment.

## 7.2 Research findings requiring methodology context

Existing project research suggests:

- affordability may be a stronger immediate consumer motivation than environmental concern;
- merchants may value recovered revenue and operational simplicity;
- disposal may be easier than redistribution because redistribution adds discovery, communication, and pickup friction.

These should guide hypotheses and design, not be presented as universal truths about Indonesian consumers or businesses.

## 7.3 Unvalidated assumptions

- target businesses generate eligible surplus frequently enough to sustain a marketplace;
- consumers trust surplus-food listings;
- consumers will travel for pickup;
- businesses will accept the listing workflow;
- businesses will accept discounting without harming their normal pricing strategy;
- local supply and demand can reach sufficient liquidity;
- seller-provided safety/eligibility information can be standardized practically.

## 7.4 Product hypotheses

**H-PROD-01** — Simple hyperlocal listing and reservation can reduce friction relative to ad-hoc disposal or social posting.

**H-PROD-02** — Clear deadline, seller, price, and food-information presentation increases user trust.

**H-PROD-03** — Pickup-first operation is viable for a constrained local pilot.

**H-RANK-01** — Urgency/pickup-feasibility-aware ranking can reduce the proportion of listings that expire without successful pickup compared with simple baselines.

**H-RANK-02** — Pickup feasibility is more useful than raw distance alone for time-sensitive listings.

---

# 8. Product Goals

The MVP should optimize for successful completion of the marketplace loop.

## 8.1 Primary goals

- enable a business to create a valid surplus listing quickly;
- make active local listings discoverable;
- enable reservation without overselling;
- communicate pickup timing clearly;
- enable reliable pickup confirmation;
- close/expire listings correctly;
- record measurable outcomes;
- create enough operational evidence to evaluate the product.

## 8.2 Secondary goals

- establish user trust;
- keep merchant workflow lightweight;
- make error/recovery states understandable;
- create a data foundation for ranking evaluation;
- provide an open-source-quality engineering baseline.

## 8.3 Not a goal

“Number of downloads” alone is not a success metric.

---

# 9. Non-Goals

The initial MVP will **not** attempt to provide:

- national coverage;
- courier/delivery integration;
- a full payment gateway;
- complex merchant settlement;
- donation routing;
- volunteer coordination;
- animal-feed routing;
- compost routing;
- meal planning;
- recipes;
- food social network/feed;
- complex chat;
- restaurant POS replacement;
- ERP/inventory-management replacement;
- automated forecasting suite;
- dynamic pricing;
- opaque AI recommendations;
- advertising marketplace;
- subscription tiers;
- loyalty/gamification as a core requirement;
- advanced ratings/reviews unless validated as necessary;
- background continuous location tracking.

---

# 10. Target Users

Do not treat illustrative demographics as validated segments. The following are behavioral/user-role profiles.

## 10.1 Food business operator

### Context

Restaurant, café, bakery, dessert shop, culinary UMKM, or later another eligible food retailer with time-sensitive unsold inventory.

### Goals

- avoid losing all value from unsold food;
- list surplus quickly;
- control quantity;
- communicate pickup window clearly;
- avoid overselling;
- verify pickup;
- understand recovered value/outcomes.

### Pain points

- limited time;
- staff workload;
- uncertainty of demand;
- manual buyer coordination;
- no-shows;
- safety/trust concerns.

### Motivation

Primary proposed motivation: value recovery with low operational friction.

### Success

A listing can be created, reserved, handed over, and recorded with minimal disruption to normal operations.

## 10.2 Nearby value-conscious consumer

### Context

A consumer willing to pick up discounted food locally.

### Goals

- find relevant nearby food;
- understand price savings;
- know whether pickup is realistic;
- reserve confidently;
- collect without confusion.

### Fears

- poor food quality;
- unclear food condition;
- hidden restrictions;
- missing pickup instructions;
- arriving too late;
- reservation not honored.

### Success

The consumer discovers a suitable listing, understands timing and seller information, reserves, and completes pickup without unexpected friction.

## 10.3 Sustainability-motivated consumer

Same functional needs as the value-conscious consumer, but additional motivation may include reducing avoidable waste.

The product must not assume this motivation is universal.

## 10.4 Business owner / manager

Needs oversight beyond staff operations:

- business identity;
- staff permissions;
- listing performance;
- recovered value;
- activity history;
- issue handling.

## 10.5 Platform admin

Internal operational role responsible for:

- business review;
- reports;
- moderation;
- account/listing enforcement;
- safety escalation;
- audit review.

The first admin interface may be an internal tool rather than part of the consumer Flutter navigation.

---

# 11. Jobs to Be Done

## 11.1 Business

**When** I have eligible unsold food with limited time remaining,\
**I want to** create a clear time-limited offer quickly,\
**so that** I have a realistic chance to recover value before disposal.

**When** customers reserve surplus,\
**I want to** know quantity, pickup status, and deadline,\
**so that** staff can prepare the order without overselling.

**When** the customer arrives,\
**I want to** confirm the correct reservation quickly,\
**so that** the transaction closes with a reliable record.

## 11.2 Consumer

**When** I want affordable food nearby,\
**I want to** discover eligible time-limited offers I can realistically reach,\
**so that** I can reserve food before it is gone.

**When** I view a surplus listing,\
**I want to** understand what I am buying, why it is discounted, who sells it, and when I must collect it,\
**so that** I can decide confidently.

**When** I have a reservation,\
**I want to** see clear pickup instructions and status,\
**so that** I do not miss the window.

---

# 12. Core User Journeys

## 12.1 Business onboarding

```text
Open app
→ choose business mode
→ create/sign in account
→ enter business identity
→ add business location
→ submit required verification information
→ verification state shown
→ approved business can create listings
```

MVP may use manual verification during the pilot.

## 12.2 Create listing

```text
Business dashboard
→ Create listing
→ add photo
→ enter item/title/category
→ original price
→ surplus price
→ quantity
→ pickup start
→ pickup deadline
→ seller-provided food information
→ preview
→ publish
→ ACTIVE
```

## 12.3 Consumer discovery

```text
Open app
→ location context
→ discover active listings
→ ranking/filtering
→ tap listing
→ inspect details
→ choose quantity
→ reserve
→ reservation confirmed
```

## 12.4 Pickup

```text
Reservation
→ merchant marks READY
→ consumer travels to business
→ consumer presents pickup code
→ merchant validates code
→ transaction becomes COMPLETED
→ inventory/outcome/impact records finalized
```

## 12.5 Listing expiry

```text
ACTIVE listing
→ pickup deadline passes
→ listing becomes EXPIRED
→ no new reservation allowed
→ remaining quantity recorded as expired/unsold
```

The system must not infer that expired food is necessarily discarded. “Expired listing” means the PanganKita selling/pickup window ended.

## 12.6 Consumer cancellation

```text
RESERVED
→ consumer cancels within allowed policy
→ reservation CANCELLED
→ quantity restored atomically if applicable
```

## 12.7 No-show

```text
RESERVED / READY
→ pickup deadline passes
→ no pickup confirmed
→ reservation NO_SHOW or EXPIRED based on policy
→ inventory handling follows explicit business rule
```

Exact no-show/restock behavior requires pilot policy validation.

## 12.8 Report/problem flow

```text
listing/reservation/business
→ Report problem
→ choose category
→ add description/evidence where appropriate
→ submit
→ acknowledgement
→ admin review
→ resolution/audit record
```

---

# 13. Information Architecture and Screen Inventory

This section is intentionally suitable for a UI/UX designer or Google Stitch handoff.

## 13.1 App model

**Proposed MVP design:** one Flutter application with role-aware experiences for Consumer and Business.

Admin tools are separate/internal.

This decision should be revisited if business workflows become materially different enough to justify a separate merchant application.

## 13.2 Consumer navigation

Recommended bottom navigation:

```text
Discover
Reservations
Impact
Profile
```

“Impact” may be hidden or merged into Profile if early testing shows it adds clutter before meaningful data exists.

### Required consumer screens

**C-01 Splash / launch**
- PanganKita logo
- minimal loading
- no marketing carousel delay

**C-02 Welcome / role introduction**
- plain-language explanation
- continue as consumer
- business entry point
- sign-in/register access

**C-03 Authentication**
- exact auth method is implementation decision
- clear privacy expectations
- no unnecessary profile questions

**C-04 Location setup**
- explain why location improves nearby discovery
- permission request only after explanation
- manual area selection fallback
- denial must not dead-end the app

**C-05 Discover**
- current area
- nearby listing feed
- strong pickup deadline visibility
- distance/ETA when available
- price and discount
- quantity state
- business name
- category
- urgency indicator using text + icon, not color alone
- search/filter access
- loading/empty/error states

**C-06 Filters**
- distance/radius
- category
- pickup deadline/time
- price range if useful
- availability
- optional dietary/allergen filters only if data quality supports them

**C-07 Listing detail**
- item name/photo
- merchant name
- original price
- surplus price
- savings
- available quantity
- distance / location
- pickup start
- pickup deadline
- seller-provided food information
- allergen/storage fields when applicable
- why discounted / surplus explanation
- quantity selector
- Reserve CTA
- report listing action
- clear note that availability is time-sensitive

**C-08 Reservation confirmation**
- item
- quantity
- price
- pickup location
- pickup window
- cancellation policy
- payment handling
- confirm reservation

**MVP payment baseline:** PanganKita does not process payment. Payment is handled by the merchant at pickup using the merchant’s accepted method. This must be communicated clearly. A payment gateway is post-MVP.

**C-09 Reservation detail**
- status
- pickup code/QR or short code
- business address
- pickup instructions
- pickup window
- countdown/remaining time presented accessibly
- quantity
- amount due at pickup
- cancel action where allowed
- report problem

**C-10 Reservation history**
- active
- completed
- cancelled
- expired/no-show
- filters optional

**C-11 Consumer impact**
- completed rescued portions/quantity where measured
- estimated money saved
- measured vs estimated label
- no unsupported CO2 claim

**C-12 Profile/settings**
- account
- language
- location preference
- notification preferences
- privacy/data controls
- support/report
- role/business entry if allowed

## 13.3 Business navigation

Recommended bottom navigation:

```text
Listings
Reservations
Impact
Business
```

### Required business screens

**B-01 Business onboarding**
- business name
- category/type
- address/location
- contact
- verification fields
- seller responsibility acknowledgement

**B-02 Verification status**
- pending
- approved
- rejected / needs changes
- action required

**B-03 Business dashboard / listings**
- Active
- Drafts
- Closed
- Create listing CTA
- summary counts

**B-04 Create listing**
Prefer a short, understandable form rather than a long wizard unless usability testing proves steps are clearer.

Fields:
- photo
- listing title
- category
- short description
- original price
- surplus price
- quantity
- pickup start
- pickup deadline
- seller-provided condition/eligibility acknowledgement
- relevant storage information
- relevant allergen information
- pickup notes

**B-05 Listing preview**
- consumer-facing preview
- validation summary
- Publish CTA

**B-06 Listing detail/manage**
- status
- quantity available/reserved/completed
- deadline
- edit allowed fields
- quantity update
- cancel listing
- reservation summary
- performance/outcome after close

Critical fields must become restricted after reservations exist.

**B-07 Reservations queue**
- new/reserved
- ready
- completed
- cancelled/no-show
- deadline ordering

**B-08 Reservation detail**
- code
- customer display identifier
- quantity
- item
- pickup window
- mark ready
- verify pickup
- report issue

**B-09 Pickup verification**
- enter/scan pickup code
- show reservation summary
- confirm handoff
- clear success state
- duplicate code submission must not duplicate completion

**B-10 Business impact**
- completed quantity/portions
- sell-through
- expired/unsold listed quantity
- revenue recovered
- pickup completion
- cancellation/no-show
- all values labeled measured vs calculated

**B-11 Business profile/settings**
- location
- operating information
- staff/membership later
- accepted payment-at-pickup methods
- notification settings
- support

## 13.4 Common system screens/states

- no network;
- server unavailable;
- location denied;
- no nearby listings;
- no reservations;
- listing expired while viewing;
- quantity changed before reservation confirmation;
- reservation conflict/out-of-stock;
- account suspended;
- verification pending;
- report submitted;
- app update required later.

---

# 14. UX Principles

1. **Time must be visible.** Pickup deadline is a primary information element, not metadata hidden below the fold.
2. **Price must be clear.** Show original and surplus price without misleading discount presentation.
3. **Trust before conversion.** Merchant identity, location, food information, and pickup rules should be visible before reservation.
4. **Do not shame users.** Sustainability is a benefit, not a moral test.
5. **Do not stigmatize surplus.** Avoid “leftover from someone else” framing.
6. **Reduce merchant effort.** Listing creation should require only information that materially supports sale, safety, pickup, or measurement.
7. **Use progressive disclosure.** Do not overload feed cards with every food-safety field.
8. **Accessible urgency.** Never rely on orange/red color alone for urgency; include words such as “Pickup by 20:30”.
9. **Preserve valid content during refresh.** Avoid disruptive loading if existing data can remain visible.
10. **Every destructive action needs clarity.** Cancellation, closing listings, and account actions require confirmation when consequence is meaningful.

---

# 15. Functional Requirements

Priority uses:

- **MUST** — required for the coherent MVP/pilot loop
- **SHOULD** — important but may be deferred from first prototype
- **COULD** — optional/post-MVP

## 15.1 Consumer requirements

| ID | Priority | Requirement | Acceptance criteria / key edge cases |
|---|---|---|---|
| FR-CNS-001 | MUST | Consumer can discover active listings relevant to a selected/current area | Expired/cancelled listings are not reservable; denial of location offers manual fallback |
| FR-CNS-002 | MUST | Feed shows price, business, distance/location context, quantity status, and pickup deadline | Deadline cannot be hidden behind secondary interaction |
| FR-CNS-003 | MUST | Consumer can open a listing detail | Detail reflects latest availability or clearly handles stale data |
| FR-CNS-004 | MUST | Consumer can select valid reservation quantity | Cannot exceed available quantity |
| FR-CNS-005 | MUST | Consumer can create a reservation | Concurrent requests cannot oversell |
| FR-CNS-006 | MUST | Consumer receives reservation status and pickup instructions | Includes business location and pickup window |
| FR-CNS-007 | MUST | Consumer can cancel when policy allows | Quantity restoration is atomic and rules-based |
| FR-CNS-008 | MUST | Consumer can present a unique pickup code | Code cannot complete wrong reservation |
| FR-CNS-009 | MUST | Consumer can view reservation history | States are clear and not contradictory |
| FR-CNS-010 | MUST | Consumer can report listing/reservation problems | Report has category, description, timestamp, related object |
| FR-CNS-011 | SHOULD | Consumer can filter nearby listings | Filters preserve accessible empty-state explanation |
| FR-CNS-012 | SHOULD | Consumer sees basic personal impact | Metrics must label measured/calculated values |
| FR-CNS-013 | COULD | Consumer receives notifications | Permission requested contextually; notification absence must not break core flow |

## 15.2 Business requirements

| ID | Priority | Requirement | Acceptance criteria / key edge cases |
|---|---|---|---|
| FR-BIZ-001 | MUST | Business account can submit onboarding/verification data | Approval required before live listing if policy says so |
| FR-BIZ-002 | MUST | Approved business can create draft listing | Required fields validated |
| FR-BIZ-003 | MUST | Business can publish valid listing | Deadline must be future and valid |
| FR-BIZ-004 | MUST | Listing includes original price, surplus price, quantity, location, pickup window | Money representation safe; quantity positive |
| FR-BIZ-005 | MUST | Business provides required seller food information | Exact mandatory fields require safety validation |
| FR-BIZ-006 | MUST | Business can update available quantity without violating reservations | Quantity cannot drop below already-reserved amount |
| FR-BIZ-007 | MUST | Business can see reservations for its listings | Cross-business data inaccessible |
| FR-BIZ-008 | MUST | Business can mark reservation ready | Only legal state transition accepted |
| FR-BIZ-009 | MUST | Business can verify pickup code and complete reservation | Duplicate verification is idempotent |
| FR-BIZ-010 | MUST | Business can cancel listing subject to reservation constraints | Existing reservations handled explicitly |
| FR-BIZ-011 | MUST | Business can see listing outcomes | Completed, expired, cancelled, sold-out state/reason distinguishable |
| FR-BIZ-012 | SHOULD | Business can view impact/performance summary | No unsupported environmental conversions |
| FR-BIZ-013 | COULD | Business owner can manage staff | Least privilege; post-MVP unless pilot requires |

## 15.3 Admin requirements

| ID | Priority | Requirement | Acceptance criteria / key edge cases |
|---|---|---|---|
| FR-ADM-001 | MUST for pilot | Admin can review business verification | Decision and actor timestamp recorded |
| FR-ADM-002 | MUST for pilot | Admin can review submitted reports | Related user/business/listing/reservation visible according to permissions |
| FR-ADM-003 | MUST for pilot | Admin can suspend/limit accounts/listings | Action requires reason and audit event |
| FR-ADM-004 | MUST for pilot | Admin can inspect relevant audit history | Sensitive data minimized |
| FR-ADM-005 | SHOULD | Admin can manage moderation queue | Prioritization transparent |
| FR-ADM-006 | SHOULD | Admin can reverse incorrect moderation where allowed | Appeals/correction recorded |

## 15.4 System requirements

| ID | Priority | Requirement | Acceptance criteria / key edge cases |
|---|---|---|---|
| FR-SYS-001 | MUST | Listing becomes non-reservable after deadline | Enforced server-side for pilot |
| FR-SYS-002 | MUST | Reservation inventory mutation is atomic | Concurrent test cannot oversell |
| FR-SYS-003 | MUST | Illegal state transitions fail closed | Stable error returned |
| FR-SYS-004 | MUST | Critical mutation retries are safe | Repeated pickup confirmation does not double-count |
| FR-SYS-005 | MUST | Measured impact record is generated from completed transaction | No impact credited for cancelled/no-show |
| FR-SYS-006 | MUST | Access follows role/ownership permissions | IDOR attempts rejected |
| FR-SYS-007 | MUST | Expired/cancelled listing hidden from active discovery | History still available to authorized actor |
| FR-SYS-008 | SHOULD | System records ranking exposure/position for experiments | Privacy-safe; only when research mode enabled |
| FR-SYS-009 | SHOULD | System supports deterministic ranking baseline | Same inputs produce same ordering except explicit tie-break |
| FR-SYS-010 | COULD | System supports experiment assignment | Must not silently manipulate results or user safety |

---

# 16. MVP Definition

The MVP exists to prove one coherent transaction loop.

## 16.1 In MVP

### Consumer

- account/authentication;
- location selection/permission;
- nearby listing discovery;
- simple filters;
- listing detail;
- reservation;
- reservation status;
- pickup code;
- cancellation policy;
- history;
- report/problem flow;
- basic impact summary.

### Business

- account/business onboarding;
- pilot verification;
- create listing;
- original/surplus price;
- quantity;
- pickup window/deadline;
- seller-provided food information;
- listing management;
- reservation queue;
- mark ready;
- pickup verification;
- listing close/expiry;
- basic outcome/impact summary.

### Platform

- role/ownership authorization;
- authoritative inventory;
- listing/reservation state;
- expiry;
- atomic reservation;
- audit-sensitive events;
- basic admin moderation;
- basic analytics;
- privacy-safe logging;
- hyperlocal ranking baseline.

## 16.2 Payment baseline

**MVP default:** reservation in PanganKita, payment at pickup through the merchant’s normal accepted method.

Reason:

- validates the core surplus-matching loop;
- avoids premature payment gateway and settlement complexity;
- reduces regulatory/financial integration surface;
- keeps prototype/pilot focused.

This must be validated with pilot merchants before public beta.

## 16.3 Explicitly post-MVP

- in-app payment gateway;
- delivery/courier;
- donation fallback;
- repurpose network;
- dynamic pricing;
- advanced recommendation/ML;
- forecasting;
- full staff organization model;
- loyalty;
- public social features;
- subscriptions;
- multi-city scaling.

---

# 17. Competitive Analysis

Competitor information changes quickly and must be re-audited before formal external claims.

## 17.1 Surplus Indonesia — verified baseline

Public app-store information in 2026 indicates:

- a consumer clearance/recommerce application;
- marketplace ordering;
- timed store pickup;
- merchant-side surplus/overstock upload;
- merchant discounts up to 80% in current merchant material;
- e-wallet support including GoPay, OVO, ShopeePay, and DANA;
- pickup and delivery through services such as GrabExpress and GoSend;
- consumer app expansion beyond food into beauty, fashion, home, mart, vouchers, and other clearance categories;
- public community/forum functionality.

Implication: **listing, discounting, payment, pickup, delivery, and surplus commerce are not PanganKita differentiators by themselves.**

## 17.2 Direct in-store discounting

Strength:
- simple;
- no platform fee;
- familiar.

Weakness/opportunity:
- discovery depends on already being at the store;
- difficult to aggregate nearby time-sensitive offers.

## 17.3 Social media / messaging

Strength:
- businesses already use it;
- low setup.

Weakness:
- unstructured;
- weak inventory/reservation state;
- difficult discovery;
- difficult measurement.

## 17.4 Donation channels

Strength:
- social benefit;
- can redirect usable food.

Different objective:
- not primarily designed for business value recovery or commercial surplus purchase.

Donation is future recovery-ladder scope, not MVP core.

## 17.5 General food-delivery platforms

Strength:
- large user base;
- established payment/logistics.

Different optimization:
- not necessarily designed around short-lived surplus inventory and rescue-before-deadline measurement.

Do not claim they cannot support discounts or time-based offers.

---

# 18. Competitive Differentiation

PanganKita differentiation must be framed as a **focused product/research hypothesis**, not as superiority by assertion.

## 18.1 Product differentiation

### Food-only, time-critical vertical

Keep product/data/UI optimized for perishable/time-limited food rather than general clearance inventory.

### Hyperlocal pickup-first

Reduce operational scope and study whether nearby pickup is viable for short windows.

### Deadline as first-class information

Pickup deadline is central in:

- feed;
- detail;
- reservation;
- merchant operations;
- expiry;
- ranking.

### Structured seller-provided food-information card

Use a consistent listing structure so the consumer does not have to infer what “surplus” means.

## 18.2 Technical differentiation

**Urgency + pickup-feasibility ranking**

Candidate concept:

```text
remaining pickup time
+ travel distance / ETA
+ available quantity
+ pickup-window feasibility
+ listing age
+ demand signals
+ category relevance
        ↓
transparent score
        ↓
listing ordering
```

The MVP may begin with a simple deterministic formula and configurable weights.

## 18.3 Research differentiation

PanganKita can test whether a time-sensitive ranking policy changes outcomes compared with:

- newest-first;
- nearest-first;
- highest-discount-first.

That comparison is more defensible than claiming an “AI-powered marketplace.”

## 18.4 Brand differentiation

PanganKita should emphasize:

- care;
- trust;
- timing;
- practical value;
- food-specific design;
- Indonesian context;
- “Turn Surplus Into Value.”

---

# 19. What PanganKita Is Not

PanganKita is not:

- a charity platform;
- a poverty-relief program;
- a claim to solve Indonesian food waste;
- a delivery-first marketplace;
- a generic discount marketplace;
- a restaurant POS;
- an inventory ERP;
- a meal planner;
- a recipe app;
- an AI chatbot;
- a social network;
- a sustainability score gimmick;
- a replacement for food-safety responsibility;
- a guarantee that every seller-provided item is safe;
- a national-scale product before a local marketplace loop is proven.

---

# 20. Matching / Ranking Engine

## 20.1 Purpose

Increase the chance that a relevant listing is reserved and picked up before its window closes without creating unsafe or opaque behavior.

## 20.2 Baselines

At minimum support offline/research comparison against:

1. newest-first;
2. nearest-first;
3. highest-discount-first;
4. proposed urgency + pickup-feasibility ranking.

## 20.3 Candidate features

- remaining time until pickup deadline;
- consumer-to-business distance;
- estimated travel time where available;
- available quantity;
- listing age;
- pickup start/end;
- recent demand;
- category relevance/preferences;
- merchant open/availability state.

## 20.4 Initial design principles

- deterministic;
- explainable;
- testable;
- configurable;
- no black-box model required;
- no protected/sensitive personal attributes;
- no paid-placement contamination in research ranking.

## 20.5 Example conceptual score

Not final:

```text
score =
    urgency_weight * urgency_score
  + feasibility_weight * pickup_feasibility
  + proximity_weight * proximity_score
  + demand_weight * demand_signal
  + relevance_weight * category_relevance
```

Exact normalization, weights, and cutoffs are research parameters.

## 20.6 Hard constraints

A listing must not be ranked as eligible if:

- inactive;
- expired;
- cancelled;
- quantity unavailable;
- pickup impossible according to hard system rules;
- business unavailable/suspended.

## 20.7 Explainability

UI should use understandable cues such as:

- “Pickup by 20:30”
- “1.2 km away”
- “Only 2 left”

Do not expose a meaningless “AI score.”

## 20.8 Telemetry for evaluation

When research consent/privacy allows:

- ranking method/version;
- listing IDs exposed;
- position;
- reservation outcome;
- time-to-reservation;
- pickup outcome;
- expiry;
- distance/ETA bucket rather than unnecessary precise location;
- experiment cohort.

---

# 21. Food Safety and Eligibility

This section is mandatory and intentionally conservative.

**Important:** exact eligibility rules require validation against applicable Indonesian regulation, official guidance, pilot business practices, and domain expertise. Do not invent BPOM or Kementerian Kesehatan rules.

## 21.1 Product-level eligibility principles

A listing should only be publishable when the seller declares that the food is eligible under the approved PanganKita policy.

The policy should validate, where applicable:

- item has not been served to another consumer;
- item remains within the seller’s allowed selling/consumption period;
- relevant storage/handling expectations were maintained;
- pickup deadline is defined;
- food condition is accurately represented;
- required allergen information is provided;
- relevant storage/consumption guidance is provided.

These are product principles, not legal conclusions.

## 21.2 Ineligible examples

Until a validated policy states otherwise:

- previously served food;
- food the seller cannot reasonably identify;
- food outside the business’s permitted selling/consumption period;
- food with known unsafe handling;
- recalled products;
- items whose required information cannot be provided;
- items prohibited by applicable law/policy.

Exact category exclusions require validation.

## 21.3 Listing food-information card

Potential fields:

- item name;
- category;
- seller;
- seller-provided condition statement;
- production/preparation time when relevant;
- storage information when relevant;
- allergen information when relevant;
- pickup start;
- pickup deadline;
- suggested consumption guidance when appropriate;
- seller responsibility statement.

Exact mandatory fields are **REQUIRES FOOD-SAFETY/REGULATORY VALIDATION**.

## 21.4 Safety incident flow

A safety-related report should:

- be easy to access;
- capture listing/reservation/business context;
- preserve evidence where appropriate;
- alert admin with higher priority;
- create an audit record;
- support immediate listing/business restrictions where justified;
- preserve appeal/review process for enforcement decisions.

---

# 22. Trust and Safety

Threats include:

- fake listings;
- stolen business identity;
- misleading photos;
- inaccurate food information;
- unsafe food;
- duplicate accounts;
- reservation abuse;
- no-shows;
- harassment;
- spam;
- fraudulent reports;
- account takeover;
- ratings manipulation if ratings are added.

Requirements:

- verified business state for pilot;
- clear report paths;
- audit trail for enforcement;
- least-privilege moderation;
- reason codes;
- no automatic punitive decision solely from unverified report volume;
- suspension/restriction states;
- correction/appeal path where appropriate.

---

# 23. Business Rules

## 23.1 Core rules

**BR-001** — A listing cannot accept reservations after its pickup deadline.

**BR-002** — Available quantity cannot be negative.

**BR-003** — Reserved quantity cannot exceed available quantity.

**BR-004** — Reservation creation and inventory decrement must be atomic in the authoritative backend.

**BR-005** — A reservation cannot transition through an illegal state sequence.

**BR-006** — A pickup code may complete only its associated active reservation.

**BR-007** — Repeated pickup confirmation must be idempotent.

**BR-008** — Cancelled reservation inventory is restored only when cancellation policy allows and the listing can still accept reservations.

**BR-009** — Listing expiry must prevent new reservations regardless of stale client UI.

**BR-010** — A suspended business cannot create/activate listings.

**BR-011** — A consumer cannot mutate another consumer’s reservation.

**BR-012** — A business can access reservations only for businesses it is authorized to manage.

**BR-013** — Critical listing fields may be restricted from editing after reservations exist.

**BR-014** — Price cannot be negative.

**BR-015** — Surplus price should not exceed original/reference price unless product rules explicitly allow and explain it.

**BR-016** — Impact credit is generated only from a completed pickup, not reservation creation.

**BR-017** — An expired listing is not automatically classified as discarded food; remaining quantity is “expired/unsold on PanganKita” unless disposal is explicitly recorded.

**BR-018** — Precise consumer location must not be exposed to merchants.

**BR-019** — Ranking must never override hard eligibility, authorization, inventory, or deadline rules.

**BR-020** — Payment is not recorded as settled by PanganKita in MVP unless the platform actually processes/verifies it.

---

# 24. Listing State Machine

Recommended MVP listing states:

```text
DRAFT
  ↓ publish
ACTIVE
  ├─→ SOLD_OUT
  ├─→ EXPIRED
  └─→ CANCELLED
```

Optional terminal summary state may be added later only if it provides meaningful business logic.

## 24.1 State semantics

### DRAFT
Not discoverable. Editable by authorized business user.

### ACTIVE
Discoverable and reservable while:
- current time < deadline;
- business/listing allowed;
- inventory available.

### SOLD_OUT
No remaining reservable quantity.

### EXPIRED
Pickup/listing deadline passed.

### CANCELLED
Business/admin intentionally closed listing.

Partial reservation is represented by inventory counts while state remains `ACTIVE`; do not create a contradictory `PARTIALLY_RESERVED` state unless implementation proves it necessary.

---

# 25. Reservation State Machine

Recommended MVP:

```text
RESERVED
   ├─→ READY_FOR_PICKUP
   │       ├─→ COMPLETED
   │       └─→ NO_SHOW / EXPIRED
   ├─→ CANCELLED
   └─→ EXPIRED
```

## 25.1 RESERVED

Inventory has been atomically reserved.

## 25.2 READY_FOR_PICKUP

Merchant indicates order is ready.

## 25.3 COMPLETED

Pickup code was validated and handoff recorded.

This is the event that produces completed transaction/impact credit.

## 25.4 CANCELLED

Reservation cancelled under policy.

## 25.5 NO_SHOW

Pickup window ended without successful handoff where policy distinguishes no-show.

## 25.6 EXPIRED

System-expired reservation where applicable.

A separate `Report/Dispute` entity is preferred over making `DISPUTED` a reservation state, because disputes can exist while preserving the underlying transaction state.

---

# 26. Roles and Permissions

## 26.1 Roles

- Consumer
- Business Owner
- Business Staff — post-MVP unless pilot requires
- Admin

## 26.2 Permission matrix

| Capability | Consumer | Business Owner | Business Staff | Admin |
|---|---:|---:|---:|---:|
| Browse active listings | ✓ | ✓ | ✓ | ✓ |
| Reserve listing | ✓ | optional | optional | no |
| View own reservation | ✓ | no | no | privileged |
| Create business listing | no | ✓ | scoped | privileged |
| Update own business listing | no | ✓ | scoped | privileged |
| View business reservations | no | ✓ | scoped | privileged |
| Confirm pickup for business | no | ✓ | scoped | privileged |
| Manage business membership | no | ✓ | no | privileged |
| Review reports | no | no | no | ✓ |
| Suspend listing/account | no | no | no | ✓ |
| View audit records | no | limited own history | limited | ✓ |

Backend authorization is mandatory for pilot/production.

---

# 27. Conceptual Data Model

## 27.1 Core entities

### User
- id
- display name
- contact/auth references
- locale
- status
- created_at

### Business
- id
- legal/display name
- category
- contact
- status
- verification state
- location reference
- created_at

### BusinessMembership
- user_id
- business_id
- role
- status

### BusinessVerification
- business_id
- submitted fields/doc refs
- status
- reviewer
- reason
- timestamps

### Location
- coordinates where necessary
- address/display area
- geospatial indexing fields
- precision/visibility policy

### FoodListing
- id
- business_id
- title
- description
- category
- photo(s)
- original_price
- surplus_price
- pickup_start
- pickup_deadline
- state
- created_at
- activated_at
- closed_at
- food-information fields

### ListingInventory
- listing_id
- initial_quantity
- available_quantity
- reserved_quantity
- completed_quantity
- version/concurrency field if needed

### Reservation
- id
- user_id
- listing_id
- quantity
- unit_price snapshot
- state
- pickup_code
- timestamps
- cancellation/no-show reason

### Report
- reporter
- subject type/id
- category
- description
- evidence refs
- state
- moderation outcome

### ImpactRecord
- reservation_id
- measured quantity/portion
- merchant revenue recovered
- consumer savings calculation
- measurement source
- timestamp

### AuditEvent
- actor
- action
- object
- reason
- timestamp
- metadata with privacy limits

### Notification
- user
- type
- object reference
- delivery state

### RankingEvent
- ranking version
- candidate/listing
- position
- coarse context
- experiment metadata
- outcome linkage

## 27.2 Constraints

- money must not use binary floating point;
- inventory cannot be negative;
- foreign ownership relationships enforced;
- unique pickup code securely generated;
- timestamps unambiguous;
- precise location exposure minimized;
- audit metadata must not contain secrets.

---

# 28. Non-Functional Requirements

## 28.1 Performance

Proposed product targets for pilot, subject to measurement:

- common screen interactions should feel immediate;
- cached/local UI response should not block on unnecessary network calls;
- API latency targets should be defined once backend hosting/reference environment exists;
- image loading must not block essential text;
- feed should paginate rather than fetch unbounded listings.

Do not invent production SLOs before infrastructure is measurable.

## 28.2 Reliability

- reservation/inventory correctness has priority over optimistic speed;
- stale clients must receive safe conflict responses;
- failure must not create duplicate reservations;
- retry of idempotent actions should be safe;
- critical state must survive app restart.

## 28.3 Scalability

MVP architecture must support a hyperlocal pilot without designing a national distributed system prematurely.

## 28.4 Maintainability

- feature-first architecture;
- strict linting;
- typed models;
- explicit domain behavior;
- architectural decisions documented;
- minimal dependencies;
- tests alongside behavior.

## 28.5 Offline/network behavior

MVP does not require full offline marketplace operation.

Requirements:
- clear offline state;
- existing reservation details may be cached securely where useful;
- reservation creation/completion requires authoritative confirmation;
- do not show a local action as successful before authoritative result unless clearly pending.

## 28.6 Device scope

Android is primary during early development/pilot.

Architecture remains Flutter cross-platform, but no requirement exists to validate every platform before the Android pilot.

---

# 29. Accessibility

PanganKita must use WCAG-aligned mobile practices.

Requirements:

- Flutter Semantics for meaningful controls;
- accessible names for icon-only buttons;
- sufficient contrast;
- information not conveyed by color alone;
- text scaling without clipped critical information;
- logical focus;
- comfortable tap targets;
- reduced-motion consideration;
- accessible error messages;
- countdown/urgency information available as text;
- images must not carry essential information without text alternative/context.

Representative UI widths for testing:

```text
320
360
390
412 logical pixels
```

Accessibility is part of feature completion, not a final polish phase.

---

# 30. Localization

## 30.1 Language

- Bahasa Indonesia: primary
- English: architecture-ready

## 30.2 Requirements

- no hardcoded user-facing strings once real UI begins;
- Flutter localization infrastructure;
- localized validation/error messages;
- localized semantic labels;
- locale-aware date/time/currency display;
- long Indonesian copy must be tested;
- legal/safety copy must not be machine-translated without review.

---

# 31. Privacy

PanganKita follows least-data principles.

## 31.1 Likely data classes

- account identifiers;
- business identity;
- business location;
- consumer selected/current location context;
- reservation history;
- reports;
- analytics events;
- device notification token if notifications enabled.

## 31.2 Location requirements

- location permission requested only when feature needs it;
- manual area fallback;
- no continuous background location in MVP;
- do not expose consumer precise location to businesses;
- avoid logging raw coordinates;
- retain only what has a defined purpose.

## 31.3 Analytics privacy

- no passwords/tokens;
- no unnecessary precise coordinates;
- no unrestricted free-text personal data;
- event schemas defined before implementation;
- research use must follow consent/approved methodology where required.

## 31.4 Legal review

Any claim of compliance with Indonesian personal-data law requires proper legal review. This PRD does not claim compliance merely by design intent.

---

# 32. Security

Threat-model at least:

- account takeover;
- broken authentication;
- broken authorization;
- IDOR;
- business impersonation;
- API abuse;
- brute force;
- enumeration;
- injection;
- malicious file upload;
- image decompression bombs;
- malicious filenames;
- secrets leakage;
- token theft;
- replay/duplicate mutation;
- rate-limit bypass;
- precise-location exposure;
- privilege escalation;
- spam.

Requirements:

- server-side authorization;
- secure transport;
- secure secret management;
- no secrets in repository;
- secure token storage on device using an appropriate mechanism when auth exists;
- rate limiting for abuse-prone endpoints;
- validation at trust boundaries;
- stable error handling without leaking internals;
- audit trail for sensitive admin actions;
- dependency review in CI.

---

# 33. File / Image Upload Rules

When listing photos are implemented:

- allowed image MIME types only;
- extension validation;
- magic-byte validation;
- actual image decode validation;
- maximum file size;
- maximum dimensions/megapixels;
- generated storage filename;
- metadata/EXIF policy;
- strip sensitive metadata where appropriate;
- object-storage access policy;
- signed URLs where appropriate;
- retention/deletion behavior;
- deny executable or arbitrary file uploads;
- consider image-bomb/resource exhaustion;
- do not trust client MIME header alone.

Exact limits require implementation benchmarking and backend selection.

---

# 34. Observability

For pilot/production:

- structured logs;
- privacy-safe request IDs;
- crash/error reporting;
- backend health/readiness;
- latency/error metrics;
- reservation/inventory conflict metrics;
- notification failure metrics;
- storage/upload failures;
- alerting appropriate to deployment maturity.

Never log:

- passwords;
- access tokens;
- authorization headers;
- private food/report content unnecessarily;
- precise consumer location unless explicitly required and protected.

---

# 35. Analytics

Potential events:

```text
app_opened
listing_created
listing_activated
listing_viewed
listing_reserved
reservation_cancelled
reservation_ready
pickup_completed
reservation_no_show
listing_expired
listing_sold_out
report_submitted
food_rescued_recorded
```

Each event should define:

- trigger;
- actor;
- properties;
- forbidden properties;
- retention;
- product purpose;
- research purpose if applicable.

Do not instrument every tap.

---

# 36. Impact Measurement

## 36.1 Measured values

Prefer directly recorded values:

- completed reservations;
- completed portions/quantity;
- listed quantity;
- expired/unsold PanganKita quantity;
- reservation-to-pickup completion;
- sell-through;
- merchant revenue represented by completed reservations;
- listing frequency.

## 36.2 Calculated values

Examples:

**Consumer savings**

```text
(original unit price - surplus unit price)
× completed quantity
```

**Revenue recovered**

```text
surplus unit price
× completed quantity
```

If payment is not processed by PanganKita, this is **transaction value represented by completed pickup**, not independently verified settlement.

## 36.3 Estimated values

Any weight, portion conversion, CO2-equivalent, or broader environmental estimate must:

- identify methodology;
- identify assumptions;
- be labeled estimated;
- not be mixed with measured values.

No unsupported CO2 claim in MVP.

---

# 37. SDG Alignment

## Primary

**SDG 12 — Responsible Consumption and Production**\
**Target 12.3**

PanganKita addresses one narrow part of the broader target: time-sensitive eligible unsold food in food-service/retail contexts before disposal.

## Secondary/supporting

Potential relationships may exist with:

- SDG 8 — value recovery/economic activity;
- SDG 9 — digital infrastructure/innovation;
- SDG 13 — only where environmental impact is measured with defensible methodology;
- SDG 2 — affordability/access may be relevant, but PanganKita is not a hunger-eradication or food-aid program.

Do not present secondary SDGs as achieved merely because the product exists.

---

# 38. Future Research / Thesis Path

## 38.1 Primary research question

**Can urgency-aware and pickup-feasibility-aware ranking improve successful surplus-food redistribution compared with conventional ranking in a hyperlocal marketplace?**

## 38.2 Hypothesis

A ranking policy that incorporates remaining pickup time and feasibility will reduce listing expiry without successful pickup and/or improve successful pickup rate compared with simple baselines.

## 38.3 Independent variable

Ranking method:

- newest-first;
- nearest-first;
- highest-discount-first;
- urgency + pickup feasibility.

## 38.4 Dependent variables

- sell-through before deadline;
- successful pickup rate;
- expired listing rate;
- median time-to-reservation;
- cancellation/no-show rate;
- average pickup distance/ETA;
- revenue recovered;
- rescued quantity/portions.

## 38.5 Evaluation stages

```text
synthetic simulation
→ controlled prototype experiment
→ pilot data
→ statistical / operational evaluation
```

## 38.6 Research integrity

- predefine metrics;
- record algorithm/version;
- preserve negative results;
- no cherry-picking;
- report confidence/uncertainty;
- avoid tuning on the final evaluation set;
- document dataset limitations.

## 38.7 Thesis kill/pivot criteria

Pivot the thesis direction if:

- real surplus supply is too rare;
- consumer trust is too low;
- pickup windows are operationally infeasible;
- competitor workflow eliminates the proposed research gap;
- ranking improvement is negligible;
- data volume is insufficient for meaningful evaluation;
- food-safety/legal burden makes a pilot unrealistic.

The Flutter app alone is not the thesis contribution.

---

# 39. Technical Architecture

## 39.1 Repository model

```text
PanganKita/
├── .github/
├── AGENTS.md
├── app/          Flutter client
├── docs/         product/engineering documentation
├── research/     research assets when needed
└── backend/      introduced when implementation begins
```

Do not create unnecessary empty architecture merely because a future directory is listed.

## 39.2 Prototype architecture

A UI prototype may run with deterministic mock/local data.

Purpose:
- validate flows;
- validate terminology;
- validate information hierarchy;
- validate accessibility;
- run usability tests.

Do not confuse a mock prototype with marketplace validation.

## 39.3 Pilot/MVP architecture

A real multi-user pilot requires an authoritative backend.

```text
Flutter app
    ↓ HTTPS
API / application layer
    ↓
auth + authorization
    ↓
domain rules / reservations / inventory
    ↓
relational persistence
    ↓
object storage for images
```

Supporting services as justified:

- push notifications;
- geocoding/maps;
- analytics;
- crash reporting;
- monitoring.

## 39.4 Backend technology

Not yet fixed.

Selection requires ADR based on:

- team capability;
- concurrency correctness;
- ecosystem maintenance;
- testing;
- deployment;
- observability;
- long-term contributor clarity.

A relational database such as PostgreSQL is a reasonable **proposal** for reservation/inventory integrity, geospatial support, constraints, and research queries, but must be approved through architecture decision.

## 39.5 Object storage

Use object storage for listing images rather than application filesystem.

## 39.6 Authentication

Provider/implementation not yet selected.

Requirements:
- secure token/session lifecycle;
- least privilege;
- server-side authorization;
- account recovery plan;
- no custom insecure cryptography.

---

# 40. Flutter Architecture Rules

## 40.1 Toolchain baseline

Current project baseline:

```text
Flutter 3.47.4
Dart 3.13.3
```

Do not upgrade silently.

## 40.2 Architecture

Feature-first and shallow.

Indicative shape:

```text
lib/
├── main.dart
├── app/
├── core/
└── features/
    ├── discovery/
    ├── listings/
    ├── reservations/
    └── pickup/
```

Do not pre-create every feature/layer before it exists.

## 40.3 Dependency direction

```text
UI
↓
feature state/orchestration
↓
domain behavior
↓
repository/service contract
↓
remote/local adapter
```

## 40.4 State management

Not yet selected.

Decision requirements:
- actual feature complexity;
- explicit async/error states;
- testability;
- lifecycle safety;
- community maintenance;
- minimal framework lock-in.

Do not add a state-management dependency only because it is popular.

## 40.5 Routing

Do not introduce routing complexity until navigation requirements justify it.

## 40.6 Models

- typed;
- immutable where practical;
- no raw JSON throughout UI;
- avoid `dynamic`;
- isolate serialization boundaries.

## 40.7 Error handling

UI receives actionable typed/well-defined states rather than raw exceptions.

## 40.8 No global mutable state

Global state must be deliberately scoped and justified.

---

# 41. Engineering Quality Standard

Current quality stack:

- Very Good Analysis `11.0.0`
- Dart Code Linter `4.3.0`
- Dartrics `1.4.0`
- strict Dart analyzer

Analyzer strict modes:

```text
strict-casts
strict-inference
strict-raw-types
```

Current complexity policy:

```text
cognitive complexity
  warning: 10
  error: 15

cyclomatic complexity
  warning: 10
  error: 15

number of parameters
  warning: 4
  error: 6

method length
  warning: 50
  error: 80
```

Rules:

- `dart format` must pass;
- analyzer infos/warnings are fatal in CI;
- lint violations are not casually suppressed;
- no broad ignore blocks;
- dead/unused code should not merge;
- no production `print`/`debugPrint` outside approved logging;
- no commented-out code as storage;
- no secrets;
- async context/lifecycle safety required;
- listeners/subscriptions disposed;
- no duplicate-action races;
- dependencies require rationale;
- `pubspec.lock` remains tracked;
- public docs follow configured lint expectations;
- generated files are not manually edited where codegen exists.

---

# 42. Testing Strategy

Testing grows with real behavior.

## 42.1 Unit tests

Required for:

- domain validation;
- state transitions;
- inventory;
- reservation rules;
- money calculations;
- ranking;
- serialization;
- permissions where represented in shared/domain code;
- impact calculations.

## 42.2 Widget tests

Required for important UI:

- validation;
- loading;
- empty;
- error;
- semantics;
- time/deadline presentation;
- navigation-critical behavior.

## 42.3 Integration tests

When backend/repositories exist:

- auth lifecycle;
- listing creation;
- listing expiry;
- reservation;
- inventory concurrency;
- cancellation;
- pickup completion;
- reports;
- API contracts.

## 42.4 End-to-end tests

**Decision:** E2E is intentionally deferred during initial scaffold/prototype development.

E2E becomes mandatory when PanganKita has a stable, working end-to-end user journey worth automating.

Priority future E2E scenarios:

- business creates listing;
- consumer discovers it;
- consumer reserves;
- inventory updates;
- merchant marks ready;
- pickup completes;
- impact recorded;
- cancellation;
- listing expiration;
- oversell race;
- unauthorized mutation rejected;
- recovery from network failure.

Do not build expensive emulator CI before the journey exists.

## 42.5 Golden tests

Use selectively for stable, visually important components. Do not golden-test the entire app.

## 42.6 Accessibility tests

Include semantics and text scaling for critical screens.

## 42.7 Security tests

Backend/API must cover authorization, validation, object ownership, rate limits, and upload restrictions.

---

# 43. Coverage Policy

Do not optimize for meaningless 100% coverage.

Priority coverage:

- reservation/inventory domain;
- listing/reservation state machines;
- ranking;
- money/impact calculations;
- authorization;
- food-safety-related validation;
- upload validation;
- security-sensitive parsing.

Do not introduce a global percentage threshold before meaningful code exists.

Later policy may include module-specific floors for critical domain logic.

---

# 44. Current Flutter Quality Commands

From `app/`:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
dart run dart_code_linter:metrics analyze --fatal-style --fatal-performance --fatal-warnings lib
dart run dart_code_linter:metrics check-unused-code --analyze-private-members lib
dart run dart_code_linter:metrics check-unused-files lib
dart run dart_code_linter:metrics check-unnecessary-nullable lib
dart run dartrics analyze lib
flutter test
```

A task cannot claim these passed unless they actually ran successfully.

---

# 45. Continuous Integration

Current/planned baseline workflows:

```text
quality.yml
android-build.yml
dependency-review.yml
lychee.yml
workflow-lint.yml
```

## 45.1 Quality

- pinned Flutter;
- dependency install from lockfile;
- format verification;
- analyzer;
- DCL;
- Dartrics;
- unused-code/files/nullability checks;
- tests with coverage output.

## 45.2 Android build

Debug build validation catches Gradle/native breakage.

## 45.3 Dependency review

PR dependency changes should be checked for known vulnerabilities.

## 45.4 Lychee

Documentation link validation.

## 45.5 Workflow lint

GitHub Actions workflow validation.

## 45.6 Dependabot

**Deferred.**

Enable once real development introduces a meaningful dependency surface and automated update PRs become more valuable than noisy.

## 45.7 E2E CI

Deferred until stable app flow exists.

---

# 46. CI Quality Gates

A required PR must not merge when a required check fails.

Blocking once applicable:

- formatting;
- analyzer;
- lint;
- complexity error thresholds;
- tests;
- Android build;
- lockfile consistency;
- dependency review according to configured severity;
- workflow validation when workflows change.

E2E becomes blocking only after the E2E suite is officially adopted.

---

# 47. Branch and Pull Request Policy

Target mature policy:

- protected `main`;
- development through PRs;
- required CI;
- at least one review where team availability permits;
- no routine direct pushes to `main`;
- Conventional Commits;
- focused PRs;
- PR title suitable for squash merge.

Format:

```text
type(scope): summary
```

Examples:

```text
feat(listings): add pickup deadline validation
fix(reservations): prevent inventory oversell
test(ranking): cover urgency scoring boundaries
```

Bootstrap work may temporarily precede full branch protection, but the mature policy should be enabled before multi-contributor feature development accelerates.

---

# 48. Definition of Done

A feature is not done because “it works on my phone.”

Done means, where applicable:

- acceptance criteria met;
- product rules correct;
- UI reviewed;
- accessibility considered;
- loading/empty/error/retry states handled;
- localization-ready;
- tests added;
- format passes;
- analyzer/lint passes;
- relevant complexity gate passes;
- backend authorization tested;
- privacy/security considered;
- food-safety implications reviewed;
- analytics updated only if justified;
- documentation updated;
- CI green;
- manual verification recorded.

E2E is included only after E2E becomes part of the active project gate.

---

# 49. Dependency Management

Rules:

- minimum necessary dependencies;
- prefer maintained packages;
- review license;
- track lockfiles;
- review breaking changes;
- avoid abandoned packages;
- no package solely for trivial utility;
- architectural dependencies require documented rationale;
- no automatic major upgrades without review;
- no “latest” floating version policy for reproducible CI.

---

# 50. Open-Source Strategy

Potential repository story:

> An open-source surplus-food matching research platform with a Flutter reference application.

This is stronger developer value than a CRUD marketplace alone.

Potential future reusable components:

```text
surplus_matching_engine/
simulation/
benchmark/
fixtures/
rules/
```

Do not create these until the research/architecture actually needs them.

Expected OSS documentation over time:

- README.md
- CONTRIBUTING.md
- CODE_OF_CONDUCT.md
- SECURITY.md
- ARCHITECTURE.md
- TESTING.md
- ADRs
- API documentation
- research methodology
- release notes/changelog

License requires explicit team approval.

---

# 51. Developer Value

A developer who never uses the marketplace should still be able to find technical value in:

- deterministic ranking engine;
- scenario simulator;
- benchmark suite;
- concurrency-safe reservation design;
- reproducible experiment fixtures;
- documented policy/state-machine examples;
- high-quality Flutter reference architecture;
- research methodology connecting marketplace optimization with measurable outcomes.

Do not build artificial “OSS features” solely to attract stars.

---

# 52. Team Responsibilities

Approximate team size: four.

| Role | Primary responsibilities |
|---|---|
| Lead Developer | architecture, Flutter, future backend, data model, matching engine, CI/CD, reviews |
| UI/UX | research flows, information architecture, design system, prototype, accessibility, usability tests |
| Research | literature, competitor audit, merchant/consumer research, evidence quality, thesis methodology |
| QA / Tester | test plan, acceptance criteria, exploratory/regression testing, device coverage, bug triage, release evidence |

Quality is shared. It is not solely the developer’s responsibility.

---

# 53. Release Strategy

## Prototype

Purpose:
- validate information architecture;
- validate core flows;
- clickable/working UI;
- mock data allowed.

Exit criteria:
- users understand listing → reserve → pickup flow;
- terminology is understandable;
- major usability blockers documented.

## Alpha

Purpose:
- functional core against development backend or controlled environment.

Exit criteria:
- listing/reservation/pickup works;
- inventory correct under tests;
- core auth/authorization;
- critical quality gates green.

## Closed Beta

Purpose:
- limited invited users/businesses.

Exit criteria:
- acceptable operational reliability;
- support/report process works;
- food-safety pilot requirements approved;
- privacy/security review complete for scope.

## Pilot

Purpose:
- real hyperlocal marketplace validation.

Exit criteria:
- repeated listing supply;
- real completed pickups;
- measurable marketplace data;
- manageable support/safety burden.

## Public Beta

Only after pilot evidence supports broader access.

## Stable

Requires:
- mature test coverage;
- adopted E2E;
- release/signing process;
- operational monitoring;
- documented incident/security process;
- product evidence beyond a demonstration.

---

# 54. Pilot Plan

PanganKita should begin hyperlocally.

## 54.1 Scope

- one selected area/campus/community/district;
- small number of food businesses;
- limited consumers;
- pickup only;
- controlled food categories;
- manual operational support allowed;
- measurable outcomes.

## 54.2 Pilot data

Collect:

- listings per merchant/week;
- eligible quantity;
- reservation rate;
- pickup completion;
- expired listings;
- no-shows;
- cancellations;
- time-to-reservation;
- merchant repeat use;
- consumer repeat use;
- support/report incidents;
- trust/usability feedback.

## 54.3 Before pilot

Must validate:

- exact eligibility policy;
- seller responsibilities;
- business verification;
- cancellation/no-show policy;
- payment-at-pickup model;
- privacy disclosure;
- report/escalation process;
- pilot support owner.

---

# 55. Success Metrics

## 55.1 North Star

**Completed eligible surplus quantity/portions picked up before the applicable deadline.**

This measures completion of the value loop rather than app activity.

## 55.2 Guardrails

- safety-related report rate;
- cancellation rate;
- no-show rate;
- reservation conflict rate;
- oversell incidents;
- support incidents;
- false/misleading listing reports.

## 55.3 Product metrics

- listing activation rate;
- listing-to-reservation conversion;
- reservation-to-pickup completion;
- time-to-reservation;
- expired listing rate;
- sell-through.

## 55.4 Business metrics

- active merchants;
- merchant repeat listing;
- completed transaction value/revenue represented;
- average quantity rescued per merchant;
- merchant workflow time.

## 55.5 Consumer metrics

- completed pickups;
- repeat use;
- estimated savings;
- distance/ETA distribution;
- reservation cancellation.

## 55.6 Research metrics

- uplift/difference vs ranking baseline;
- confidence/uncertainty;
- task completion;
- trust/purchase-intention study measures;
- ranking exposure/outcome completeness.

Do not set arbitrary success percentages before discovery establishes plausible baselines.

---

# 56. Failure / Kill Criteria

Reconsider or pivot if evidence shows:

- eligible surplus is too infrequent in target businesses;
- merchants will not consistently list;
- workflow burden exceeds merchant value;
- consumers do not trust surplus food even with clearer information;
- pickup windows are operationally infeasible;
- local supply/demand liquidity cannot be reached;
- food-safety/legal requirements are too complex for feasible pilot scope;
- direct competitor/current alternatives already solve the target pilot problem with little friction;
- proposed ranking produces negligible meaningful improvement;
- support/moderation burden is disproportionate to value;
- measurable rescued quantity is too low to justify the marketplace model.

A null result is a valid research outcome.

---

# 57. Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation | Owner |
|---|---|---|---|---|
| Insufficient merchant supply | High until validated | High | discovery interviews, narrow pilot segment | Research/Product |
| Low consumer trust | High until validated | High | clear surplus terminology, seller info, usability study | UI/UX/Research |
| Food-safety incident | Medium | Critical | eligibility policy, verification, reporting, audit, escalation | Product/Research/Admin |
| Overselling | Medium if poorly designed | High | atomic backend reservation, concurrency tests | Engineering |
| No-shows | Medium | Medium/High | reminders, clear deadline, policy experiment | Product |
| Weak local liquidity | High | High | hyperlocal pilot, concentrated merchant recruitment | Product/Research |
| Competitor overlap | High | Medium/High | current audits, research differentiation | Research |
| Scope creep | High | High | MVP/non-goals, decision log | Lead/Product |
| Privacy/location exposure | Medium | High | least-data, coarse analytics, server authorization | Engineering |
| Account/business impersonation | Medium | High | verification and account security | Engineering/Admin |
| Unsupported impact claims | Medium | High | measured vs estimated separation | Research |
| Tool/dependency churn | Medium | Medium | pinned toolchain, dependency review | Engineering |
| Team bottleneck | Medium | Medium | role matrix, smaller phases | Team |
| Ranking research weak | Medium | Medium | baseline simulation before full thesis investment | Research/Engineering |
| App inaccessible | Medium | Medium | accessibility acceptance criteria and tests | UI/UX/QA |
| Payment complexity | Low in MVP | High later | pay-at-pickup MVP; separate payment phase | Product/Engineering |

---

# 58. Open Questions

| Question | Why it matters | Owner | Validation | Phase |
|---|---|---|---|---|
| What pilot geography should be used? | determines supply/liquidity and travel feasibility | Product/Research | merchant mapping + recruitment | Discovery |
| Which food categories are eligible? | safety and operations | Research/Product | regulatory/domain validation | Before pilot |
| What exact seller food-information fields are mandatory? | trust/safety | Research/UI | official guidance + user test | Prototype |
| What business verification is sufficient? | fraud/trust | Product/Admin | pilot process | Alpha |
| Is pay-at-pickup accepted by target merchants/users? | MVP transaction model | Research/Product | interviews/prototype | Discovery |
| What reservation cancellation/no-show policy works? | inventory and merchant trust | Product | pilot experiment | Pilot |
| What pickup radius is realistic? | matching | Research | user survey + pilot data | Discovery/Pilot |
| What ETA/geocoding provider is appropriate? | cost/privacy/accuracy | Engineering | ADR + prototype | Alpha |
| Which auth solution? | security/dev effort | Engineering | ADR | Alpha |
| Which backend stack? | concurrency/maintenance | Engineering | ADR | Alpha |
| Which state-management package, if any? | app architecture | Engineering | feature complexity review | Prototype |
| How should impact quantity be measured: item, portion, weight, both? | measurement validity | Research/Product | merchant workflow study | Before pilot |
| Should ratings exist in MVP? | trust vs moderation complexity | Product/UI | usability research | Prototype |
| Should business and consumer stay in one app? | UX and maintenance | Product/UI/Engineering | prototype test | Prototype |
| Exact urgency-ranking formula/weights? | thesis/research | Research/Engineering | simulation | Engine spike |
| What minimum ranking improvement is practically meaningful? | research kill criterion | Research | preregister/evaluation plan | Thesis phase |
| Which analytics/crash provider? | privacy and operations | Engineering | ADR | Alpha |
| Font licenses/redistribution approved? | brand implementation | UI/Engineering | license review | Before bundling |

---

# 59. Decision Log

## 59.1 Decided

- Product name: **PanganKita**
- Indonesia-first
- Flutter mobile application
- Android-first validation
- hyperlocal
- pickup-first
- food-only core
- surplus marketplace, not charity-first
- SDG 12.3 primary alignment
- brand guidelines are canonical
- Forest Green / Warm Orange / Soft Cream primary palette
- Geist Sans + Satoshi brand typography
- strict Flutter/Dart quality baseline
- Graphify used for non-trivial code navigation by coding agents
- CI established early
- dependency review now
- Dependabot later
- E2E later, once stable meaningful user journeys exist
- no national-scale architecture before local proof
- no opaque AI as a product requirement

## 59.2 Proposed baseline decisions

- one Flutter app with role-aware consumer/business experiences
- admin as separate internal interface
- reservation + payment at pickup for MVP
- pickup code for handoff confirmation
- deterministic ranking before ML
- relational authoritative backend for pilot
- business verification manual/assisted during initial pilot

These should be recorded in ADR/product decisions when implementation reaches them.

## 59.3 Needs validation

- eligible food policy;
- regulatory requirements;
- pilot area;
- merchant willingness;
- consumer trust;
- pickup radius;
- acceptable discount behavior;
- no-show/cancellation policy;
- impact measurement unit;
- rating usefulness;
- ranking benefit;
- backend/auth/maps vendors.

## 59.4 Rejected for MVP

- delivery;
- payment gateway;
- donation network;
- volunteer system;
- compost/animal-feed routing;
- AI chatbot;
- forecasting suite;
- dynamic pricing;
- nationwide launch;
- social feed;
- premium subscription.

---

# 60. Final MVP Summary

## Who

**Businesses:** restaurants, cafés, bakeries, dessert shops, culinary UMKM, and later other validated food retailers with eligible unsold food.

**Consumers:** nearby users interested in affordable food and willing to pick up within a time window.

## Problem

Eligible food can remain unsold near the end of a short selling window. A business may have limited time and no efficient local demand channel, while nearby consumers may be willing to buy the food at a lower price.

## Solution

A hyperlocal marketplace that enables a business to create a time-limited surplus listing and enables nearby consumers to discover, reserve, and pick it up before the deadline.

## Core flow

```text
eligible surplus
→ listing
→ nearby discovery
→ reservation
→ ready
→ pickup-code confirmation
→ completed outcome
→ impact record
```

## Differentiation

Not “another surplus app.”

PanganKita focuses on:

- food-only;
- time-critical pickup;
- structured listing/eligibility information;
- urgency and pickup-feasibility;
- measurable outcomes;
- transparent ranking research.

## MVP features

**Consumer**
- discover
- filter
- view listing
- reserve
- pickup code
- cancellation
- history
- report
- simple impact

**Business**
- onboard/verify
- create listing
- quantity/deadline
- manage listing
- reservation queue
- mark ready
- verify pickup
- outcome/impact

**System**
- auth/authorization
- atomic inventory
- state machines
- expiry
- reports/moderation
- analytics
- privacy-safe logs

## Non-goals

- delivery
- in-app payment gateway
- donation network
- dynamic pricing
- AI chatbot
- forecasting
- national expansion
- social network
- ERP/POS

## Tech baseline

- Flutter `3.47.4`
- Dart `3.13.3`
- Android-first
- Very Good Analysis
- Dart Code Linter
- Dartrics
- GitHub Actions
- authoritative backend required before real multi-user pilot
- backend stack not prematurely fixed

## Quality

- strict formatting/analyzer/lint
- cognitive complexity gate
- unit/widget/integration tests as behavior appears
- E2E added when a stable complete user journey exists
- accessibility
- localization
- privacy/security
- food-safety validation
- no unsupported impact claims

## North Star

Completed eligible surplus quantity/portions picked up before deadline.

## Research path

Compare conventional ranking against urgency + pickup-feasibility-aware ranking and evaluate:

- sell-through;
- pickup success;
- expiry;
- time-to-reservation;
- no-show/cancellation;
- revenue represented;
- rescued quantity.

---

# Appendix A — Design Handoff for Google Stitch

This appendix is intentionally concise and implementation-oriented.

## A.1 Design goal

Design a mobile Flutter experience that feels like a trustworthy food marketplace, not a charity app and not a generic green sustainability dashboard.

The design should make these four concepts instantly understandable:

```text
WHAT food is available
HOW MUCH it costs
WHERE it is
WHEN it must be picked up
```

## A.2 Canonical brand

Use only the supplied PanganKita identity.

Primary colors:

```text
Forest Green  #1B6B3A
Warm Orange   #F5921B
Soft Cream    #FAF6F0
```

Supporting:

```text
Dark Green    #0D4D2B
Light Orange  #F8B75C
Charcoal      #2D2D2D
Light Gray    #E8E4DF
```

Fonts:

```text
Geist Sans — primary
Satoshi    — supporting
```

Do not invent a replacement logo, palette, or unrelated font system.

Do not distort, rotate, recolor, or shadow the official logo.

## A.3 Consumer screens to design first

1. Welcome / role entry
2. Location explanation
3. Discover feed
4. Filters
5. Listing detail
6. Reservation confirmation
7. Active reservation / pickup code
8. Reservation history
9. Impact
10. Profile/settings
11. Loading/empty/error/offline variants

## A.4 Business screens to design first

1. Business onboarding
2. Verification pending/approved/needs-action
3. Listings dashboard
4. Create listing
5. Listing preview
6. Active listing detail
7. Reservation queue
8. Reservation detail
9. Pickup-code verification
10. Business impact
11. Business settings

## A.5 Feed-card information priority

Recommended hierarchy:

1. food photo/title
2. surplus price
3. original price / savings
4. pickup deadline
5. distance/area
6. business
7. quantity/availability
8. urgency cue

Do not make “impact points” more visually dominant than price, item, or deadline.

## A.6 Listing-detail priority

Above the fold should communicate:

- item;
- merchant;
- price;
- availability;
- distance/location;
- pickup deadline;
- Reserve CTA.

Food-information/safety card follows before final confirmation.

## A.7 Tone

Use Bahasa Indonesia-ready copy.

Tone:

- clear;
- warm;
- respectful;
- practical;
- non-judgmental;
- confident without implying guarantees.

Avoid:

- “poor people food” framing;
- “leftovers” as default label;
- guilt-driven environmental copy;
- unsupported “100% safe” claims.

## A.8 Accessibility

Design for:

- large text;
- screen-reader semantics;
- strong contrast;
- 320–412 logical pixel widths;
- long Indonesian strings;
- urgency conveyed by icon/text as well as color;
- large touch targets;
- obvious error recovery.

---

# Appendix B — Research and Evidence Source Register

## B.1 Project materials

- PanganKita Brand Guidelines — 2026
- PanganKita research/concept document
- Background Research & Problem Validation
- PanganKita Professional Brainstorming & Research Concept Document
- PanganKita Refined Concept, Research Direction & Differentiation Strategy
- current engineering/tooling decisions recorded during repository setup

## B.2 Verified external references used for this baseline

### Bappenas — Indonesia FLW historical baseline

Kementerian PPN/Bappenas. Historical study covering 2000–2019 reports approximately 23–48 million tonnes FLW/year, 115–184 kg/capita/year, and estimated economic losses of Rp213–551 trillion/year.

Reference:
`https://greeneconomy.bappenas.go.id/home/kelola-mubazir-pangan-food-loss-and-waste-flw-untuk-mendukung-pembangunan-rendah-karbon-dan-ekonomi-sirkular-di-indonesia/`

### United Nations — SDG 12.3

Target 12.3:
By 2030, halve per-capita global food waste at retail and consumer levels and reduce food losses along production and supply chains.

Reference:
`https://sdgs.un.org/goals/goal12`

### Surplus Indonesia — current competitor baseline

Consumer app:
`https://play.google.com/store/apps/details?id=surplus.surplus_apps_customer`

Merchant app:
`https://play.google.com/store/apps/details?id=com.surplus_app_merchant`

Public app-store material reviewed in September 2026 should be re-audited before external competitive claims because competitor features can change.

---

# Appendix C — Implementation Caveats

The following areas are deliberately **not finalized** by this PRD because doing so without evidence would be irresponsible:

- exact Indonesian food eligibility/legal rules;
- exact mandatory allergen/storage fields;
- exact privacy-law compliance interpretation;
- exact business verification documents;
- exact backend framework;
- exact auth provider;
- exact maps/geocoding provider;
- exact state-management package;
- exact ranking weights;
- exact pilot geography;
- numeric marketplace success thresholds;
- public-beta payment model;
- future delivery/donation/repurpose workflows.

They must be resolved through evidence, ADRs, regulatory/domain validation, or pilot research rather than silently guessed during implementation.
