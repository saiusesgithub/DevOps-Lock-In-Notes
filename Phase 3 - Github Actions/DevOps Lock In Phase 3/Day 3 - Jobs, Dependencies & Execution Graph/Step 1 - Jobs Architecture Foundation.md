# DAY 3 — Jobs Architecture Foundation

#### Date: 25th February 2026

--------------------------------------------------
## Objective

Understand jobs as isolated execution units.
Learn parallelism.
Understand execution graph basics.

Today is about thinking in graphs, not files.

--------------------------------------------------
## 1. What is a Job?

A job is an independent execution unit inside a workflow.

Example:
```yml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building"
```
Each job:
- Runs on its own runner
- Has isolated filesystem
- Has isolated environment
- Executes steps sequentially

Job = Independent Machine


--------------------------------------------------
## 2. Multiple Jobs in One Workflow

Example:
```yml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Build"

  test:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Test"
```
By default:
Jobs run in parallel.


--------------------------------------------------
## 3. Visualizing Execution Graph

Without dependencies:
```
build      test
  ↓          ↓
 (parallel execution)
```
Each job:
- Gets separate runner
- No shared filesystem


--------------------------------------------------
## 4. Proving Parallel Execution

Create 2 jobs:
```yml
Job A:
  sleep 10

Job B:
  sleep 10
```
Observe:
Total runtime ≈ 10 seconds
(Not 20)

This proves parallelism.


--------------------------------------------------
## 5. Job Isolation Proof

Experiment:
```yml
Job 1:
  echo "hello" > file.txt

Job 2:
  cat file.txt

Result:
Job 2 fails.
```
Reason:
Different runner.
Different filesystem.


--------------------------------------------------
## 6. Why Job Isolation Matters

Isolation ensures:

- Security
- Predictability
- Reproducibility
- Clean execution
- No hidden state

Every job is clean-slate.


--------------------------------------------------
## 7. Job Lifecycle

For each job:

1. Runner allocated
2. Environment prepared
3. Steps executed sequentially
4. Exit codes evaluated
5. Job marked success/failure
6. Runner destroyed

Every job repeats this lifecycle.


--------------------------------------------------
## 8. Step vs Job Mental Comparison

Step:
- Runs inside job
- Shares same runner
- Shares same filesystem

Job:
- New runner
- New machine
- Full isolation

Step = Command
Job = Machine


--------------------------------------------------
## 9. Mandatory Experiments

1. Create 3 jobs without dependencies.
2. Add sleep 10 in each.
3. Observe total runtime.
4. Prove they run in parallel.
5. Try file sharing between jobs.
6. Confirm failure.


--------------------------------------------------
## 10. Mental Model Upgrade

Workflow = Graph

Jobs = Nodes

Dependencies = Edges

Runner = Execution Machine per Node

GitHub Actions is DAG-based execution engine.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. Do jobs run sequentially by default?
2. Does each job get its own runner?
3. Why can't jobs share files?
4. What guarantees isolation?
5. What is the lifecycle of a job?

If unsure,
repeat experiments.