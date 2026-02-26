# DAY 4 — Environment Variables Architecture

#### Date: 26th February 2026

--------------------------------------------------
## Objective

Understand environment variable scope.
Understand precedence.
Avoid accidental leaks.
Design clean configuration.

--------------------------------------------------
## 1. What is an Environment Variable?

An environment variable is a key-value pair
available during workflow execution.

Used for:
- Configuration
- Runtime parameters
- Flags
- Paths
- Secrets (but not directly)

--------------------------------------------------
## 2. Workflow-Level Environment Variables

Defined at top level:
```yml
env:
  APP_ENV: development
  VERSION: 1.0
```
Scope:
Available to ALL jobs and steps.

--------------------------------------------------
## 3. Job-Level Environment Variables
```yml
jobs:
  build:
    env:
      APP_ENV: staging
```
Scope:
Available only inside that job.

Overrides workflow-level variable if same name.

--------------------------------------------------
## 4. Step-Level Environment Variables
```yml
steps:
  - name: Step with env
    env:
      TEMP_VAR: value
    run: echo $TEMP_VAR
```
Scope:
Only inside that step.

--------------------------------------------------
## 5. Variable Precedence (Very Important)

Step-level > Job-level > Workflow-level

If same variable defined multiple times:
Closest scope wins.

--------------------------------------------------
## 6. Accessing Environment Variables

Inside shell:
```yml
$APP_ENV (Linux)
$env:APP_ENV (PowerShell)
```
Inside expressions:
```yml
${{ env.APP_ENV }}
```
Difference:
Shell expansion ≠ GitHub expression context.

--------------------------------------------------
## 7. Environment Variables vs Shell Variables

Shell variable:
```yml
run: |
  VAR=hello
  echo $VAR
```
Does NOT persist to next step.

Environment variable (env block):
Persists inside scope.

--------------------------------------------------
## 8. Using GITHUB_ENV to Persist Across Steps

To create dynamic variable:
```yml
- name: Set Variable
  run: echo "DYNAMIC_VAR=hello" >> $GITHUB_ENV
```
Now accessible in later steps.

This persists for remainder of job.

--------------------------------------------------
## 9. Mandatory Experiments

1. Define workflow-level env.
2. Override at job-level.
3. Override at step-level.
4. Print all three.
5. Use GITHUB_ENV to set dynamic variable.
6. Confirm persistence across steps.

--------------------------------------------------
## 10. Mental Model Upgrade

env block = configuration layer

Shell variable = temporary memory

GITHUB_ENV = job-level dynamic injection

Scopes control visibility.

--------------------------------------------------
## Checkpoint Questions

1. What overrides what?
2. Does shell variable persist across steps?
3. What does GITHUB_ENV do?
4. Difference between $VAR and ${{ env.VAR }}?
5. Where should configuration variables live?

If unsure, redo experiments.