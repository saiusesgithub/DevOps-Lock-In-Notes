# DAY 1 — Internal Execution Flow

#### Date: 24th February 2026

--------------------------------------------------
## Objective

Build a complete mental model of what happens
from push → workflow result.

No magic.
No assumptions.
Only clear system flow.

--------------------------------------------------
## 1. High-Level Flow

Push → Event → Workflow Detection → Runner Allocation → Job Execution → Step Execution → Logs → Result → Runner Destroyed


--------------------------------------------------
## 2. Detailed Execution Breakdown

### Stage 1 — Developer Action

You run:
```
git push origin main
```
This sends commit to GitHub.


--------------------------------------------------
### Stage 2 — Event Detection

GitHub detects event:
push

It checks:

- Does repository have .github/workflows/ ?
- Does any workflow file match this event?
- Do branch filters match?

If YES → continue

If NO → workflow does not run


--------------------------------------------------
### Stage 3 — Workflow Parsing

GitHub reads your YAML file.

It validates:

- Syntax correctness
- Proper structure
- Trigger conditions
- Job definitions

If YAML invalid → workflow fails immediately


--------------------------------------------------
### Stage 4 — Runner Allocation

For each job:

runs-on: ubuntu-latest

GitHub:

- Provisions a fresh VM
- Assigns it to job
- Prepares environment
- Installs preconfigured tools

Each job = separate runner


--------------------------------------------------
### Stage 5 — Job Execution

Inside the runner:

1. Set up environment
2. Download action dependencies
3. Start executing steps sequentially

Logs begin streaming.


--------------------------------------------------
### Stage 6 — Step Execution

For each step:

- New shell session created
- Command executed
- Exit code captured
- Logs recorded

If exit code ≠ 0:
Job fails (unless configured otherwise)


--------------------------------------------------
### Stage 7 — Result Evaluation

After all steps:

If all succeeded:
Job marked SUCCESS

If any failed:
Job marked FAILURE

Workflow status updated.


--------------------------------------------------
### Stage 8 — Cleanup

After job completes:

- Runner VM destroyed
- Filesystem wiped
- Memory cleared
- No persistence remains


--------------------------------------------------
## 3. Complete Mental Diagram
```
Push
  ↓
GitHub receives event
  ↓
Workflow YAML evaluated
  ↓
Trigger conditions matched
  ↓
Runner VM created
  ↓
Repository cloned (checkout)
  ↓
Steps executed sequentially
  ↓
Exit codes evaluated
  ↓
Job marked success/failure
  ↓
Runner destroyed
```

--------------------------------------------------
## 4. Important Observations

1. Workflow file is just a blueprint.
2. GitHub is the orchestrator.
3. Runner is the execution machine.
4. Job is an isolated unit.
5. Step is a shell command inside machine.
6. Logs are streamed from runner to GitHub UI.
7. Nothing persists after job ends.


--------------------------------------------------
## 5. Edge Case Understanding

Case 1: YAML error
→ Workflow does not start

Case 2: Runner fails to start
→ Infrastructure error

Case 3: Step exits with error
→ Job fails

Case 4: Multiple jobs
→ Parallel runners allocated

Case 5: needs dependency
→ Execution order controlled


--------------------------------------------------
## 6. Why This Model Matters

Without this understanding:

You think:
"GitHub is doing something mysterious."

With this understanding:

You know:
"This is cloud infrastructure provisioning and automation execution."


--------------------------------------------------
## 7. Deep Reflection Exercise

Without looking:

Write answers to:

1. What is evaluated first — YAML or runner creation?
2. At what stage is branch filter checked?
3. When exactly is checkout executed?
4. What is destroyed at end?
5. What persists between workflow runs?


--------------------------------------------------
## 8. Final Mental Upgrade

GitHub Actions is:

Event-driven cloud infrastructure
that provisions ephemeral machines
to execute declarative automation instructions
and reports execution status.

That is the system.