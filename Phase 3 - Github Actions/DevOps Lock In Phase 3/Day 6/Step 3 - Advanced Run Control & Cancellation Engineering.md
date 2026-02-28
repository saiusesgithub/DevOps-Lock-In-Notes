# DAY 6 — Advanced Run Control & Cancellation Engineering

#### Date: 28th February 2026

--------------------------------------------------
## Objective

Control:
- Run cancellation behavior
- Dependent job cancellation
- Manual cancellation impact
- Workflow run status logic

Understand cancellation deeply.

--------------------------------------------------
## 1. Workflow Run States

Possible job states:
```
success
failure
cancelled
skipped
```
Important:
cancelled ≠ failure

--------------------------------------------------
## 2. Manual Cancellation Behavior

If you manually cancel a workflow:

- Running steps stop immediately
- Current job marked cancelled
- Dependent jobs are skipped

Failure handlers using failure()
will NOT run.

--------------------------------------------------
## 3. Detecting Cancelled Runs

Use:
```yml
if: cancelled()
```
Example:
```yml
- name: Handle cancellation
  if: cancelled()
  run: echo "Workflow was cancelled"
```
Useful for cleanup logic.

--------------------------------------------------
## 4. success(), failure(), cancelled(), always()
```
success() → Only if previous steps succeeded
failure() → If any previous step failed
cancelled() → If run was cancelled
always() → Always runs
```
Understand their difference carefully.

--------------------------------------------------
## 5. Interaction with Concurrency

If concurrency cancels previous run:

That run status = cancelled

Not failed.

Your failure() condition will NOT trigger.

--------------------------------------------------
## 6. Cleanup Strategy Pattern

Example:
```yml
jobs:
  deploy:
    steps:
      - run: deploy_script

      - name: Cleanup on cancel
        if: cancelled()
        run: echo "Rolling back..."

      - name: Cleanup on failure
        if: failure()
        run: echo "Handle failure"
```
--------------------------------------------------
## 7. Partial Job Execution

If step 2 fails:
- Step 3 runs only if condition allows
- Remaining steps skipped by default

Unless:

continue-on-error used.

--------------------------------------------------
## 8. Force Cancellation Test

Experiment:

1. Create job with sleep 30.
2. Start workflow.
3. Cancel manually.
4. Observe:
   - Which steps executed?
   - Which did not?
   - What status shown?

--------------------------------------------------
## 9. Dependent Job Behavior

If job A cancelled,

job B with needs: A

Will be skipped.

Even if failure() condition exists.

--------------------------------------------------
## 10. Concurrency Cancellation Edge Case

With:
```yml
concurrency:
  cancel-in-progress: true
```
Push multiple commits.

Observe:
Earlier run status = cancelled.
Latest run continues.

Design pipeline accordingly.

--------------------------------------------------
## 11. Advanced Insight

Cancelled run:
Does not imply code failure.
It implies replacement or manual stop.

Do NOT treat cancelled as error in production systems.

--------------------------------------------------
## 12. Mental Model Upgrade
```
success() → Green path
failure() → Error path
cancelled() → Interrupted path
always() → Guaranteed path
```
You now control all execution endings.

--------------------------------------------------
## Checkpoint Questions

1. Does failure() run when workflow cancelled?
2. What status does concurrency cancellation produce?
3. When should cancelled() be used?
4. What happens to dependent jobs after cancellation?
5. Why is cancellation not equal to failure?

If unsure, redo experiments.