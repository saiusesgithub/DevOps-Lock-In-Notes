# 🔒 DevOps Lock-In — Phase 3

## 🗓 Feb 23 → Feb 28, 2026

## 🎯 Focus: GitHub Actions (Zero → Deep Mastery)

❌ No Docker

❌ No Terraform

✅ Pure GitHub Actions Systems Engineering

---

# 📍 DAY 1 — Feb 23

# 🧠 GitHub Actions Architecture + YAML Mastery

## 🎯 Objective:

Understand the execution engine + YAML deeply.

---

## 1️⃣ CI/CD Foundations (Theory Block – 1 Hour)

Write detailed notes on:

* What is CI?
* What is CD?
* Difference between CI vs CD
* Why automation matters
* Where GitHub Actions fits in DevOps lifecycle
* Comparison: Jenkins vs GitHub Actions (high level)
* What is event-driven automation?

You must be able to explain GHA without opening GitHub.

---

## 2️⃣ YAML Deep Dive (Not Just Basics)

Learn:

* YAML syntax rules
* Indentation rules
* Mapping vs sequences
* Strings vs booleans
* Quoting rules
* Multi-line syntax (`|` vs `>`)

Deliberately create:

* Invalid indentation
* Wrong structure
* Duplicate keys

Push and observe errors.

---

## 3️⃣ First Workflow (But Properly)

Create:

```
.github/workflows/ci.yml
```

Include:

* name
* on: push
* job
* runs-on
* multiple steps

Push → inspect logs line by line.

---

## 4️⃣ Understand Runner Architecture

Research and write:

* What is `ubuntu-latest`?
* Where does it run?
* Is it persistent?
* What is ephemeral runner?
* How long does it live?
* Can state persist across jobs?

---

## 5️⃣ Step Execution Model

Experiment:

* Add 6 shell steps.
* Create file in step 1.
* Access file in step 2.
* Confirm step-level state persists within job.
* Confirm job-level isolation.

---

## 6️⃣ Internal Execution Flow

Draw this:

Push → Event → Workflow Trigger → Runner Allocation → Job → Step → Logs → Result

Explain each layer.

---

## 7️⃣ Rebuild Test

Delete workflow.
Recreate entire structure from memory.

---

# 📍 DAY 2 — Feb 24

# ⚙️ Events, Triggers & Execution Control

## 🎯 Objective:

Master when and why workflows run.

---

## 1️⃣ All Major Events

Experiment with:

* push
* pull_request
* workflow_dispatch
* release
* schedule

Create separate mini workflows for each.

---

## 2️⃣ Branch Filters + Path Filters

Test:

```yaml
push:
  branches:
    - main
  paths:
    - "src/**"
```

Push to:

* different branch
* different folder

Observe trigger differences.

---

## 3️⃣ Pull Request Context

Trigger on PR.
Print:

* `${{ github.head_ref }}`
* `${{ github.base_ref }}`
* `${{ github.actor }}`

Understand PR context differences.

---

## 4️⃣ Scheduled Workflows (Cron Deep Dive)

Learn cron syntax fully:

```
* * * * *
│ │ │ │ │
│ │ │ │ └ day of week
│ │ │ └ month
│ │ └ day
│ └ hour
└ minute
```

Test every 5 minutes.
Then remove.

---

## 5️⃣ Manual Inputs (workflow_dispatch Inputs)

Add:

```yaml
workflow_dispatch:
  inputs:
    environment:
      description: "Choose env"
      required: true
      default: "dev"
```

Access input via:

```
${{ github.event.inputs.environment }}
```

---

## 6️⃣ Trigger Conflict Understanding

Create multiple triggers in same workflow.
Test different event payloads.

Explain event priority and payload structure.

---

## 7️⃣ Rebuild Without Notes

From scratch:

* push
* PR
* manual
* schedule
* input

---

# 📍 DAY 3 — Feb 25

# 🧱 Jobs, Dependencies & Execution Graph

## 🎯 Objective:

Understand execution graph design.

---

## 1️⃣ Multi-Job Workflow

Create 4 jobs:

* build
* test
* lint
* deploy

Observe parallel execution.

---

## 2️⃣ needs Dependency Graph

Add:

```yaml
needs: build
```

Create complex dependency tree:

* test depends on build
* deploy depends on test

Break build → observe cascade.

---

## 3️⃣ Parallel vs Sequential

Create:

* One workflow fully parallel
* One fully sequential

Measure execution time difference.

---

## 4️⃣ Job-Level Isolation

Create file in Job A.
Try access in Job B.
Understand isolation failure.

---

## 5️⃣ Exit Codes & Failure Propagation

Experiment:

```
exit 0
exit 1
exit 2
```

Observe job behavior.

---

## 6️⃣ Continue-on-error

Add:

```yaml
continue-on-error: true
```

Understand use case.

---

## 7️⃣ runs-on Variants

Test:

* ubuntu-latest
* windows-latest
* macos-latest

Observe environment differences.

---

## 8️⃣ Rebuild Complex Graph

Delete workflow.
Rebuild 4-job system with dependencies.

---

# 📍 DAY 4 — Feb 26

# 🔐 Environment Variables, Secrets & Security

## 🎯 Objective:

Professional security handling.

---

## 1️⃣ Workflow-level env vs Job-level env vs Step-level env

Test scope behavior.

---

## 2️⃣ Repository Secrets

Create 2 secrets.
Use them in workflow.
Observe masking.

---

## 3️⃣ Secret Leakage Testing

Try:

* echoing secret
* concatenating secret
* printing partial secret

Understand masking behavior.

---

## 4️⃣ Environment Protection Rules

Create:

* staging
* production

Add required reviewers.
Test approval flow.

---

## 5️⃣ Forked PR Secret Restriction

Research and document:

Why secrets are blocked in forked PRs.

---

## 6️⃣ GitHub Context Security

Understand:

* `${{ secrets.* }}`
* `${{ github.* }}`
* `${{ env.* }}`

Write scope explanation.

---

## 7️⃣ Threat Modeling

Write:

* What if malicious contributor modifies workflow?
* How to restrict workflow permissions?

---

## 8️⃣ Rebuild Secure Workflow

Create workflow using:

* env
* secret
* protected environment

From memory.

---

# 📍 DAY 5 — Feb 27

# 🧠 Expressions, Conditionals & Dynamic Logic

## 🎯 Objective:

Make workflows intelligent.

---

## 1️⃣ GitHub Context Deep Dive

Print:

* github.ref
* github.sha
* github.repository
* github.actor
* runner.os
* strategy.job-index

Understand full context tree.

---

## 2️⃣ Conditional Steps

Use:

```yaml
if: github.ref == 'refs/heads/main'
```

Test multiple branches.

---

## 3️⃣ Conditional Jobs

Apply `if:` at job level.
Observe skip behavior.

---

## 4️⃣ success(), failure(), always()

Experiment with:

```
if: failure()
if: success()
if: always()
```

Break previous steps.

---

## 5️⃣ Matrix Strategy (Advanced)

Create:

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest]
    version: [1, 2]
```

Observe matrix expansion (4 jobs).

---

## 6️⃣ Dynamic Expressions

Use:

```
${{ contains(github.ref, 'main') }}
```

Test expression logic.

---

## 7️⃣ Combine Matrix + Conditional

Make job run only for:

* ubuntu
* main branch

---

## 8️⃣ Rebuild Intelligent Workflow

Delete everything.
Rebuild:

* conditional job
* matrix
* failure handling

---

# 📍 DAY 6 — Feb 28

# 🧩 Artifacts, Caching & Reusability

## 🎯 Objective:

Professional workflow design.

---

## 1️⃣ Upload Artifact

Use:

```
actions/upload-artifact
```

Upload test file.
Download from UI.

---

## 2️⃣ Download Artifact in Another Job

Use:

```
actions/download-artifact
```

Test job-to-job artifact passing.

---

## 3️⃣ Caching

Learn:

```
actions/cache
```

Cache a folder.
Observe speed difference.

---

## 4️⃣ Reusable Workflows

Create workflow with:

```
workflow_call
```

Call from another workflow.

---

## 5️⃣ Composite Actions (Conceptual Understanding)

Understand:

* Custom actions
* Marketplace actions
* Version pinning (`@v3`)

---

## 6️⃣ Permissions Block

Add:

```yaml
permissions:
  contents: read
```

Understand principle of least privilege.

---

## 7️⃣ Concurrency Control

Add:

```yaml
concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true
```

Push multiple times.
Observe cancellation.

---

## 8️⃣ Final Rebuild Challenge

From empty repo, recreate:

* push trigger
* PR trigger
* manual input
* matrix
* conditional job
* secret
* artifact
* caching
* dependency graph
* concurrency control

No notes.

---

# 🔥 Phase 3 Intensity Rules

1. Predict before pushing.
2. Break at least 2 times daily.
3. Read logs fully.
4. Rebuild entire workflow daily.
5. Write daily reflection:

   * What broke?
   * Why?
   * What confused me?
   * What can I now explain clearly?

---

# 🧠 By End of Feb 28

You should be able to:

* Design multi-job pipelines
* Debug YAML errors instantly
* Secure secrets properly
* Control execution graph
* Use matrix effectively
* Pass artifacts between jobs
* Build reusable workflows
* Reason about event payloads
