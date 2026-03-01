# DAY 3 — Matrix Strategy Engineering

#### Date: 25th February 2026

--------------------------------------------------
## Objective

Understand how one job definition expands into multiple jobs.
Control job explosion.
Engineer scalable pipelines.

Matrix = Automatic job generation system.

--------------------------------------------------
## 1. What is Matrix Strategy?

Matrix allows you to run the same job
with different configurations.

Example:
```yml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest]

runs-on: ${{ matrix.os }}
```
This creates 2 jobs automatically.


--------------------------------------------------
## 2. How Matrix Expands

If you define:
```yml
matrix:
  os: [ubuntu, windows]
  version: [1, 2]
```
GitHub creates:

ubuntu + version 1
ubuntu + version 2
windows + version 1
windows + version 2

Total = 2 × 2 = 4 jobs

This is Cartesian product expansion.


--------------------------------------------------
## 3. Accessing Matrix Variables

Inside steps:
```yml
${{ matrix.os }}
${{ matrix.version }}
```
Example:
```yml
- run: echo "OS: ${{ matrix.os }} Version: ${{ matrix.version }}"
```

--------------------------------------------------
## 4. Matrix Execution Model

Matrix jobs:
- Run in parallel
- Each gets separate runner
- Fully isolated

Graph:
```
Job (definition)
  ↓ expands into
Job1  Job2  Job3  Job4
```

--------------------------------------------------
## 5. Controlling Matrix Explosion

Too many combinations = slow pipeline.

Example:
```yml
matrix:
  os: [ubuntu, windows, mac]
  version: [1,2,3,4]
```
3 × 4 = 12 jobs.

Be careful with combinations.


--------------------------------------------------
## 6. include Keyword

You can add custom combinations:
```yml
strategy:
  matrix:
    os: [ubuntu]
    version: [1, 2]
    include:
      - os: windows
        version: 3
```
This adds custom job beyond cartesian product.


--------------------------------------------------
## 7. exclude Keyword

You can remove specific combinations:
```yml
strategy:
  matrix:
    os: [ubuntu, windows]
    version: [1, 2]
    exclude:
      - os: windows
        version: 2
```
Removes that specific combination.


--------------------------------------------------
## 8. fail-fast Behavior

By default:
If one matrix job fails,
others may cancel early.

To disable:
```yml
strategy:
  fail-fast: false
  matrix:
    os: [ubuntu, windows]
```
Now all matrix jobs run fully.


--------------------------------------------------
## 9. Using Matrix with needs

Matrix jobs can depend on another job.

Example:
```yml
build:
  runs-on: ubuntu-latest

test:
  needs: build
  strategy:
    matrix:
      os: [ubuntu, windows]
```
Execution:

build → multiple test jobs


--------------------------------------------------
## 10. Dynamic Matrix Example
```yml
strategy:
  matrix:
    node-version: [16, 18, 20]
```
This is common in real CI pipelines.

You test against multiple runtime versions.


--------------------------------------------------
## 11. Matrix + Conditional Logic

Example:
```yml
if: ${{ matrix.os == 'ubuntu-latest' }}
```
This allows OS-specific behavior.


--------------------------------------------------
## 12. Practical Experiments (Mandatory)

1. Create matrix with 2 OS.
2. Add second dimension (version).
3. Print both values.
4. Add exclude rule.
5. Add include rule.
6. Enable fail-fast false.
7. Force one matrix job to fail.
8. Observe behavior.


--------------------------------------------------
## 13. Visual Mental Model

Without matrix:
1 job = 1 runner

With matrix:
1 job definition = N runners

Matrix = Job multiplier.


--------------------------------------------------
## 14. Professional Insight

Matrix is used for:

- Multi-OS testing
- Multi-version testing
- Multi-environment validation
- Scalability testing

It is extremely powerful.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. How many jobs created for 3 OS × 4 versions?
2. What does include do?
3. What does exclude do?
4. What does fail-fast control?
5. Does each matrix job get separate runner?

If unsure,
repeat experiments.