# DAY 6 — Workflow Performance & Governance Patterns

#### Date: 28th February 2026

--------------------------------------------------
## Objective

Design scalable workflow architecture.
Prevent CI sprawl.
Control cost.
Optimize execution strategy.
Engineer governance rules.

This is CI platform thinking.

--------------------------------------------------
## 1. The Hidden Problem: CI Sprawl

As projects grow:

- Many workflows
- Many triggers
- Many parallel jobs
- Redundant runs
- Long execution time
- High compute usage

Without governance:
CI becomes chaos.

--------------------------------------------------
## 2. Trigger Optimization Pattern

Bad:
```yml
on:
  push:
```
Triggers on every branch.

Better:
```yml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```
Even better:
Use path filters.

Example:
```yml
on:
  push:
    paths:
      - "src/**"
      - "!docs/**"
```
Prevents unnecessary runs.

--------------------------------------------------
## 3. Path Filtering Strategy

Use when:

- Docs-only changes
- Config-only changes
- Frontend vs backend separation

This reduces CI cost significantly.

--------------------------------------------------
## 4. Job-Level Conditional Execution

Instead of separate workflows:
```yml
jobs:
  backend:
    if: contains(github.event.head_commit.message, '[backend]')
```
Use commit-message based control cautiously.

Better:
Use path-based logic.

--------------------------------------------------
## 5. Avoiding Duplicate Workflow Triggers

If you use both:

push

pull_request

Be aware:
PR from same repo may trigger both.

Use conditions to prevent duplicate heavy jobs.

--------------------------------------------------
## 6. Matrix Explosion Governance

If:

3 OS × 5 versions × 4 environments = 60 jobs

Be intentional.

Ask:
Do we need full matrix on every branch?

Pattern:
```yml
if: github.ref == 'refs/heads/main'
```
Only run full matrix on main.

Use reduced matrix on feature branches.

--------------------------------------------------
## 7. CI Tiering Strategy

Define tiers:

Tier 1 (Fast Checks):
- Lint
- Unit tests
- Runs on PR

Tier 2 (Heavy Tests):
- Full matrix
- Integration tests
- Runs on main only

Tier 3 (Release):
- Deployment
- Tag-based

This prevents PR bottlenecks.

--------------------------------------------------
## 8. Concurrency Governance

Always define:
```yml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```
Prevents waste on rapid pushes.

--------------------------------------------------
## 9. Artifact & Retention Governance

Artifacts default to 90 days.

For CI artifacts:
Set retention-days: 3–7

Do not store unnecessary large artifacts.

Clean pipeline = controlled storage.

--------------------------------------------------
## 10. Cache Governance

Good:
Key includes OS + lockfile hash.

Bad:
Static keys.

Monitor cache size.
Remove stale cache patterns.

--------------------------------------------------
## 11. Permission Governance

At top of workflow:
```yml
permissions:
  contents: read
```
Never rely on default permissions.

Only grant write where required.

--------------------------------------------------
## 12. Workflow Naming & Structure Governance

Bad:
- ci.yml
- test.yml
- new-test.yml
- ci-new.yml

Good:
- 01-ci-build.yml
- 02-ci-test.yml
- 03-release.yml

Structured naming improves clarity.

--------------------------------------------------
## 13. Observability Governance

Use:

- Log grouping
- Structured error messages
- Clear job names
- Short step names

Readable logs = faster debugging.

--------------------------------------------------
## 14. Cost Awareness

Each job:
Spins up VM.
Consumes minutes.

Matrix × concurrency × triggers
= cost multiplication.

Design intentionally.

--------------------------------------------------
## 15. CI Architecture Review Checklist

Before merging workflow:

- ✓ Is concurrency defined?
- ✓ Are permissions explicit?
- ✓ Are actions pinned?
- ✓ Is matrix controlled?
- ✓ Are triggers filtered?
- ✓ Are artifacts limited?
- ✓ Is secret usage scoped?
- ✓ Is environment protected?

--------------------------------------------------
## 16. Mental Model Upgrade

CI is infrastructure.
Workflows are production code.
Governance prevents chaos.
Performance is engineered.

You are designing CI platform, not just pipeline.

--------------------------------------------------
## 17. Checkpoint Questions

1. How to prevent unnecessary runs?
2. When should full matrix run?
3. Why define concurrency everywhere?
4. How reduce artifact storage waste?
5. Why restrict triggers with paths?

If unsure, rethink architecture.