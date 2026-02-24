# DAY 1 — Step Execution Model

#### Date: 24th February 2026

--------------------------------------------------
## Objective

Understand how steps execute inside a job.
Understand filesystem behavior.
Understand shell execution.
Remove any confusion about persistence.

--------------------------------------------------
## 1. How Steps Execute

Inside a job:
```yaml
steps:
  - name: Step 1
    run: command1

  - name: Step 2
    run: command2
```
Each step:
- Runs sequentially
- Executes in the same runner machine
- Uses the same working directory
- Shares the same filesystem

Steps do NOT run in parallel within a job.

Execution model:

Step 1 finishes
→ Step 2 starts
→ Step 3 starts
→ and so on


--------------------------------------------------
## 2. Filesystem Persistence Within a Job

Within same job:

Files created in Step 1
WILL exist in Step 2.

Example:
```yml
- name: Create File
  run: echo "Hello World" > test.txt

- name: Read File
  run: cat test.txt
```
This will work.

Reason:
Same runner.
Same filesystem.


--------------------------------------------------
## 3. Working Directory Behavior

By default:

Working directory = repository root

After checkout, your repo exists in:

/home/runner/work/<repo-name>/<repo-name>

pwd command shows current directory.

Experiment:

Add step:
```yaml
- name: Print Working Directory
  run: pwd
```
Understand where commands execute.


--------------------------------------------------
## 4. Environment Variables Inside Steps

Environment variables defined using:
```yaml
env:
  VARIABLE_NAME: value
```
Are accessible in steps using:
```
$VARIABLE_NAME
```
Example:
```yaml
env:
  MY_NAME: Srujan

steps:
  - run: echo $MY_NAME
```
Understand:
Shell variable expansion happens inside runner.


--------------------------------------------------
## 5. Shell Behavior

On ubuntu-latest:

Default shell = bash

So:
```yaml
run: echo "hello"
```
Is executed as:
```
bash -e {temporary-script.sh}
```
If command exits with non-zero code:
Step fails.

If step fails:
Job fails (unless continue-on-error is set).


--------------------------------------------------
## 6. Exit Codes Explained

Exit codes:

exit 0 → Success

exit non-zero (1,2,3...) → Failure

Example:
```yaml
- name: Fail Step
  run: exit 1
```
This will fail job.

Important:
GitHub Actions treats non-zero exit as error signal.


--------------------------------------------------
## 7. Step Isolation vs Job Isolation

Within same job:
- Files persist
- Environment persists
- Shell context resets per step (but filesystem remains)

Across different jobs:
- Files do NOT persist
- Environment does NOT persist
- Completely new runner


--------------------------------------------------
## 8. Important Detail: Shell Context Reset

Each step runs in a new shell instance.

This means:
```yaml
- name: Set Variable
  run: |
    VAR=hello

- name: Print Variable
  run: echo $VAR
```
This will NOT work.

Reason:
Shell variables do not persist between steps.

But files DO persist.

Understand the difference.


--------------------------------------------------
## 9. Mandatory Experiments (Do All)

Experiment 1:
Create file in step 1.
Read it in step 2.
Confirm success.

Experiment 2:
Set shell variable in step 1.
Try to read it in step 2.
Confirm failure.

Experiment 3:
Use environment variable via env: block.
Access it successfully.

Experiment 4:
Create two jobs.
Pass file from job1 to job2.
Observe failure.


--------------------------------------------------
## 10. Mental Model Upgrade

Inside a Job:
- Same machine
- Same disk
- New shell per step

Across Jobs:
- New machine
- New disk
- Total isolation

Across Workflow Runs:
- Everything destroyed


--------------------------------------------------
## 11. Professional Insight

Most beginners confuse:
Shell variable persistence
with
Filesystem persistence.

Correct understanding:
Files persist inside job.
Shell memory does NOT.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. Why does file persist between steps?
2. Why does shell variable not persist?
3. What causes job failure?
4. Does environment variable defined with env persist?
5. What resets between steps?

If you cannot answer confidently,
repeat experiments.