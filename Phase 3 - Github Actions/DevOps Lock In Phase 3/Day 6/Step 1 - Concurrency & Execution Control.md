# DAY 6 — Concurrency & Execution Control

#### Date: 28th February 2026

--------------------------------------------------
## Objective

Understand concurrency groups.
Prevent duplicate runs.
Control cancellation behavior.
Avoid resource waste.

This is execution governance.

--------------------------------------------------
## 1. The Problem: Duplicate Workflow Runs

Scenario:

You push 5 commits quickly.
Each triggers workflow.
Now 5 builds running simultaneously.

This:
- Wastes compute
- Slows feedback
- Causes race conditions in deployment

Concurrency solves this.

--------------------------------------------------
## 2. What is Concurrency?

Concurrency defines a group name.
Only one workflow in that group can run at a time.

Example:
```yml
concurrency:
  group: ci-main
  cancel-in-progress: true
```
--------------------------------------------------
## 3. How Concurrency Works

If:
```yml
group: ci-main
```
And multiple runs triggered:

- First run starts.
- Second run starts.
- GitHub cancels first (if cancel-in-progress true).
- Only latest continues.

--------------------------------------------------
## 4. cancel-in-progress Behavior

cancel-in-progress: true
→ Cancel running job when new one triggered.

cancel-in-progress: false
→ Queue new run, wait until current finishes.

Choose carefully.

--------------------------------------------------
## 5. Dynamic Concurrency Groups

Instead of static:
```yml
group: ci-main
```
Use dynamic:
```yml
group: ${{ github.workflow }}-${{ github.ref }}
```
This ensures:
Separate concurrency per branch.

Example:
main branch builds don’t cancel feature branch builds.

--------------------------------------------------
## 6. Concurrency at Job Level

Can define concurrency inside specific job.

Example:
```yml
jobs:
  deploy:
    concurrency:
      group: production-deploy
      cancel-in-progress: false
```
Ensures:
Only one deploy runs at a time.

--------------------------------------------------
## 7. Real-World Example

Production deploy:
```yml
concurrency:
  group: production
  cancel-in-progress: false
```
Prevents:
Two production deploys overlapping.

--------------------------------------------------
## 8. Cancellation Behavior

If workflow cancelled:

- Steps stop immediately.
- Job marked cancelled.
- Dependent jobs skipped.

Use failure() carefully.
Cancelled ≠ failed.

--------------------------------------------------
## 9. Combining Concurrency + Environment

Best pattern:
```yml
deploy:
  environment: production
  concurrency:
    group: production
    cancel-in-progress: false
```
Adds:
Manual approval + single active deploy.

--------------------------------------------------
## 10. Experiment 1 — Rapid Push Test

1. Remove concurrency.
2. Push 3 commits quickly.
3. Observe 3 workflows running.

Now add concurrency.
Repeat.
Observe cancellation behavior.

--------------------------------------------------
## 11. Experiment 2 — Branch Isolation

Use:
```yml
group: ${{ github.workflow }}-${{ github.ref }}
```
Push on main + feature branch.
Confirm no cross-cancellation.

--------------------------------------------------
## 12. Mental Model Upgrade

Workflow = Task.

Concurrency group = Lock.

cancel-in-progress = Replacement policy.

You are controlling execution queue.

--------------------------------------------------
## 13. Checkpoint Questions

1. What happens if cancel-in-progress is true?
2. Why use dynamic group names?
3. Difference between workflow-level and job-level concurrency?
4. What problem does concurrency solve?
5. What happens to cancelled jobs?

If unsure, redo experiments.