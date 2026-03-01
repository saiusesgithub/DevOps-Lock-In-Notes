# DAY 5 — External Actions, Version Pinning & Supply Chain Security

#### Date: 27th February 2026

--------------------------------------------------
## Objective

Understand marketplace actions.
Pin versions securely.
Avoid supply chain attacks.
Design trusted pipelines.

--------------------------------------------------
## 1. What is a Marketplace Action?

GitHub Marketplace provides pre-built actions.

Examples:
```
actions/checkout
actions/setup-node
actions/cache
```
They are reusable automation modules
published by maintainers.

--------------------------------------------------
## 2. Using an External Action

Example:
```yml
steps:
  - name: Checkout code
    uses: actions/checkout@v4
```
This pulls action code from:

github.com/actions/checkout

--------------------------------------------------
## 3. The Risk of @main or @latest

If you use:
```yml
uses: owner/action@main
```
You are trusting future commits blindly.

If maintainer pushes malicious update,
your workflow runs it automatically.

This is a supply chain risk.

--------------------------------------------------
## 4. Version Pinning (Best Practice)

Three levels:
```
1. Branch (unsafe)
   @main

2. Tag (safer)
   @v4

3. Commit SHA (safest)
   @3df4e2abc123...
```
Best practice:
Pin to full commit SHA in production.

--------------------------------------------------
## 5. Example Secure Pinning

Instead of:
```
uses: actions/checkout@v4
```
Use:
```
uses: actions/checkout@3df4e2abc1234567890
```
You can find SHA from:
GitHub action repository → releases.

--------------------------------------------------
## 6. Why Commit SHA is Safest

Tag can be moved.
Branch changes.
Commit SHA cannot change.

It ensures exact code execution.

--------------------------------------------------
## 7. Verifying Action Source

Before using external action:

Check:
- Number of stars
- Maintainer reputation
- Last update date
- Open issues
- Source code

Never blindly trust unknown actions.

--------------------------------------------------
## 8. Understanding Action Types

External actions can be:

1. JavaScript actions
2. Docker container actions
3. Composite actions

Docker actions run inside container.
JS actions run on runner.
Composite actions run steps directly.

Each has different trust implications.

--------------------------------------------------
## 9. Token Exposure Risk

If malicious action runs:

It can:
- Read repository contents
- Access secrets
- Push code (if permissions allow)

Therefore:
Always limit permissions block.

Least privilege protects from compromised actions.

--------------------------------------------------
## 10. actions/checkout Deep Dive

Common usage:
```yml
- uses: actions/checkout@v4
```
By default:
Fetches repository code.

Advanced options:
```yml
with:
  fetch-depth: 0
  persist-credentials: false

persist-credentials: false
```
Prevents token from being used for push.

--------------------------------------------------
## 11. actions/cache Overview

Used for dependency caching.

Risk:
Cache poisoning if improperly scoped.

Key must be specific.

Example:
```yml
key: ${{ runner.os }}-build-${{ hashFiles('**/package-lock.json') }}
```
--------------------------------------------------
## 12. Safe Usage Pattern
```yml
permissions:
  contents: read

steps:
  - uses: actions/checkout@<commit-sha>
  - uses: actions/setup-node@<commit-sha>
```
Minimal permissions + pinned versions.

--------------------------------------------------
## 13. Detecting Action Drift

If using tags:
Monitor releases periodically.

If using SHA:
Upgrade intentionally, not automatically.

Security = intentional updates.

--------------------------------------------------
## 14. Practical Experiments

1. Use checkout via tag.
2. Replace with commit SHA.
3. Compare logs.
4. Try using unknown marketplace action.
5. Inspect its repository.
6. Check action.yml file.
7. Review code before trusting.

--------------------------------------------------
## 15. Mental Model Upgrade

Workflow = Code.

External actions = Third-party dependencies.

Pinning = Dependency locking.

permissions block = Sandbox.

CI/CD has supply chain risk.
You must engineer defensively.

--------------------------------------------------
## 16. Checkpoint Questions

1. Why is @main dangerous?
2. What is safest pinning method?
3. Can tag be modified?
4. How do permissions reduce risk?
5. What should you verify before using action?

If unsure, redo experiments.