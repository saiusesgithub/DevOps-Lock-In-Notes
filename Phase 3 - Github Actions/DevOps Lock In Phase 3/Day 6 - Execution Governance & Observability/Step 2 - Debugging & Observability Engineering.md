# DAY 6 — Debugging & Observability Engineering

#### Date: 28th February 2026

--------------------------------------------------
## Objective

Master workflow debugging.
Enable runner diagnostics.
Use workflow commands.
Improve observability.

Debugging is an engineering skill.

--------------------------------------------------
## 1. Default Log Behavior

GitHub Actions logs:

- Step names
- Shell output
- Exit codes
- Action metadata

But by default:
Debug logs are limited.

--------------------------------------------------
## 2. Enable Debug Logging (Two Methods)

Method 1 — Repository Secret

Create secret:
```yml
ACTIONS_STEP_DEBUG = true
```
Method 2 — From UI

Workflow Run → Enable debug logging (if available)

This increases verbosity.

--------------------------------------------------
## 3. Runner Diagnostic Logging

Create secret:
```yml
ACTIONS_RUNNER_DEBUG = true
```
This enables deeper runner-level logs.

Use carefully — very verbose.

--------------------------------------------------
## 4. Workflow Commands

GitHub provides special logging commands.

Example:
```yml
echo "::warning::This is a warning"
echo "::error::This is an error"
echo "::notice::This is a notice"
```
These create structured log entries.

--------------------------------------------------
## 5. Grouping Logs

You can group logs for clarity.

Example:
```yml
echo "::group::Build Step"
echo "Compiling..."
echo "::endgroup::"
```
Makes collapsible log sections.

--------------------------------------------------
## 6. Setting Outputs via Workflow Commands

Old method (deprecated style):
```yml
echo "::set-output name=result::value"
```
Modern method:
```yml
echo "result=value" >> $GITHUB_OUTPUT
```
Understanding logging commands is essential.

--------------------------------------------------
## 7. Debugging Context Data

Use:
```yml
echo '${{ toJSON(github) }}'
echo '${{ toJSON(runner) }}'
echo '${{ toJSON(matrix) }}'
```
Very useful when debugging event-based logic.

--------------------------------------------------
## 8. Inspecting Environment Variables

Print:
```yml
printenv
env
```
But never print secrets intentionally.

--------------------------------------------------
## 9. Step-Level Debug Pattern

Add:
```yml
- name: Debug Info
  run: |
    echo "Branch: ${{ github.ref }}"
    echo "Event: ${{ github.event_name }}"
    echo "Runner OS: ${{ runner.os }}"
```
Useful when pipeline behaves differently.

--------------------------------------------------
## 10. Exit Code Debugging

Add:
```yml
set -e
set -x
```
set -e → Exit immediately on error
set -x → Print commands before execution

Example:
```yml
run: |
  set -ex
  echo "Debugging"
```
--------------------------------------------------
## 11. Inspecting Job Status

Use:
```yml
${{ job.status }}
```
Print at end of job to confirm behavior.

--------------------------------------------------
## 12. Common Debugging Mistakes

❌ Forgetting expression vs shell variable difference
❌ Assuming env persists across jobs
❌ Not enabling debug logs
❌ Misusing if conditions
❌ Not grouping logs

--------------------------------------------------
## 13. Debug Workflow Template

Add temporary debug job:
```yml
debug:
  runs-on: ubuntu-latest
  steps:
    - run: |
        echo '${{ toJSON(github) }}'
        echo '${{ toJSON(env) }}'
        printenv
```
Use only during debugging.
Remove afterward.

--------------------------------------------------
## 14. Reproducing Failure Strategy

When something fails:

1. Enable ACTIONS_STEP_DEBUG
2. Print contexts
3. Isolate failing step
4. Convert composite action to inline temporarily
5. Simplify condition logic
6. Remove matrix temporarily
7. Rebuild minimal failing case

Systematic debugging.

--------------------------------------------------
## 15. Observability Mental Model

Logs = Observability.

Grouped logs = Structure.

Debug flags = Deep inspection.

Context dumps = Metadata visibility.

If you cannot see it,
you cannot fix it.

--------------------------------------------------
## 16. Practical Experiments

1. Add ::warning:: log.
2. Add grouped logs.
3. Enable ACTIONS_STEP_DEBUG.
4. Print full github context.
5. Intentionally fail step.
6. Observe exit behavior.
7. Remove debug settings afterward.

--------------------------------------------------
## 17. Checkpoint Questions

1. How do you enable step debug?
2. What does ACTIONS_RUNNER_DEBUG do?
3. How to create grouped logs?
4. Why use toJSON?
5. What does set -x do?

If unsure, redo experiments.