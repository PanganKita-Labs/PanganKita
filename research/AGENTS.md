# PanganKita Research Agent Instructions

These instructions apply to all work under `research/`.

Read the repository-root `AGENTS.md` first. This file specializes research,
evaluation, datasets, experiments, metrics, and thesis-oriented work.

## Research role

PanganKita may support academic/thesis research, but the application itself is
not automatically the research contribution.

Research work must identify a question that can be tested or evaluated.

A possible future direction is to evaluate whether urgency- or
pickup-feasibility-aware ranking changes outcomes compared with a conventional
baseline. This remains a hypothesis until measured.

Do not introduce AI/ML merely to make the research appear advanced.

## Evidence hierarchy

Distinguish:

- primary source evidence;
- secondary source evidence;
- observed product data;
- experiment results;
- qualitative findings;
- assumptions;
- hypotheses;
- illustrative examples.

Never merge these categories silently.

When source definitions differ, preserve the differences.

For external statistics, record enough context to avoid misrepresentation,
including when available:

- source organization;
- year or time period;
- geography;
- population;
- definition of food loss/surplus/waste;
- measurement method;
- uncertainty or range.

## Research question quality

A research task should define, as appropriate:

- research question;
- hypothesis;
- baseline/control;
- independent variable;
- dependent variable;
- population or dataset;
- sampling method;
- intervention;
- evaluation metric;
- analysis method;
- limitations;
- stopping or success criteria.

Do not retrofit the question after seeing results merely to obtain a positive
finding.

## Ranking experiments

For ranking/matching research, start with deterministic, explainable baselines.

Potential inputs may include:

- remaining pickup time;
- distance;
- estimated travel time;
- quantity;
- listing age;
- demand;
- pickup feasibility;
- category relevance.

Any experiment should define:

- exact feature inputs;
- normalization;
- scoring/ranking rule;
- baseline ranking;
- tie behavior;
- cold-start behavior;
- missing-data handling;
- evaluation metrics;
- reproducible seed when randomness exists.

Do not describe a ranking approach as better until the chosen metric and
evaluation support that statement.

## Metrics

Prefer metrics tied to the actual product loop, such as:

- listing-to-reservation conversion;
- reservation-to-pickup completion;
- sell-through;
- expired unsold quantity;
- cancellation rate;
- no-show rate;
- time-to-reservation;
- pickup feasibility;
- merchant repeat usage;
- consumer repeat usage.

Define numerator, denominator, inclusion/exclusion criteria, and observation
window.

Distinguish measured values from calculated and estimated values.

Do not invent CO2-equivalent or social-impact conversions without an approved
methodology.

## Experiment integrity

Do not:

- cherry-pick favorable runs;
- drop failed cases without explanation;
- change thresholds after seeing results without recording it;
- tune on the evaluation set and present it as unbiased;
- hide null or negative findings;
- round values in a misleading way;
- claim statistical significance without appropriate analysis.

Record relevant configuration so results can be reproduced.

## Data privacy and ethics

Research data may contain sensitive personal, merchant, behavioral, or location
information.

Use the minimum data required.

Prefer de-identified, aggregated, generated, or sanitized data.

Do not commit:

- raw participant identifiers;
- precise home locations;
- private merchant data;
- authentication data;
- raw production exports;
- consent records containing personal information.

Define retention and access rules before collecting sensitive study data.

Do not infer or expose sensitive traits that are unnecessary to the research
question.

## Pilot studies

Hyperlocal pilots are preferred before broad claims.

A pilot should define:

- geographic scope;
- participating merchant type/count;
- participant recruitment;
- observation period;
- listing eligibility;
- pickup model;
- operational support;
- success/failure metrics;
- known biases;
- exit/kill criteria.

Do not generalize a small local pilot to all Indonesian consumers or merchants
without appropriate evidence.

## Qualitative research

For interviews, surveys, and observations:

- preserve the actual question wording;
- distinguish participant statements from researcher interpretation;
- avoid leading questions where possible;
- record sample and recruitment limitations;
- do not fabricate quotes;
- do not overgeneralize anecdotal feedback.

Personas derived from research must indicate whether they are evidence-based,
synthetic, or illustrative.

## Competitive research

Competitor research must be dated.

Record what was directly observed versus inferred.

Do not claim that a competitor lacks a feature unless that absence was
reasonably verified.

Do not turn competitor weaknesses into unsupported statements of PanganKita
superiority.

## Reproducibility

Research code and notebooks/scripts should be deterministic where practical.

When randomness exists, use documented seeds.

Record:

- dataset/version;
- code version or commit;
- parameters;
- environment/toolchain;
- date;
- metric definitions;
- exclusions;
- output location.

Generated result artifacts should not be committed automatically unless the
repository has explicitly decided they are durable evidence.

## Statistical honesty

Use statistical tests only when assumptions and sample size make them
appropriate.

Do not report precision that the data cannot support.

Include uncertainty, confidence intervals, effect sizes, or descriptive
statistics when they materially improve interpretation.

Do not use statistical significance as a substitute for practical relevance.

## Simulation and synthetic data

Synthetic data is acceptable for engineering validation and early experiments
when clearly labeled.

Do not present synthetic outcomes as real-world user behavior.

Document the generation assumptions.

## Research code quality

Research code may be exploratory, but it must still be understandable and
reproducible.

Do not let exploratory scripts become production dependencies accidentally.

If research logic graduates into the product, move it through normal
architecture, review, typing, testing, and CI requirements rather than importing
an experimental script directly.

## Graphify usage

Use Graphify for non-trivial code navigation when research work depends on
production code relationships.

Do not refresh Graphify for research prose, datasets, notebooks, or result files
that do not affect production source relationships.

## Research completion

Before finishing a research task, report:

- question/hypothesis;
- data/source used;
- method;
- parameters;
- metrics;
- result;
- uncertainty/limitations;
- reproducibility information;
- whether findings support, contradict, or do not resolve the hypothesis;
- follow-up work.

Never report a hypothesis as confirmed when the evidence is insufficient.
