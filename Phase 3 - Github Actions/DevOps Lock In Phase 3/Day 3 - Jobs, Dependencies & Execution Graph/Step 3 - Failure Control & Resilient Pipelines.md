# DAY 3 — Failure Control & Resilient Pipelines

#### Date: 25th February 2026

--------------------------------------------------
## Objective

Understand how failure behaves.
Control error propagation.
Design resilient pipelines.

Today we stop letting failure control us.
We control failure.

--------------------------------------------------
## 1. Default Failure Behavior

By default:

- If a step fails (exit ≠ 0)
  → Job fails

- If a job fails
  → All dependent jobs are skipped

This is strict failure mode.


--------------------------------------------------
## 2. Step-Level continue-on-error

You can allow a step to fail without failing the job.

Example:
```yml
- name: Risky Step
  run: exit 1
  continue-on-error: true
```
Behavior:
Step marked as failed,
but job continues.


--------------------------------------------------
## 3. Job-Level continue-on-error

You can allow a job to fail without failing workflow.

Example:
```yml
jobs:
  test:
    runs-on: ubuntu-latest
    continue-on-error: true
    steps:
      - run: exit 1
```
Now:
Workflow continues,
but job is marked as "neutral" or failed but not blocking.


--------------------------------------------------
## 4. success(), failure(), always()

These are conditional helpers.

success()
→ True if previous steps succeeded.

failure()
→ True if any previous step failed.

always()
→ Runs regardless of success or failure.

Example:
```yml
- name: Run on Failure
  if: failure()
  run: echo "Something failed"

- name: Cleanup
  if: always()
  run: echo "Cleaning up"
```

--------------------------------------------------
## 5. Conditional Execution After Failure

Example:
```yml
steps:
  - name: Test
    run: exit 1

  - name: Notify
    if: failure()
    run: echo "Notify failure"
```
Notify step will run.


--------------------------------------------------
## 6. Combining needs + failure()

Example:
```yml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: exit 1

  notify:
    needs: build
    if: failure()
    runs-on: ubuntu-latest
    steps:
      - run: echo "Build failed"
```
This job runs ONLY if build fails.


--------------------------------------------------
## 7. Strategy fail-fast (Matrix)

When using matrix:
```yml
strategy:
  fail-fast: false
```
Default:
If one matrix job fails,
others stop.

With fail-fast: false:
All matrix jobs run fully even if one fails.


--------------------------------------------------
## 8. Designing Resilient Pipelines

Professional pattern:

build → test → deploy

If test fails:
- Skip deploy
- Run notification job
- Run cleanup job

This ensures:
Controlled behavior.


--------------------------------------------------
## 9. Exit Code Understanding

exit 0 → Success

exit 1 → Generic failure

exit 2+ → Custom failure

GitHub Actions relies entirely on exit codes.


--------------------------------------------------
## 10. Skip vs Fail vs Neutral

Fail:
Red ❌

Skipped:
Gray ➖

Continue-on-error:
May appear as warning ⚠

Important difference:
Skipped job did NOT execute.
Failed job executed and failed.


--------------------------------------------------
## 11. Mandatory Experiments

1. Create job with failing step.
2. Add continue-on-error at step level.
3. Add continue-on-error at job level.
4. Use failure() condition.
5. Use always() cleanup step.
6. Use needs + failure() pattern.
7. Test matrix with fail-fast true/false.


--------------------------------------------------
## 12. Mental Model Upgrade

Failure is not chaos.
It is a signal.

continue-on-error = tolerate signal

failure() = react to signal

always() = guaranteed execution

You now control execution behavior.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. What is default behavior when step fails?
2. What does continue-on-error do?
3. When does failure() evaluate to true?
4. What is difference between skipped and failed?
5. How does fail-fast affect matrix?

If unsure,
repeat experiments.