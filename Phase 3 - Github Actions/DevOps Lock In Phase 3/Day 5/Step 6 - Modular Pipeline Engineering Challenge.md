# DAY 5 — Modular Pipeline Engineering Challenge
# Date: 27th February 2026

--------------------------------------------------
## Objective

Combine:
- Reusable workflows
- Composite actions
- External actions (pinned securely)
- Caching
- Artifacts
- Least privilege permissions
- Modular design principles

Design a scalable CI system.

--------------------------------------------------
## 1. Target Architecture

We will design:
```
Caller Workflow
    ↓
Reusable Workflow (build + test)
    ↓
Composite Action (internal step logic)
    ↓
Artifacts uploaded
    ↓
Deploy Workflow
```
Security + Performance + Modularity.

--------------------------------------------------
## 2. Step 1 — Create Composite Action

Location:
```yml
.github/actions/build-steps/action.yml
```
This composite action should:

- Setup environment
- Install dependencies
- Run build
- Output build directory path

Use:
```yml
runs:
  using: composite
```
Add:
- Multiple steps
- One output

This encapsulates build logic.

--------------------------------------------------
## 3. Step 2 — Create Reusable Workflow

File:
```
.github/workflows/reusable-build.yml
```

```yml
on:
  workflow_call:
    inputs:
      node-version:
        required: true
        type: string
```
Inside it:
```yml
jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@<commit-sha>

      - uses: actions/setup-node@<commit-sha>
        with:
          node-version: ${{ inputs.node-version }}

      - uses: actions/cache@<commit-sha>
        with:
          path: ~/.npm
          key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}

      - name: Run composite action
        uses: ./.github/actions/build-steps

      - name: Upload artifact
        uses: actions/upload-artifact@<commit-sha>
        with:
          name: build-output
          path: ./dist
```
This workflow is modular and secure.

--------------------------------------------------
## 4. Step 3 — Caller Workflow

File:
```
.github/workflows/ci.yml
```
```yml
on:
  push:
    branches:
      - main

permissions:
  contents: read

jobs:
  call-build:
    uses: ./.github/workflows/reusable-build.yml
    with:
      node-version: 18
```
This keeps caller clean and minimal.

--------------------------------------------------
## 5. Step 4 — Add Deployment Job

After call-build:
```yml
deploy:
  needs: call-build
  runs-on: ubuntu-latest
  environment: staging
  permissions:
    contents: read
  steps:
    - uses: actions/download-artifact@<commit-sha>
      with:
        name: build-output

    - run: echo "Deploying build artifact"
```
--------------------------------------------------
## 6. Step 5 — Hardening Checklist

Verify:

- ✓ All external actions pinned by commit SHA
- ✓ permissions explicitly defined
- ✓ No secret printed
- ✓ Cache key includes OS + hashFiles
- ✓ Artifact used for cross-job transfer
- ✓ Composite action encapsulates step logic
- ✓ Reusable workflow encapsulates job logic

--------------------------------------------------
## 7. Architecture Layers

- Layer 1: Composite Action (Step Abstraction)
- Layer 2: Reusable Workflow (Job Abstraction)
- Layer 3: Caller Workflow (Pipeline Orchestrator)

This is CI layering.

--------------------------------------------------
## 8. Modular Advantages

Benefits:

- Reuse across repos
- Centralized CI logic
- Easier upgrades
- Security consistency
- Reduced duplication

--------------------------------------------------
## 9. Failure Injection Test

Simulate:

1. Break composite action.
2. Observe reusable workflow fail.
3. Remove cache key hash.
4. Observe stale dependency behavior.
5. Remove permissions block.
6. Analyze risk exposure.

Think like attacker and maintainer.

--------------------------------------------------
## 10. Visual Architecture
```
Caller Workflow
   ↓
Reusable Workflow
   ↓
Composite Action
   ↓
Upload Artifact
   ↓
Deploy Job (downloads artifact)

Clear separation of concerns.
```
--------------------------------------------------
## 11. Rebuild Challenge

Delete all workflows.

Recreate:

- Composite action
- Reusable workflow
- Caller workflow
- Caching
- Artifact transfer
- Secure pinning
- Permissions hardening

No reference.

--------------------------------------------------
## 12. Day 5 Mastery Questions

1. Difference between composite action and reusable workflow?
2. Why pin actions by commit SHA?
3. Why use artifacts instead of cache for file transfer?
4. Where should permissions be defined?
5. How does modular layering improve security?
6. Can reusable workflows call other reusable workflows?
7. How does cache invalidation work?

If you hesitate,
redo rebuild challenge.

--------------------------------------------------
## End of Day 5 Outcome

You now understand:

- Modular CI architecture
- Supply chain security
- Performance engineering
- Cross-job data transfer
- Reusable systems design

You are no longer writing workflows.
You are engineering CI platforms.