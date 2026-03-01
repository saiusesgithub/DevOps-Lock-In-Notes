# DAY 3 — Full Execution Graph Engineering Challenge

#### Date: 25th February 2026

--------------------------------------------------
## Objective

Combine:
- Parallel jobs
- needs dependencies
- Matrix strategy
- Failure control
- continue-on-error
- fail-fast

Design a real execution graph.

Today you architect a pipeline.

--------------------------------------------------
## 1. Target Architecture
```
We will build this graph:

          build
             ↓
     ┌───────┴────────┐
   lint              test (matrix)
                         ↓
                      security
                         ↓
                       deploy
```
Rules:
- build must run first
- lint runs after build
- test runs after build (matrix: 2 OS)
- security runs after test
- deploy runs only if everything succeeds
- notification job runs only if failure occurs

--------------------------------------------------
## 2. Build the Base Job
```yml
Job: build

- runs-on: ubuntu-latest
- sleep 3
- echo "Building"
```
--------------------------------------------------
## 3. Add Lint Job
```yml
lint:
  needs: build
  runs-on: ubuntu-latest
  steps:
    - sleep 2
    - echo "Linting"
```
--------------------------------------------------
## 4. Add Matrix Test Job
```yml
test:
  needs: build
  strategy:
    fail-fast: false
    matrix:
      os: [ubuntu-latest, windows-latest]
  runs-on: ${{ matrix.os }}
  steps:
    - sleep 3
    - echo "Testing on ${{ matrix.os }}"
```
Observe:
Two test jobs created.

--------------------------------------------------
## 5. Add Security Job
```yml
security:
  needs: test
  runs-on: ubuntu-latest
  steps:
    - sleep 2
    - echo "Security scanning"
```
--------------------------------------------------
## 6. Add Deploy Job
```yml
deploy:
  needs: [lint, security]
  runs-on: ubuntu-latest
  steps:
    - echo "Deploying"
```
This ensures:
deploy runs only if lint AND security succeed.

--------------------------------------------------
## 7. Add Notification Job (Failure Handler)
```yml
notify:
  if: failure()
  runs-on: ubuntu-latest
  steps:
    - echo "Pipeline failed. Sending notification."
```
This runs only when any job fails.

--------------------------------------------------
## 8. Now Force Controlled Failure

Modify one matrix test:
```yml
if: ${{ matrix.os == 'windows-latest' }}
run: exit 1
```
Observe:

- One matrix job fails
- security job does not run
- deploy does not run
- notify runs

This proves failure propagation works.

--------------------------------------------------
## 9. Remove fail-fast

Set:
```yml
fail-fast: false
```
Observe:
Even if one matrix job fails,
other matrix job completes.

Understand behavior difference.

--------------------------------------------------
## 10. Measure Execution Flow

Time estimation:
```
build (3s)
lint + test (parallel)
security (after test)
deploy (after lint + security)
```
Sketch actual runtime behavior.

--------------------------------------------------
## 11. Visual DAG Representation
```
build
  ↓
lint      test(ubuntu)   test(windows)
                ↓
              security
                ↓
              deploy

notify runs only if any failure.

```
--------------------------------------------------
## 12. Rebuild Challenge (No Copy)

Delete workflow.

From memory recreate:

- Parallel jobs
- Dependency chain
- Matrix
- fail-fast control
- Failure handler
- Conditional deploy

No looking.
No copy.

--------------------------------------------------
## 13. Day 3 Mastery Questions

Answer clearly:

1. What happens if one matrix job fails?
2. What controls early cancellation?
3. Why is deploy dependent on multiple jobs?
4. When does notify run?
5. What ensures no circular dependencies?
6. Can matrix jobs depend on another job?
7. What is the difference between job failure and step failure?

If you hesitate,
redo rebuild challenge.


--------------------------------------------------
## End of Day 3 Outcome

By end of today you should:

- Think in execution graphs
- Design parallel + sequential systems
- Control failure propagation
- Use matrix intelligently
- Build DAG-based CI systems

You now understand execution architecture.