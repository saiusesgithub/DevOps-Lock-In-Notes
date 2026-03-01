# DAY 2 — Trigger & Event Mental Mapping Challenge

#### Date: 24th February 2026

--------------------------------------------------
## Objective

Combine everything learned today:
- push
- pull_request
- workflow_dispatch
- schedule
- branch filtering
- path filtering
- context inspection

Build a complete trigger control system.

This is your Day 2 stress test.

--------------------------------------------------
## 1. Build One Workflow That Includes ALL

Create a workflow that includes:
```yaml
on:
  push:
    branches:
      - main
    paths:
      - "src/**"

  pull_request:
    branches:
      - main

  workflow_dispatch:
    inputs:
      environment:
        description: "Environment"
        required: true
        type: choice
        options:
          - dev
          - staging
          - production

  schedule:
    - cron: '*/5 * * * *'
```

--------------------------------------------------
## 2. Add Context Inspection Step

Inside job, add:
```yaml
- name: Print Trigger Info
  run: |
    echo "Event Name: ${{ github.event_name }}"
    echo "Ref: ${{ github.ref }}"
    echo "Actor: ${{ github.actor }}"
    echo "SHA: ${{ github.sha }}"
    echo "Schedule: ${{ github.event.schedule }}"
    echo "Input Env: ${{ github.event.inputs.environment }}"
```
This will behave differently depending on trigger.


--------------------------------------------------
## 3. Trigger Mapping Exercise

Now test in this order:

1. Push to main with file in src/
2. Push to main with file outside src/
3. Push to dev branch
4. Open PR targeting main
5. Trigger manually with environment = production
6. Wait for scheduled execution

For each case, write:

- Did workflow run?
- Why?
- What was github.event_name?
- What values were populated?
- What values were empty?


--------------------------------------------------
## 4. Create Conditional Job Based on Trigger

Add second job:
```yaml
jobs:
  conditional_job:
    if: ${{ github.event_name == 'workflow_dispatch' }}
    runs-on: ubuntu-latest
    steps:
      - run: echo "Manual run only"
```
Test:
- Does it run during push?
- Does it run during manual?


--------------------------------------------------
## 5. Create Conditional Step Based on Branch

Add inside job:
```yaml
- name: Only on Main
  if: ${{ github.ref == 'refs/heads/main' }}
  run: echo "Running on main branch"
```
Test:
- Push to dev
- Push to main


--------------------------------------------------
## 6. Create Conditional Step Based on Input

Add:
```yaml
- name: Production Only
  if: ${{ github.event.inputs.environment == 'production' }}
  run: echo "Deploying to production"
```
Trigger manually with:
- dev
- staging
- production

Observe behavior.


--------------------------------------------------
## 7. Final Mental Model of Day 2
```
Event Occurs
↓
Branch Filter Evaluated
↓
Path Filter Evaluated
↓
Workflow Triggered
↓
Event Payload Generated
↓
Context Available
↓
Conditional Logic Evaluated
↓
Jobs Executed
```

--------------------------------------------------
## 8. Day 2 Rebuild Challenge

Delete entire workflow.

From memory, rebuild:

- push with branch + path filter
- pull_request filter
- workflow_dispatch with input
- schedule
- context print step
- conditional job
- conditional step

No notes.
No copy.


--------------------------------------------------
## 9. Day 2 Mastery Questions

Answer without looking:

1. What is evaluated first: branch filter or path filter?
2. In pull_request, branches refers to which branch?
3. Where are manual inputs stored?
4. What does github.event.schedule contain?
5. What happens if schedule and push occur close together?
6. Can multiple triggers coexist in one workflow?
7. When is runner allocated in trigger process?

If you hesitate,
repeat rebuild challenge.


--------------------------------------------------
## End of Day 2 Outcome

By end of today, you should:

- Fully control WHEN workflows run
- Understand event payload differences
- Use context for intelligent logic
- Combine automatic + manual + scheduled triggers
- Build dynamic conditional workflows

You now understand trigger architecture.