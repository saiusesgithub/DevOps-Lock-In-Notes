# DAY 2 — Events & Triggers Deep Dive

#### Date: 24th February 2026

--------------------------------------------------
## Objective

Understand exactly WHEN workflows run.
Master trigger system.
Remove randomness from automation.

--------------------------------------------------
## 1. What Is an Event?

An event is something that happens inside GitHub
that can trigger a workflow.

Examples:
- push
- pull_request
- release
- workflow_dispatch
- schedule

Event = Signal
Workflow = Reaction


--------------------------------------------------
## 2. How GitHub Matches Events

When an event happens:

1. GitHub checks all workflow YAML files
2. It evaluates the "on:" block
3. If event matches, workflow runs

Example:
```yml
on:
  push:
```
This means:
Every push event triggers workflow.


--------------------------------------------------
## 3. push Event

Triggered when:
- You push commits
- You create new branch
- You force push

Basic syntax:
```yml
on:
  push:
```
Restrict to branch:
```yml
on:
  push:
    branches:
      - main
```
Now it only runs on pushes to main.


--------------------------------------------------
## 4. Branch Filtering
```yml
branches:
  - main
  - dev
```
This means:
Only pushes to these branches trigger workflow.
```yml
branches-ignore:
  - feature/*
```
This excludes certain branches.


--------------------------------------------------
## 5. Path Filtering

You can restrict workflow to run
only if specific files change.

Example:
```yml
on:
  push:
    paths:
      - "src/**"
```
Meaning:
Workflow runs only if files inside src folder change.
```yml
paths-ignore:
  - "docs/**"
```

--------------------------------------------------
## 6. pull_request Event

Triggered when:
- PR opened
- PR synchronized (new commits)
- PR reopened

Basic:
```yml
on:
  pull_request:
```
Important difference from push:

pull_request runs in context of PR,

not branch push.


--------------------------------------------------
## 7. pull_request Context Variables

Useful variables:
```yml
${{ github.head_ref }}  → Source branch
${{ github.base_ref }}  → Target branch
${{ github.actor }}     → Who triggered
```
Push event does NOT have head_ref/base_ref.


--------------------------------------------------
## 8. workflow_dispatch (Manual Trigger)

Allows manual execution from UI.

Example:
```yml
on:
  workflow_dispatch:
```
You can also add inputs.


--------------------------------------------------
## 9. schedule (Cron-Based Trigger)

Runs at fixed time.

Example:
```yml
on:
  schedule:
    - cron: '0 0 * * *'
```
This runs daily at midnight UTC.

Cron Format:
```
* * * * *
│ │ │ │ │
│ │ │ │ └ day of week
│ │ │ └ month
│ │ └ day
│ └ hour
└ minute
```

--------------------------------------------------
## 10. Multiple Events in Same Workflow

Example:
```yaml
on:
  push:
    branches:
      - main
  pull_request:
  workflow_dispatch:
```
Workflow runs if ANY of these events occur.


--------------------------------------------------
## 11. Event Payload Concept

Every event sends metadata.
GitHub stores it in:
```
${{ github }}
```
Example:
```yml
${{ github.event_name }}
${{ github.ref }}
${{ github.repository }}
```
This allows conditional logic.


--------------------------------------------------
## 12. Professional Understanding

push = code changed

pull_request = proposed merge

schedule = time-based automation

workflow_dispatch = manual override

Each serves different purpose in CI/CD.

--------------------------------------------------
## Mandatory Experiments (Do All)

1. Create workflow that triggers only on main.
2. Push to dev → confirm it does NOT run.
3. Open PR → observe pull_request trigger.
4. Add workflow_dispatch → run manually.
5. Add schedule (every 5 minutes) → test.
6. Remove schedule after testing.

--------------------------------------------------
## Checkpoint Questions

Answer without guessing:

1. Difference between push and pull_request?
2. When is branch filter evaluated?
3. Can workflow have multiple triggers?
4. What does schedule use internally?
5. What happens if both push and PR trigger same workflow?

If unsure, repeat experiments.