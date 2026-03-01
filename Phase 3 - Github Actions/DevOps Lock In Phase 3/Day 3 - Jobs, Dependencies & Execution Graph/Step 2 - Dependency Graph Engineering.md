# DAY 3 — needs Dependency Graph Engineering

#### Date: 25th February 2026

--------------------------------------------------
## Objective

Control job execution order.
Design directed acyclic graphs (DAG).
Understand failure propagation.

Today we move from parallel chaos → structured flow.

--------------------------------------------------
## 1. What is needs?

needs defines job dependencies.

Example:
```yml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Build"

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - run: echo "Test"
```
This means:
test runs only AFTER build completes successfully.


--------------------------------------------------
## 2. Default Behavior vs needs

Without needs:
Jobs run in parallel.

With needs:
Execution becomes sequential or structured.

needs creates edges between nodes.


--------------------------------------------------
## 3. Basic Dependency Chain

Example:

build → test → deploy
```yml
jobs:
  build:
  test:
    needs: build
  deploy:
    needs: test
```
Execution order:
```
build
  ↓
test
  ↓
deploy
```

--------------------------------------------------
## 4. Multiple Dependencies

Example:
```yml
jobs:
  build:
  lint:
  test:
    needs: [build, lint]
```
This means:
test runs only after BOTH build and lint succeed.

Graph structure:
```
build   lint
   \     /
     test
```

--------------------------------------------------
## 5. Failure Propagation

If a job fails:

All jobs that depend on it are skipped.

Example:
```
build fails
test depends on build
→ test is skipped (not failed, skipped)
```
This prevents cascading execution.


--------------------------------------------------
## 6. Visualizing DAG

Workflow is a DAG (Directed Acyclic Graph).

Directed:
Dependencies have direction.

Acyclic:
No circular references allowed.

Invalid example:
```
job1 needs job2
job2 needs job1
```
This creates cycle → GitHub rejects workflow.


--------------------------------------------------
## 7. Complex Graph Example
```yml
jobs:
  build:
  lint:
  test:
    needs: [build, lint]
  security_scan:
    needs: build
  deploy:
    needs: [test, security_scan]
```
Graph:
```
build     lint
  ↓         ↓
security   test
     \     /
       deploy
```

--------------------------------------------------
## 8. Measuring Execution Time

Experiment:

Create:

- build (sleep 5)
- lint (sleep 5)
- test (sleep 5, needs both)
- deploy (sleep 5, needs test)

Observe runtime:

build + lint (parallel) → 5 sec
test → 5 sec
deploy → 5 sec

Total ≈ 15 seconds.

This proves structured execution.


--------------------------------------------------
## 9. Skip vs Fail

If dependency fails:

Dependent job = skipped.

If dependency succeeds:

Dependent job runs.

Important distinction:
Skipped ≠ Failed


--------------------------------------------------
## 10. Combining needs with Parallelism

Example:
```
build
lint
scan
```
All parallel.

Then:
```
test needs: [build, lint]
deploy needs: [test, scan]
```
You control graph exactly.


--------------------------------------------------
## 11. Mandatory Experiments

1. Create 4 jobs: build, lint, test, deploy.
2. Run without needs → observe parallel.
3. Add sequential chain.
4. Add multiple dependency job.
5. Force build to fail.
6. Observe dependent jobs skipped.
7. Attempt circular dependency → observe validation error.


--------------------------------------------------
## 12. Mental Model Upgrade

Jobs = Nodes

needs = Edges

Workflow = Directed Acyclic Graph

Parallel execution = nodes without dependency.

Sequential execution = defined edges.

You are designing execution graph.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. What happens if a dependency fails?
2. Can a job depend on multiple jobs?
3. Why must graph be acyclic?
4. How do you create parallel branches?
5. What is difference between failed and skipped?

If unsure,
redo experiments.