# DAY 4 — Contexts Deep Dive & Expression Engine

#### Date: 26th February 2026

--------------------------------------------------
## Objective

Understand how GitHub Actions evaluates expressions.
Master contexts.
Control dynamic behavior.
Think like the workflow engine.

This is the brain of GHA.

--------------------------------------------------
## 1. What is a Context?

A context is a structured object
that contains metadata about workflow execution.

Accessed using:
```yml
${{ context.property }}
```
Examples:
```yml
${{ github.ref }}
${{ runner.os }}
${{ env.APP_ENV }}
```
--------------------------------------------------
## 2. Major Context Objects

- github
- env
- job
- steps
- runner
- matrix
- secrets
- inputs
- strategy

Each contains structured data.

--------------------------------------------------
## 3. github Context

Contains event metadata.

Examples:
```yml
${{ github.ref }}
${{ github.event_name }}
${{ github.actor }}
${{ github.sha }}
${{ github.repository }}
```
Use case:
Branch-based conditions.

Example:
```yml
if: ${{ github.ref == 'refs/heads/main' }}
```
--------------------------------------------------
## 4. env Context

Contains environment variables.

Example:
```yml
${{ env.APP_ENV }}
```
Different from shell expansion ($APP_ENV).

Expression context evaluated BEFORE runner execution.

--------------------------------------------------
## 5. runner Context

Information about runner machine.
```yml
${{ runner.os }}
${{ runner.arch }}
${{ runner.name }}
${{ runner.temp }}
```
Useful for cross-platform logic.

--------------------------------------------------
## 6. matrix Context

Available inside matrix jobs.
```yml
${{ matrix.os }}
${{ matrix.version }}
```
Each job instance has different matrix values.

--------------------------------------------------
## 7. steps Context

Access outputs of previous steps.

Example:
```yml
- name: Set output
  id: step1
  run: echo "value=hello" >> $GITHUB_OUTPUT
```
Then access:
```yml
${{ steps.step1.outputs.value }}
```
Critical for passing data within job.

--------------------------------------------------
## 8. job Context

Information about job.
```yml
${{ job.status }}
```
Values:
- success
- failure
- cancelled

Useful for conditional execution.

--------------------------------------------------
## 9. secrets Context
```yml
${{ secrets.API_KEY }}
```
Injected securely at runtime.

Cannot be printed in expressions directly.

--------------------------------------------------
## 10. inputs Context

Used in reusable workflows or workflow_dispatch.
```yml
${{ inputs.environment }}
```
Useful for manual triggers.

--------------------------------------------------
## 11. Expression Evaluation Timing

Important:
```
${{ }} expressions are evaluated
by GitHub BEFORE sending job to runner.
```
Shell variables ($VAR)
are evaluated INSIDE runner.

Two different evaluation layers.

--------------------------------------------------
## 12. Conditional Logic

Example:
```yml
if: ${{ github.event_name == 'push' && runner.os == 'Linux' }}
```
Logical operators:
```
== equality
!= inequality
&& AND
|| OR
! NOT
```
--------------------------------------------------
## 13. toJSON Debugging Trick

To inspect context:
```yml
- run: echo '${{ toJSON(github) }}'
```
This prints full github object.

Very useful for debugging.

--------------------------------------------------
## 14. Order of Resolution

Workflow parsing
→ Expression resolution
→ Runner allocation
→ Shell execution

Understanding this prevents logic mistakes.

--------------------------------------------------
## 15. Common Mistake

Incorrect:
```yml
run: echo "${{ github.ref }}"
```
Correct:

Expression resolves first,
then shell executes.

Do not confuse with $GITHUB_REF.

--------------------------------------------------
## 16. Dynamic Example
```yml
- name: Conditional Deploy
  if: ${{ github.ref == 'refs/heads/main' && success() }}
  run: echo "Deploying"
```
Combines context + function.

--------------------------------------------------
## 17. Mandatory Experiments

1. Print github context using toJSON.
2. Print runner context.
3. Use matrix context in echo.
4. Create step output and read via steps context.
5. Write branch-based conditional job.
6. Compare $VAR vs ${{ env.VAR }}.
7. Break expression intentionally.

--------------------------------------------------
## 18. Mental Model Upgrade

Contexts = Metadata objects.

Expressions = Pre-runtime evaluation.

Shell variables = Runtime evaluation.

Two-layer execution model:

GitHub Engine + Runner.

You must know which layer you are operating in.

--------------------------------------------------
## 19. Checkpoint Questions

1. When are expressions evaluated?
2. Difference between $VAR and ${{ env.VAR }}?
3. How to access step output?
4. What does toJSON() do?
5. Which context contains branch name?

If unsure, redo experiments.