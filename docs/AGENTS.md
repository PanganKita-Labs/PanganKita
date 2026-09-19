# PanganKita Documentation Agent Instructions

These instructions apply to all work under `docs/`.

Read the repository-root `AGENTS.md` first. This file specializes documentation
work and does not weaken repository-wide product, evidence, security, or
food-safety rules.

## Documentation purpose

Documentation should help contributors and reviewers understand:

- what PanganKita is and is not;
- implemented behavior;
- approved product decisions;
- architecture and engineering contracts;
- setup and development workflows;
- testing and CI expectations;
- security/privacy expectations;
- food-safety boundaries;
- research evidence and limitations;
- known limitations and future work.

Documentation is not a marketing substitute.

## Truth and evidence labels

Keep clear distinctions between:

- implemented behavior;
- approved decisions;
- proposals;
- hypotheses;
- research findings;
- assumptions;
- unresolved questions.

Do not rewrite a hypothesis as a fact because it appears frequently in project
materials.

Do not treat illustrative personas, discounts, impact numbers, or workflows as
validated requirements unless supporting evidence exists.

## Claims requiring care

Do not make or strengthen claims about:

- Indonesian national food-waste totals;
- food-waste composition;
- consumer motivation;
- merchant economics;
- regulatory compliance;
- BPOM or Kementerian Kesehatan requirements;
- food safety;
- competitor capabilities;
- environmental impact;
- hunger reduction;
- CO2 reduction;
- nationwide impact;
- performance;
- unique or first-in-market status;

without an appropriate source or validated internal evidence.

When a source uses a different population, year, geography, methodology, or
definition, do not present it as directly equivalent.

## Product boundaries

Documentation must preserve that PanganKita is primarily a hyperlocal,
pickup-oriented surplus-food marketplace.

Do not silently reposition it as:

- delivery-first;
- charity-first;
- generic commerce;
- an ERP/POS;
- an awareness-only app;
- an opaque AI recommendation product.

Future donation, food-bank, animal-feed, compost, delivery, or advanced ranking
paths must remain clearly marked as future work unless approved for the active
scope.

## Technical documentation

Update relevant documentation when changing:

- setup commands;
- toolchain versions;
- environment variables;
- dependencies;
- architecture;
- state machines;
- API contracts;
- permissions;
- security/privacy behavior;
- location behavior;
- food-safety behavior;
- analytics;
- ranking;
- testing;
- CI;
- build/release behavior;
- known limitations.

Commands in documentation must be runnable and match the current repository.

Do not document a command as successful unless it has actually been validated
or is clearly labeled as an example.

## Architecture documentation

Architecture docs must describe current ownership and dependency direction.

Do not document speculative services, layers, APIs, queues, workers, or
databases as if they already exist.

When describing a planned architecture, label it as planned/proposed.

If source and architecture docs disagree, inspect current source and report the
discrepancy instead of silently rewriting one side.

## Research documentation

Research-oriented docs must preserve methodology and uncertainty.

When relevant, record:

- research question;
- hypothesis;
- baseline;
- population/sample;
- dataset/source;
- independent/dependent variables;
- evaluation method;
- limitations;
- measured versus estimated values;
- date/version context.

Negative or null findings remain valid results.

Do not cherry-pick evidence to make PanganKita look stronger.

## Safety and regulatory language

Use narrow, reviewable wording.

Do not say food is “safe”, “certified”, “approved”, or “compliant” unless an
approved process and evidence support the exact statement.

Prefer language such as:

```text
seller-provided food information
eligible unsold food
pickup deadline
reported condition
allergen information
storage information
```

when that reflects actual product behavior.

## Competitor documentation

Competitor analysis must be factual and time-bounded.

Do not claim competitors lack a capability unless it has been verified for the
relevant version/time period.

Distinguish:

- observed competitor behavior;
- published competitor claims;
- inferred differences;
- proposed PanganKita differentiation.

PanganKita's urgency/pickup-feasibility ranking is a hypothesis/direction until
validated, not proof of superiority.

## Links

Use the repository Lychee workflow for documentation links.

For changed docs:

- verify relative links;
- keep paths portable;
- avoid unnecessary root-relative links;
- do not add broad Lychee ignores for transient external failures;
- add ignores only for known automation-blocking or intentionally unreachable
  targets.

## Screenshots and assets

Do not add screenshots, brand assets, diagrams, or third-party visuals without
checking:

- source;
- license or ownership;
- redistribution rights;
- privacy;
- whether sensitive information is visible.

Do not commit private research screenshots or participant information.

## Accessibility documentation

When UI accessibility behavior or verification changes, update the relevant
docs.

Document meaningful accessibility requirements such as semantics, text scaling,
contrast, tap targets, focus behavior, and non-color cues without inventing
implementation details.

## Contributor documentation

Keep contributor instructions consistent with:

- root `AGENTS.md`;
- scoped `AGENTS.md` files;
- GitHub issue templates;
- pull-request template;
- current CI workflows;
- actual setup commands.

Avoid duplicating large rule blocks when a stable canonical document can be
linked instead.

## Documentation validation

For documentation-only changes, at minimum:

```powershell
git diff --check
```

Also run or verify the repository's Markdown/link checks when relevant.

Do not run unrelated Flutter/backend test suites for pure documentation changes
unless the documentation change modifies executable examples or the task
explicitly requires it.

Graphify refresh is not required for documentation-only work.

## Documentation completion

Before finishing:

- inspect the complete diff;
- verify claims against available evidence;
- verify commands and paths;
- verify internal links;
- avoid unsupported marketing language;
- preserve uncertainty where uncertainty exists;
- ensure no personal/private data was added;
- report what was and was not validated.
