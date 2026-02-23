# DAY 1 — First GitHub Actions Workflow

#### Date: 23rd February 2026

--------------------------------------------------
## Objective

Create your first proper GitHub Actions workflow.
Understand every line.
Analyze logs deeply.
Do not treat it as magic.

--------------------------------------------------
## Step 1 — Folder Structure

Inside your repository, create:

Exact path:

```
.github/workflows/ci.yml
```

If folder name is wrong, GitHub will NOT detect workflow.

--------------------------------------------------
## Step 2 — Basic Workflow Template

Add this inside ci.yml:

```yaml
name: Day1-CI

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Print Working Directory
        run: pwd

      - name: List Files
        run: ls -la

      - name: Print Custom Message
        run: echo "GitHub Actions is running successfully"
```
--------------------------------------------------
## Step 3 — Commit & Push
```
git add .
git commit -m "Add Day 1 CI workflow"
git push origin main
```

Now go to:

GitHub → Repository → Actions tab

Observe workflow execution.

--------------------------------------------------
## Step 4 — Understand Every Line

name:
Human-readable workflow name.

on:
Defines which event triggers this workflow.

push:
Event type.

branches:
Only runs when pushing to main branch.

jobs:
Defines execution units.

build:
Job name (you can name it anything).

runs-on:
Defines which runner machine to use.
ubuntu-latest = GitHub-hosted Linux VM.

steps:
Sequential list of instructions.

uses:
Uses a prebuilt action from marketplace.

run:
Executes shell command on runner.

--------------------------------------------------
## Step 5 — Log Deep Analysis

When workflow runs, observe:

1. "Set up job"
   → Runner VM is being prepared.

2. "Checkout Code"
   → Repository is cloned inside VM.

3. Shell steps:
   → Commands executed in VM environment.

4. Job completion status:
   → Success or Failure.

Important:
The runner is NOT your laptop.
It is a fresh cloud VM created for this job.

--------------------------------------------------
## Step 6 — Add Controlled Failure

Modify last step:

```yml
- name: Force Failure
  run: exit 1
```

Push again.

Observe:
- Which step fails?
- Does workflow stop?
- What is exit code behavior?

Now remove failure.

--------------------------------------------------
## Step 7 — Mental Model Check

Execution Flow:

Push to main
→ GitHub detects event
→ Workflow file evaluated
→ Runner VM created
→ Job starts
→ Steps execute sequentially
→ Logs generated
→ Status returned

--------------------------------------------------
## Mandatory Experiment

Add 3 more steps:

- Create a file
- Read that file
- Print environment variables (env)

Example:

```yml
run: |
  echo "hello world" > test.txt
  cat test.txt
```

Observe:
File persists between steps (within same job).

--------------------------------------------------
## Important Understanding

Within a job:
- Steps share same filesystem.
- Steps run sequentially.
- State persists inside that job.

Across jobs:
- No shared filesystem.
- Separate runners.

You will test this tomorrow.

--------------------------------------------------
## Day 1 Checkpoint Question

After running this:

Answer these without guessing:

1. Where exactly does ubuntu-latest run?
2. Does runner persist after workflow ends?
3. Why do we need actions/checkout?
4. What happens if we remove checkout?
5. Why does exit 1 fail the job?

If you cannot answer clearly,
you have not understood execution engine.