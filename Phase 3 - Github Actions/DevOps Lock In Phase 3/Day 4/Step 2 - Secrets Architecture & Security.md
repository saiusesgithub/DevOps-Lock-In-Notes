# DAY 4 — Secrets Architecture & Security

#### Date: 26th February 2026

--------------------------------------------------
## Objective

Understand how secrets work.
Understand masking behavior.
Prevent accidental leaks.
Design secure pipelines.

--------------------------------------------------
## 1. What is a Secret?

A secret is a secure value stored in GitHub
that can be accessed during workflow execution.

Examples:
- API keys
- Tokens
- Database passwords
- Cloud credentials

Secrets are encrypted at rest.

--------------------------------------------------
## 2. Where Secrets Are Stored

Three levels:

1. Repository secrets
2. Organization secrets
3. Environment secrets

Accessed via:
```yml
${{ secrets.SECRET_NAME }}
```
--------------------------------------------------
## 3. Creating Repository Secret

GitHub → Repository → Settings → Secrets and variables → Actions → New repository secret

Example:

- API_KEY
- DB_PASSWORD

--------------------------------------------------
## 4. Using Secrets in Workflow

Example:
```yml
- name: Print Secret (masked)
  run: echo "${{ secrets.API_KEY }}"
```
Important:
GitHub automatically masks secrets in logs.

--------------------------------------------------
## 5. Secret Masking Behavior

If secret value appears in logs,
GitHub replaces it with:
```
***
```
Masking works for:
Exact match only.

If modified (partial or concatenated),
masking may fail.

--------------------------------------------------
## 6. Dangerous Patterns

Unsafe:
```yml
run: echo "Token is ${{ secrets.API_KEY }}"
```
Even though masked,
never print secrets intentionally.

Safe:
Pass secret directly to tool.

Example:
```yml
env:
  API_KEY: ${{ secrets.API_KEY }}
```
Then tool reads from environment.

--------------------------------------------------
## 7. Secrets in Pull Requests (Critical)

Secrets are NOT available in:

- Workflows triggered from forked repositories.

Reason:
Prevent malicious contributors from stealing secrets.

If PR comes from fork:
secrets context returns empty.

--------------------------------------------------
## 8. Environment-Level Secrets

You can define secrets per environment:

Example:

- staging secret
- production secret

Useful for:
Deploying to different environments.

--------------------------------------------------
## 9. Using Secrets Securely

Correct pattern:
```yml
env:
  API_KEY: ${{ secrets.API_KEY }}

steps:
  - run: some_command_using_$API_KEY
```
Avoid:
Hardcoding secrets in YAML.

--------------------------------------------------
## 10. Secret Scope

Secrets are:
- Available only at runtime
- Not accessible outside workflow
- Not printed in UI
- Not visible in pull request logs (if fork)

--------------------------------------------------
## 11. Testing Secret Absence

Experiment:

1. Create secret.
2. Use it in workflow.
3. Remove secret.
4. Run workflow.
5. Observe failure or empty value.

--------------------------------------------------
## 12. Partial Leak Edge Case

If secret = ABC123

And you print:

echo "ABC123"

Masked.

But if you print:

echo "ABC"

May NOT be masked.

Masking matches full secret.

--------------------------------------------------
## 13. Professional Secret Handling Rules

1. Never echo secrets.
2. Use least privilege tokens.
3. Separate secrets by environment.
4. Do not expose secrets in logs.
5. Use environment protection for production.

--------------------------------------------------
## 14. Mental Model Upgrade

Secrets are injected at runtime.
They are not stored in YAML.
They are resolved by GitHub engine before execution.

They live only during runner execution.

--------------------------------------------------
## 15. Mandatory Experiments

1. Create 2 repository secrets.
2. Print them (observe masking).
3. Concatenate secret with text and print.
4. Remove secret and run workflow.
5. Create environment secret.
6. Test fork PR behavior (if possible).

--------------------------------------------------
## Checkpoint Questions

1. Where are secrets stored?
2. When are secrets injected?
3. Why are secrets unavailable in forked PRs?
4. Does masking work for partial match?
5. What is difference between repo and environment secrets?

If unsure, redo experiments.