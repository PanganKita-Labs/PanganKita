# PanganKita Repository Agent Instructions

These instructions apply to all AI coding agents, including Codex, working in
this repository unless the active task provides stricter requirements.

This root file is the repository-wide director/orchestrator. Keep it concise.
Detailed rules live in scoped `AGENTS.md` files near the work they govern.

## Instruction routing

Always read this root file first.

Before editing a subtree, read its scoped instructions:

```text
app/AGENTS.md       Flutter/mobile implementation
docs/AGENTS.md      product, architecture, contributor, and technical documentation
research/AGENTS.md  research, evidence, experiments, metrics, and thesis work
backend/AGENTS.md   backend/API/data work when the backend exists
```

For a task that crosses multiple subtrees, read every affected scoped
`AGENTS.md`.

Do not load unrelated scoped files merely for completeness. Keep context focused.

A deeper scoped `AGENTS.md` may add or specialize rules for its subtree, but it
must not weaken repository-wide product, safety, security, evidence, or honesty
requirements in this file.

If a listed subtree does not yet exist in the active checkout, do not create
production architecture merely to satisfy these instructions.

## Repository purpose

PanganKita is an Indonesia-first technology and research project focused on
helping eligible unsold food retain value before it becomes waste.

The intended core loop is:

```text
eligible unsold food
        ↓
listing
        ↓
nearby discovery
        ↓
reservation
        ↓
time-limited pickup
        ↓
pickup confirmation
        ↓
measured outcome
```

Primary practical value:

- food businesses can recover value from eligible unsold food;
- consumers can access more affordable food;
- successful transactions can reduce the probability that edible food is
  discarded;
- the platform can produce evidence for product and research evaluation.

The durable product principle is:

> Make saving eligible food easier than wasting it.

Do not silently turn PanganKita into:

- a generic food-delivery app;
- a generic e-commerce marketplace;
- a charity-first or poverty-relief app;
- a meal planner or recipe app;
- a restaurant POS or ERP replacement;
- an advertising platform;
- a nationwide logistics network before the local loop is proven;
- an opaque AI product without validated need.

The current priority is to prove one coherent hyperlocal pickup loop before
expanding scope.

## Product and evidence integrity

Distinguish clearly between:

1. source-supported facts;
2. research findings;
3. team assumptions;
4. product hypotheses;
5. proposed decisions;
6. unresolved questions.

Never silently promote an assumption into a fact or a hypothesis into a
validated result.

Do not invent regulatory, food-safety, competitor, environmental, impact, or
research claims.

Illustrative personas, prices, discounts, ranking inputs, future pathways, and
impact examples are not automatically product requirements.

When evidence is incomplete, say so.

## Sources of truth

When repository information conflicts, use this priority:

1. current source code and committed configuration;
2. current automated tests;
3. current schemas, state machines, API contracts, and runtime behavior;
4. current repository documentation;
5. approved implementation plans and decisions;
6. validated research evidence;
7. Graphify output;
8. historical discussion or stale planning material.

Current source is authoritative for existing behavior.

When sources disagree:

- inspect implementation and tests;
- identify the discrepancy;
- preserve approved product direction where practical;
- do not invent missing architecture, APIs, states, dependencies, or rules;
- report unresolved conflicts instead of guessing.

## Graphify-first navigation

For non-trivial code work, Codex and other coding agents must use Graphify
before broad repository browsing.

Use Graphify first when a task:

- crosses multiple source files or modules;
- changes feature or architectural boundaries;
- changes imports, dependency wiring, routing, or state/data flow;
- requires understanding callers, ownership, or execution paths.

Run from repository root:

```powershell
graphify query "<question>" --graph graphify-out/graph.json
graphify path "<A>" "<B>" --graph graphify-out/graph.json
graphify explain "<symbol>" --graph graphify-out/graph.json
```

Use targeted queries. Do not dump the entire graph into context.

Graphify is a navigation aid, not an authority. Verify findings against current
source, tests, schemas, and configuration before changing code.

If no graph exists locally:

```powershell
graphify extract . --code-only
```

After required validation passes, refresh Graphify for meaningful structural
source changes:

```powershell
graphify update .
```

Refresh when source relationships change, including meaningful file/symbol
moves, imports, calls, dependency injection, routes, inheritance, or ownership.

Skip refresh for documentation-only, template-only, formatting-only,
comment-only, translation-only, or unrelated repository-housekeeping changes.

Do not refresh Graphify before required validation passes.

Keep local/generated tooling untracked unless explicitly adopted:

```text
.codex/
graphify-out/
```

## Task preparation

Before editing:

1. read the complete task;
2. inspect `git status --short`;
3. confirm the current branch;
4. identify every applicable `AGENTS.md`;
5. use Graphify for non-trivial structural work;
6. inspect affected source and tests;
7. inspect relevant configuration and contracts;
8. establish current behavior;
9. identify the smallest coherent change;
10. identify validation commands before implementation.

Never discard, reset, overwrite, or rewrite unrelated local changes.

Do not start implementation while important assumptions remain unverified.

## Scope discipline

Keep one task focused on one concern.

Do not:

- perform unrelated refactors;
- implement future roadmap items early;
- create speculative infrastructure;
- add optional adjacent features without approval;
- reformat unrelated files;
- modify unrelated tests;
- resolve unrelated TODOs;
- add dependencies merely to avoid a small amount of clear local code.

When a separate issue is discovered, report it. Fix it only if it blocks the
active task or creates an immediate correctness, safety, security, or
data-integrity problem.

Apply YAGNI, KISS, and DRY to real duplication. Do not create abstractions for
ceremony or symmetry.

## Repository-wide product invariants

Reservation, inventory, listing lifecycle, pickup deadlines, identity,
authorization, food eligibility, and impact recording are
correctness-sensitive.

Do not implement best-effort inventory or reservation correctness.

Food-safety behavior is high risk. Never invent BPOM, Kementerian Kesehatan,
storage, shelf-life, allergen, liability, or certification requirements.

Do not imply PanganKita independently certifies food as safe unless an approved
process actually supports that claim.

Location and personal data are sensitive. Follow least-data principles.

Client-side authorization is never an authoritative security boundary when a
backend exists.

Do not make unsupported CO2, hunger-reduction, nationwide-impact,
performance, or uniqueness claims.

## Security and privacy

Never commit:

- real `.env` values;
- API keys or access tokens;
- signing keys or keystores;
- service credentials;
- authorization headers;
- personal data;
- precise private location data;
- private business data;
- sensitive production logs;
- generated local Graphify artifacts.

Do not bypass TLS verification, disable validation for convenience, weaken
authorization without review, or log secrets.

Use generated or sanitized fixtures instead of private production data.

## Open-source discipline

Do not assume a project license until one is explicitly approved.

Do not copy third-party code, assets, fonts, research text, or proprietary
material without verifying redistribution rights and required attribution.

## Git workflow

Before branch work:

```powershell
git status --short
git branch --show-current
git fetch origin
```

Keep one concern per branch.

Recommended prefixes:

```text
feat/
fix/
docs/
refactor/
perf/
test/
chore/
ci/
build/
research/
```

Do not rewrite unrelated history, discard another person's work, force-push
without explicit need, create a PR unless requested, or merge a PR unless
requested.

Use `--force-with-lease` rather than `--force` when an explicitly approved
history rewrite is necessary.

## Commit messages

Use Conventional Commits:

```text
<type>(<optional-scope>): <imperative summary>
```

Examples:

```text
feat(listings): add pickup deadline validation
fix(reservations): prevent inventory oversell
test(ranking): cover urgency scoring boundaries
docs(research): clarify validation assumptions
ci(quality): add strict Dart analysis gate
chore(repo): add contributor templates
```

Use the type that matches the actual change. Do not use `feat(docs)` for
documentation-only work.

## Pull requests and issues

Use repository templates accurately.

PRs must remain focused and report:

- problem and intended behavior;
- implementation approach;
- affected areas;
- validation commands and results;
- product/domain impact;
- relevant security/privacy implications;
- food-safety implications when applicable;
- screenshots for visible UI changes;
- limitations and follow-up work.

Do not check boxes for commands that were not run.

Feature requests should describe the problem before the implementation idea and
include success criteria when practical.

## AI-assisted changes

AI assistance is allowed, but the human author remains responsible.

Before finalizing AI-assisted work:

- review every changed line;
- verify behavior and architecture against current source;
- verify commands and tests;
- verify licenses and attribution;
- remove fabricated claims;
- remove unsupported regulatory, competitor, impact, or food-safety claims;
- check for secrets and personal data;
- ensure unrelated generated files are not staged.

Generated work that has not been reviewed and validated is not complete.

## Tool and instruction freshness

Do not assume these instructions remain correct forever.

If a required tool behaves differently from documented instructions:

1. inspect the installed version;
2. inspect official help/documentation when necessary;
3. determine whether instructions are stale or the environment is broken;
4. upgrade only when necessary for the task, compatibility, security, or a
   confirmed bug;
5. rerun relevant validation;
6. report the change.

Do not upgrade merely because a newer version exists.

## Final review before commit

Before committing:

1. inspect `git status --short`;
2. inspect the full diff;
3. run `git diff --check`;
4. confirm no unrelated files changed;
5. confirm no secrets or personal data are present;
6. confirm required validation passed;
7. confirm documentation matches behavior;
8. confirm no unsupported product/research claims were introduced;
9. refresh Graphify when required;
10. confirm `.codex/` and `graphify-out/` are not staged;
11. use an accurate Conventional Commit message.

Useful commands:

```powershell
git status --short
git diff --check
git diff
git diff --cached
git diff --cached --name-only
```

## Required final report

At the end of an implementation task, report:

- branch name;
- task implemented;
- files changed;
- concise implementation summary;
- important discrepancies or assumptions;
- validation commands and results;
- manual verification performed;
- relevant security/privacy/food-safety/compatibility notes;
- Graphify refresh result or reason it was skipped;
- commit hash/message when committed;
- push result when pushed;
- PR title and description when requested;
- remaining risks, blockers, or follow-up work.

Clearly distinguish completed work, validation that passed, validation not run,
known limitations, and optional later work.

Never claim completion while mandatory acceptance criteria remain unmet.

Do not commit, push, create a PR, merge, delete unrelated code, or rewrite
history unless the user explicitly requests that action.

## Architecture source of truth

For Flutter source structure, dependency direction, feature boundaries,
state ownership, repository patterns, barrel-file policy, and architectural
principles, follow `docs/ARCHITECTURE.md`.

Do not duplicate detailed architecture rules in this file.

For non-trivial structural changes:
1. read `docs/ARCHITECTURE.md`;
2. use Graphify as required by this repository;
3. preserve existing boundaries unless the task justifies changing them.

Architecture decisions must remain consistent with `PRD.md`,
`docs/DESIGN.md`, and the applicable scoped `AGENTS.md`.

## Quality gates, commits, and pushes

Do not commit or push changes with known failing required checks.

The required validation depends on the change scope.

### Flutter / Dart source changes

Before commit or push, run the full local app quality gate from `app/`:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos --fatal-warnings
dart run dart_code_linter:metrics analyze --fatal-style --fatal-performance --fatal-warnings lib
dart run dart_code_linter:metrics check-unused-code --analyze-private-members lib
dart run dart_code_linter:metrics check-unused-files lib
dart run dart_code_linter:metrics check-unnecessary-nullable lib
dart run dartrics analyze lib
flutter test --coverage
```

Then from the repository root:

```powershell
git diff --check
```

All required checks must pass before a commit or push is considered ready.

### Documentation-only changes

Do not run the full Flutter suite unnecessarily.

At minimum run:

```powershell
git diff --check
```

Also run any documentation, link, or workflow-specific checks affected by the
change.

### Workflow / CI changes

Validate the workflow syntax and run the checks affected by the workflow change.

Do not modify CI merely to hide or bypass a failing source-code quality rule.

### Dependency changes

Resolve dependencies successfully and run the full quality gate for the
affected application/code.

### Push and CI policy

A remote GitHub Actions run cannot pass until the commit has been pushed.

Therefore the required sequence is:

```text
make changes
→ run required local checks
→ all required local checks pass
→ review diff
→ commit/push only when authorized
→ GitHub Actions runs
→ required CI checks must pass
```

A pushed change is not considered complete while required GitHub Actions checks
are failing.

Do not merge a pull request while required CI is failing.

If CI fails:

1. inspect the failing job and exact failing step;
2. identify the root cause;
3. fix the source/configuration rather than weakening the quality gate;
4. rerun the relevant local checks;
5. push the fix;
6. verify required CI becomes green.

Never:

* disable a required check just to obtain green CI;
* remove a lint rule solely because new code violates it;
* add blanket ignores/suppressions without a documented technical reason;
* skip tests because they are inconvenient;
* rerun an unchanged failing workflow and treat that as a fix.

If a required check appears incorrect or incompatible with the project,
investigate and explain the issue before changing the rule or workflow.

### Agent authorization

Passing checks does not grant permission to commit, push, merge, open a pull
request, or modify remote state.

Only perform those actions when the user has explicitly authorized them.