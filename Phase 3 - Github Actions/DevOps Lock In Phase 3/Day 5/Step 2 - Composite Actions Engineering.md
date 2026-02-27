# DAY 5 — Composite Actions Engineering

#### Date: 27th February 2026

--------------------------------------------------
## Objective

Understand composite actions.
Encapsulate reusable step logic.
Design internal CI building blocks.
Avoid step duplication.

Composite Action = Reusable Step Bundle.

--------------------------------------------------
## 1. What is a Composite Action?

A composite action is a custom action
built using YAML steps.

It groups multiple steps into one reusable unit.

Unlike reusable workflows:
- Composite actions run inside a job
- They do NOT create new jobs
- They share the same runner

--------------------------------------------------
## 2. Directory Structure

Create:
```
.github/actions/my-action/action.yml
```
Composite actions live inside repository.

--------------------------------------------------
## 3. Minimal Composite Action

action.yml:
```yml
name: "My Composite Action"
description: "Reusable step bundle"
inputs:
  message:
    required: true
    type: string

runs:
  using: "composite"
  steps:
    - run: echo "Message: ${{ inputs.message }}"
      shell: bash
```
--------------------------------------------------
## 4. Using Composite Action in Workflow

In workflow:
```yml
steps:
  - name: Call composite action
    uses: ./.github/actions/my-action
    with:
      message: "Hello World"
```
This executes defined steps.

--------------------------------------------------
## 5. Inputs in Composite Action

Defined in action.yml:
```yml
inputs:
  name:
    required: true
    default: "User"
```
Access inside:
```yml
${{ inputs.name }}
```
--------------------------------------------------
## 6. Outputs from Composite Action

Define output:
```yml
outputs:
  result:
    description: "Processed result"
    value: ${{ steps.step-id.outputs.some_value }}
```
To set output inside step:
```yml
- id: step-id
  run: echo "some_value=42" >> $GITHUB_OUTPUT
  shell: bash
```
Access in workflow:
```yml
${{ steps.step-name.outputs.result }}
```
--------------------------------------------------
## 7. Composite Action vs Reusable Workflow

Composite Action:
- Step-level reuse
- Inside single job
- No new runner

Reusable Workflow:
- Job-level reuse
- Can define multiple jobs
- New runner per job

--------------------------------------------------
## 8. Composite Action Limitations

Cannot:
- Define jobs
- Use needs
- Define strategy/matrix
- Control environment approvals

They are step bundles only.

--------------------------------------------------
## 9. Security Considerations

Composite actions:
- Run in caller’s permission scope
- Can access caller secrets
- Must be trusted

When using external actions:
Pin version via SHA.

Never use:
@main
@latest
Without trust.

--------------------------------------------------
## 10. Practical Experiment

1. Create composite action.
2. Add 3 internal steps.
3. Add input parameter.
4. Add output parameter.
5. Use it in workflow.
6. Capture output.
7. Use output in next step.
8. Break input intentionally.

--------------------------------------------------
## 11. Advanced Example (Real Pattern)

Composite action for:

- Setup environment
- Install dependencies
- Run lint
- Run tests

Instead of repeating in every repo,
encapsulate once.

--------------------------------------------------
## 12. Mental Model Upgrade

Composite Action = Function

Reusable Workflow = Service

Workflow File = Orchestrator

Level hierarchy:

Step → Composite Action

Job → Reusable Workflow

Workflow → Pipeline

--------------------------------------------------
## 13. Checkpoint Questions

1. Where is composite action stored?
2. Does it create new runner?
3. Can it define multiple jobs?
4. How do you define output?
5. Why pin external action by SHA?

If unsure, redo experiments.