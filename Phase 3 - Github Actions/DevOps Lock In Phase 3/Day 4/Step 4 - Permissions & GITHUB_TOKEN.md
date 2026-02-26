# DAY 4 — Permissions & GITHUB_TOKEN Security Engineering

#### Date: 26th February 2026

--------------------------------------------------
## Objective

Understand GITHUB_TOKEN.
Control workflow permissions.
Apply least privilege principle.
Prevent privilege escalation.

This is pipeline hardening.

--------------------------------------------------
## 1. What is GITHUB_TOKEN?

Every workflow run automatically gets a token:

GITHUB_TOKEN

It allows the workflow to:

- Read repository
- Create issues
- Push commits
- Create releases
- Modify PRs

It is automatically generated per workflow run.
It expires after run completes.

--------------------------------------------------
## 2. Default Behavior

By default:
GITHUB_TOKEN often has write permissions.

This is dangerous if not controlled.

If workflow is compromised,
attacker could push malicious code.

--------------------------------------------------
## 3. permissions Block

You can explicitly control permissions:
```yml
permissions:
  contents: read
  issues: write
  pull-requests: read
```
If not specified,
defaults may apply.

Best practice:
Always define permissions explicitly.

--------------------------------------------------
## 4. Permission Scope Types

Common scopes:

- contents
- issues
- pull-requests
- actions
- checks
- deployments
- packages
- id-token

Each can be:
- read
- write
- none

--------------------------------------------------
## 5. Least Privilege Principle

Grant only what is required.

Example:

If workflow only builds:
```yml
permissions:
  contents: read
```
If workflow creates release:
```yml
permissions:
  contents: write
```
Never give write unless necessary.

--------------------------------------------------
## 6. Job-Level Permissions

Permissions can be defined:

Workflow-level (top)
OR
Per job

Example:
```yml
jobs:
  build:
    permissions:
      contents: read

  release:
    permissions:
      contents: write
```
This isolates risk.

--------------------------------------------------
## 7. GITHUB_TOKEN vs Personal Access Token (PAT)

GITHUB_TOKEN:
- Auto-generated
- Scoped to repository
- Expires automatically
- Safer

PAT:
- Created manually
- Can have broader scope
- Riskier if leaked

Prefer GITHUB_TOKEN whenever possible.

--------------------------------------------------
## 8. id-token Permission (OIDC)
```yml
permissions:
  id-token: write
```
Used for:
- Secure cloud authentication
- OIDC federation (AWS, Azure, GCP)

Avoid static cloud credentials.
Use OIDC instead (future topic).

--------------------------------------------------
## 9. Removing All Permissions

You can disable everything:
```yml
permissions: {}
```
Now workflow has no repository access.

You must explicitly grant what is needed.

--------------------------------------------------
## 10. Security Risk Example

If workflow has:
```yml
permissions:
  contents: write
```
And someone inserts:
```
run: git push malicious code
```
Workflow can modify repository.

Without proper permissions,
this would fail.

--------------------------------------------------
## 11. Protecting From Pull Request Attacks

Forked PRs:
GITHUB_TOKEN has limited permissions.

But still:
Avoid granting write permissions unnecessarily.

Especially on:
pull_request_target workflows.

--------------------------------------------------
## 12. Professional Hardening Pattern

Default:
```yml
permissions:
  contents: read
```
Only grant write in release job.

Separate build from deployment job.

Combine with environment protection.

--------------------------------------------------
## 13. Mandatory Experiments

1. Print GITHUB_TOKEN presence (do NOT print value).
2. Set permissions: {}
3. Try to push commit from workflow (should fail).
4. Add contents: write
5. Try again.
6. Observe behavior difference.
7. Define job-level permissions.

--------------------------------------------------
## 14. Mental Model Upgrade

Workflow = Executable automation.

GITHUB_TOKEN = Its identity.

permissions = Its authorization level.

Identity ≠ Authorization.

You must define authorization explicitly.

--------------------------------------------------
## 15. Checkpoint Questions

1. What is GITHUB_TOKEN?
2. Why should permissions block always be defined?
3. Difference between read and write?
4. When should you use id-token?
5. Why is least privilege important?

If unsure, redo experiments.