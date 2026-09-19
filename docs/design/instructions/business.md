# PanganKita Business Design Instructions

Read `docs/DESIGN.md` first.

This file governs merchant/business-facing mobile screens.

## Business navigation

Starting model:

```text
Listings
Reservations
Impact
Business
```

Consumer and Business areas should clearly belong to the same PanganKita
product.

## Business priorities

Business UI is operational.

Prioritize:

- current listings;
- reservation status;
- pickup deadlines;
- quantity;
- next action;
- pickup confirmation.

Avoid turning the merchant experience into an analytics-heavy dashboard before
the core workflow is proven.

## Business Onboarding

Show only information required for the active pilot/product requirement.

Potential groups:

- business identity;
- category;
- location;
- contact;
- verification fields;
- seller responsibility acknowledgement.

Keep the form manageable.

Do not make every listing creation feel like a legal questionnaire.

## Verification State

Support:

```text
Pending
Approved / Terverifikasi
Needs action
Rejected where policy requires
```

`Terverifikasi` may mean only implemented business/account verification.

It must not imply:

- food-safety certification;
- hygiene certification;
- every listing independently inspected.

## Merchant Dashboard / Listings

**Visual reference:** `docs/design/reference/merchant-dashboard.png`

Purpose: provide fast operational status and clear next actions.

Priority:

1. merchant identity/business context;
2. create listing;
3. active listings;
4. reservations needing action;
5. concise operational summary;
6. impact only when supported.

Strong `Create Listing` CTA is appropriate.

Use sections such as:

```text
Active
Drafts
Closed
```

when they map cleanly to product state.

## Create Listing

Optimize for low friction.

Potential fields:

- photo;
- listing name;
- category;
- short description;
- original price;
- surplus price;
- quantity;
- pickup start;
- pickup deadline;
- seller-provided condition/eligibility acknowledgement;
- storage information when relevant;
- allergen information when relevant;
- pickup notes.

Use progressive disclosure when it reduces cognitive load.

Do not invent regulatory fields.

## Listing Preview

Show the actual consumer-facing presentation.

Provide clear:

```text
Edit
Publish
```

actions.

## Active Listing Detail

Show:

- listing state;
- time remaining / deadline;
- total quantity;
- available quantity;
- reserved;
- completed;
- reservation summary;
- permitted edit actions;
- close/cancel action.

Critical fields may become restricted after reservations exist according to the
PRD/domain rules.

## Reservation Queue

Optimize for operational scanning.

Useful grouping:

```text
New / Reserved
Ready
Completed
Cancelled / No-show
```

Time-sensitive orders must be easy to identify.

## Reservation Detail

Show:

- item;
- quantity;
- customer display identifier;
- pickup window;
- pickup code state;
- Mark Ready;
- Verify Pickup;
- report/problem action.

## Pickup Verification

Support QR scanning if/when implemented and a short-code/manual fallback where
appropriate.

After successful verification, show a clear completion state.

Repeated confirmation must not appear to create another transaction.

## Business Impact

Prefer factual operational metrics:

```text
4 pesanan selesai
4 dari 6 porsi diambil
1 porsi masih tersedia
1 listing berakhir
```

Possible broader metrics:

- completed surplus quantity/portions;
- sell-through;
- listed quantity that expired unsold;
- completed transaction value represented;
- pickup completion;
- cancellation/no-show.

Avoid:

```text
Target Zero-Waste Tercapai
100% waste prevented
CO2 prevented
```

unless future approved measurement supports the exact claim.

## Business Settings

Potential sections:

- business profile;
- location;
- operating information;
- accepted payment-at-pickup methods;
- notifications;
- support.

Staff/member management is post-MVP unless an active pilot requirement needs it.

## Future business screen derivation

Future business screens must reuse the same foundations/components:

- onboarding;
- verification;
- create listing;
- preview;
- listing management;
- reservation queue;
- pickup verification;
- business impact;
- settings.

Do not create a separate merchant visual system.
