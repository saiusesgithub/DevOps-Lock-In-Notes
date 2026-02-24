# DAY 2 — Event Payload & GitHub Context Deep Dive

#### Date: 24th February 2026

--------------------------------------------------
## Objective

Understand what data GitHub provides during workflow execution.
Learn how to inspect event payload.
Master github context usage.

This is where workflows become intelligent.

--------------------------------------------------
## 1. What is Context?

Context = Structured data provided by GitHub during workflow execution.

Accessible using:
```yml
${{ context.property }}
```
Most important context:
```yml
${{ github }}
```
Others:
```yml
${{ env }}
${{ runner }}
${{ job }}
${{ steps }}
${{ strategy }}
${{ matrix }}
```

--------------------------------------------------
## 2. The github Context (Core Context)

The github context contains:

- Event metadata
- Repository info
- Branch info
- Actor info
- Commit info
- Trigger type

Examples:
```yml
${{ github.event_name }}
${{ github.ref }}
${{ github.repository }}
${{ github.actor }}
${{ github.sha }}
${{ github.run_id }}
${{ github.run_number }}
```

--------------------------------------------------
## 3. Important github Context Variables
```
github.event_name
→ Type of trigger (push, pull_request, schedule, workflow_dispatch)

github.ref
→ Full branch reference (refs/heads/main)

github.sha
→ Commit SHA that triggered workflow

github.repository
→ owner/repo-name

github.actor
→ User who triggered workflow

github.workflow
→ Workflow name

github.run_number
→ Incrementing number for workflow runs
```

--------------------------------------------------
## 4. Inspecting Full Event Payload

You can print full JSON event payload:
```yml
- name: Print Event JSON
  run: echo "${{ toJson(github.event) }}"
```
This shows full structured data for that trigger.

Important:
Event payload differs for push, PR, schedule, manual.


--------------------------------------------------
## 5. Difference Between push and pull_request Payload

push event contains:
- commit info
- pusher name
- branch ref

pull_request event contains:
- PR number
- base branch
- head branch
- PR title
- PR body

So:
push ≠ pull_request
They have different payload structure.


--------------------------------------------------
## 6. runner Context
```yml
${{ runner.os }} → ubuntu / windows / macOS

${{ runner.arch }} → x64
```
Useful when using matrix strategy.


--------------------------------------------------
## 7. env Context

Variables defined in:
```yml
env:
  MY_VAR: value
```
Accessible via:
```yml
${{ env.MY_VAR }}
```
Different from shell variables ($MY_VAR).


--------------------------------------------------
## 8. steps Context

After a step runs, you can reference its output.

Example:
```yml
- name: Step A
  id: step_a
  run: echo "value=hello" >> $GITHUB_OUTPUT
```
Then:
```yml
${{ steps.step_a.outputs.value }}
```
This allows step communication.


--------------------------------------------------
## 9. strategy & matrix Context

When using matrix:
```yml
${{ matrix.os }}
${{ strategy.job-index }}
```
Helps customize behavior per matrix combination.


--------------------------------------------------
## 10. Real-World Use Cases

Context enables:

- Branch-based deployment logic
- Conditional job execution
- PR-specific validation
- Actor-based restrictions
- Dynamic naming
- Intelligent logging


--------------------------------------------------
## 11. Mandatory Experiments (Do All)

1. Print github.event_name.
2. Print github.ref.
3. Print github.actor.
4. Print github.sha.
5. Print runner.os.
6. Print full event payload using toJson.
7. Trigger workflow via push.
8. Trigger workflow via pull_request.
9. Compare payload differences.


--------------------------------------------------
## 12. Mental Model Upgrade

Workflow = Program

Event Payload = Input Data

Context = Runtime Environment

Expressions = Logic Layer

GitHub Actions is not static YAML.
It is event-driven runtime logic.


--------------------------------------------------
## Checkpoint Questions

Answer clearly:

1. What is difference between github.ref and github.head_ref?
2. Where are manual inputs stored?
3. Can event payload structure change between triggers?
4. What does toJson(github.event) show?
5. Why is context critical for conditional execution?

If unsure,
repeat experiments.