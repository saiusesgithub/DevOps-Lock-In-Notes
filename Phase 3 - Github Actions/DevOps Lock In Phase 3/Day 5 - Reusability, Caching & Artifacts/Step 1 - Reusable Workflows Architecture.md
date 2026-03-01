# DAY 5 — Reusable Workflows Architecture

#### Date: 27th February 2026

--------------------------------------------------
## Objective

Understand reusable workflows.
Eliminate duplication.
Design modular CI systems.
Think like a platform engineer.

--------------------------------------------------
## 1. Problem: Workflow Duplication

Imagine:

- 10 repositories
- Same build logic
- Same test logic
- Same deploy logic

Copy-paste across repos = maintenance nightmare.

Reusable workflows solve this.

--------------------------------------------------
## 2. What is a Reusable Workflow?

A workflow that can be called by another workflow.

Defined using:
```yml
on:
  workflow_call:
```
It acts like a function.

--------------------------------------------------
## 3. Creating a Reusable Workflow

File location:
```
.github/workflows/build.yml
```
Inside it:
```yml
on:
  workflow_call:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Reusable build running"
```
This workflow does not run automatically.
It must be called.

--------------------------------------------------
## 4. Calling a Reusable Workflow

In another workflow:
```yml
jobs:
  call-build:
    uses: ./.github/workflows/build.yml
```
This triggers the reusable workflow.

--------------------------------------------------
## 5. Passing Inputs to Reusable Workflow

Reusable workflow:
```yml
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
```
Use inside:
```yml
${{ inputs.environment }}
```
Calling workflow:
```yml
jobs:
  call-build:
    uses: ./.github/workflows/build.yml
    with:
      environment: staging
```
--------------------------------------------------
## 6. Passing Secrets to Reusable Workflow

Reusable workflow:
```yml
on:
  workflow_call:
    secrets:
      API_KEY:
        required: true
```
Access inside:
```yml
${{ secrets.API_KEY }}
```
Caller:
```yml
jobs:
  call-build:
    uses: ./.github/workflows/build.yml
    secrets:
      API_KEY: ${{ secrets.API_KEY }}
```
Secrets are NOT automatically forwarded.
Must be passed explicitly.

--------------------------------------------------
## 7. Reusable Workflow vs Composite Action

Reusable workflow:
- Can contain multiple jobs
- Has full workflow power
- Good for pipeline-level reuse

Composite action:
- Reusable set of steps
- Used inside job
- Good for step-level reuse

We will cover composite actions next.

--------------------------------------------------
## 8. Reusable Workflow Across Repositories

You can call:
```
uses: owner/repo/.github/workflows/build.yml@main
```
This allows centralized CI logic.

Important:
Always pin version (tag or SHA).
Avoid @main in production.

--------------------------------------------------
## 9. Permission Considerations

Reusable workflow inherits caller permissions.

Define permissions carefully at caller level.

Security matters.

--------------------------------------------------
## 10. Practical Experiment

1. Create reusable workflow with workflow_call.
2. Add input variable.
3. Add secret requirement.
4. Call from another workflow.
5. Pass input.
6. Pass secret.
7. Remove secret and observe failure.
8. Pin reusable workflow via commit SHA.

--------------------------------------------------
## 11. Mental Model Upgrade

Reusable workflow = Pipeline function

Caller workflow = Orchestrator

Inputs = Parameters

Secrets = Secure arguments

You are designing CI modules.

--------------------------------------------------
## 12. Checkpoint Questions

1. What triggers reusable workflow?
2. Are secrets auto-forwarded?
3. Can reusable workflow contain multiple jobs?
4. Why avoid @main in production?
5. When to use reusable workflow vs composite action?

If unsure, redo experiments.