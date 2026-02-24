# DAY 2 — Branch & Path Filtering (Advanced)

#### Date: 24th February 2026

--------------------------------------------------
## Objective

Gain precise control over WHEN workflows run.
Avoid unnecessary pipeline executions.
Understand evaluation order clearly.

--------------------------------------------------
## 1. Branch Filtering (Deep Understanding)

Basic:
```yml
on:
  push:
    branches:
      - main
```
Meaning:
Workflow runs only if push event occurs on main branch.

Important:
Branch filtering happens BEFORE runner allocation.
If branch does not match → workflow does not start.


--------------------------------------------------
## 2. Multiple Branches
```yml
on:
  push:
    branches:
      - main
      - dev
      - release/*
```
Wildcard support:
- release/* matches release/v1, release/v2, etc.


--------------------------------------------------
## 3. branches-ignore

Instead of allowing specific branches,
you can exclude certain branches.
```yml
on:
  push:
    branches-ignore:
      - feature/*
      - hotfix/*
```
Meaning:
Workflow runs for all branches EXCEPT these.


--------------------------------------------------
## 4. Path Filtering

You can trigger workflow only when specific files change.
```yml
on:
  push:
    paths:
      - "src/**"
```
Meaning:
If push does NOT modify files inside src/,
workflow will not run.

Important:
Path filtering is evaluated after branch filter.


--------------------------------------------------
## 5. paths-ignore
```yml
on:
  push:
    paths-ignore:
      - "docs/**"
      - "*.md"
```
Meaning:
Workflow runs unless only ignored files were modified.

If only markdown files changed → workflow does not run.


--------------------------------------------------
## 6. Combining Branch + Path Filters

Example:
```yml
on:
  push:
    branches:
      - main
    paths:
      - "backend/**"
```
This means:
Workflow runs ONLY IF:
- Push is to main
AND
- Files inside backend folder changed


--------------------------------------------------
## 7. Pull Request Filtering
```yml
on:
  pull_request:
    branches:
      - main
```
Important:
In PR context,
branches refers to TARGET branch (base branch).

Meaning:
Workflow runs only if PR targets main.


--------------------------------------------------
## 8. Branch Filter Evaluation Order

Execution order:

1. Event occurs
2. GitHub checks workflow files
3. Branch filter evaluated
4. Path filter evaluated
5. If both pass → workflow runs
6. Runner allocated


--------------------------------------------------
## 9. Performance Optimization Insight

Why filters matter:

Without filters:
- Workflow runs on every push
- Wastes minutes
- Consumes runner quota

With proper filtering:
- Only relevant pipelines run
- Faster CI
- Lower cost


--------------------------------------------------
## 10. Edge Case Understanding

Case 1:
Push to main but only README changed
If paths: "src/**"
→ Workflow will NOT run

Case 2:
Push to dev but branch filter only allows main
→ Workflow will NOT run

Case 3:
Push to release/v1 and branch filter release/*
→ Workflow runs


--------------------------------------------------
## 11. Advanced Pattern Example
```yml
on:
  push:
    branches:
      - main
      - dev
    paths-ignore:
      - "docs/**"
```
Meaning:
Workflow runs for main/dev
unless ONLY docs changed.


--------------------------------------------------
## 12. Mandatory Experiments

Do ALL of these:

1. Restrict workflow to main only.
2. Push to dev → confirm no execution.
3. Add wildcard branch (release/*).
4. Push to release/v1 → confirm execution.
5. Add path filter to src/**.
6. Change file outside src → confirm no execution.
7. Modify file inside src → confirm execution.

Do not skip.


--------------------------------------------------
## 13. Mental Model Upgrade

Event matching is not random.

It is:

Event → Branch Filter → Path Filter → Workflow Run

Filtering happens BEFORE infrastructure is provisioned.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. What is evaluated first: branch or path?
2. In pull_request, branches refers to which branch?
3. Can you combine branch + path filters?
4. What happens if both push and pull_request exist with filters?
5. Why is filtering important in large repos?

If you hesitate,
redo experiments.