# DAY 2 — Manual Trigger & Inputs Deep Dive

#### Date: 24th February 2026

--------------------------------------------------
## Objective

Understand how to manually trigger workflows.
Learn how to pass inputs.
Make workflows interactive and controlled.

--------------------------------------------------
## 1. What is workflow_dispatch?

workflow_dispatch allows you to manually trigger a workflow from GitHub UI.

It adds a "Run workflow" button in Actions tab.

Basic usage:
```yml
on:
  workflow_dispatch:
```

This allows manual execution anytime.


--------------------------------------------------
## 2. Adding Inputs to workflow_dispatch

You can define inputs that appear as form fields.

Example:
```yml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: "Choose environment"
        required: true
        default: "dev"
```
Now when you click "Run workflow",
GitHub asks for environment input.


--------------------------------------------------
## 3. Accessing Input Values

Inputs are accessed using:
```yml
${{ github.event.inputs.environment }}
```
Example:
```yml
- name: Print Environment
  run: echo "Selected environment is ${{ github.event.inputs.environment }}"
```
Important:
Inputs are stored inside event payload.


--------------------------------------------------
## 4. Multiple Inputs

Example:
```yml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: "Environment"
        required: true
        default: "dev"
      version:
        description: "Version number"
        required: false
```
Access them using:
```yml
${{ github.event.inputs.version }}
```

--------------------------------------------------
## 5. Input Types (Newer Syntax)

You can define input types like:
```yml
on:
  workflow_dispatch:
    inputs:
      deploy:
        description: "Deploy?"
        required: true
        type: boolean
      environment:
        description: "Environment"
        required: true
        type: choice
        options:
          - dev
          - staging
          - production
```
This creates dropdown and checkbox UI.


--------------------------------------------------
## 6. Conditional Logic Based on Input

You can control job execution using input:
```yml
jobs:
  deploy:
    if: ${{ github.event.inputs.environment == 'production' }}
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to production"
```
This allows dynamic behavior.


--------------------------------------------------
## 7. Combining push + workflow_dispatch

Example:
```yml
on:
  push:
    branches:
      - main
  workflow_dispatch:
```
Workflow now runs:
- Automatically on push
- Manually anytime

Both triggers coexist.


--------------------------------------------------
## 8. Understanding Event Context

When triggered manually:
```yml
${{ github.event_name }} → workflow_dispatch
```
When triggered by push:
```yml
${{ github.event_name }} → push
```
This allows behavior switching.


--------------------------------------------------
## 9. Practical Experiments (Mandatory)

1. Create workflow with only workflow_dispatch.
2. Add 2 inputs.
3. Print both inputs in logs.
4. Add conditional job based on input.
5. Combine with push trigger.
6. Print ${{ github.event_name }} in logs.
7. Observe difference between manual and push execution.

Do not skip experiments.


--------------------------------------------------
## 10. Professional Insight

workflow_dispatch is used for:

- Manual deployments
- Re-running workflows with different parameters
- Controlled production releases
- Testing without pushing commits

It adds operational flexibility.


--------------------------------------------------
## 11. Mental Model Upgrade

push = automatic execution

workflow_dispatch = manual execution

inputs = runtime parameters

Workflow can behave like a configurable program.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. Where are inputs stored internally?
2. Can workflow_dispatch coexist with push?
3. How do you conditionally run job based on input?
4. What does github.event_name return during manual run?
5. Why are inputs useful in production systems?

If unsure,
redo experiments.