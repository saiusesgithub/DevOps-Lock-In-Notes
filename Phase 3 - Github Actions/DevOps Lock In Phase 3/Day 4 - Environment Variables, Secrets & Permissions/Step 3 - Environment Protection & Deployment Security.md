# DAY 4 — Environment Protection & Deployment Security

#### Date: 26th February 2026

--------------------------------------------------
## Objective

Understand GitHub Environments.
Add protection rules.
Require approvals before execution.
Separate staging and production securely.

This is production-level control.

--------------------------------------------------
## 1. What is a GitHub Environment?

An environment represents a deployment target.

Examples:
- dev
- staging
- production

It allows:
- Secret isolation
- Required approvals
- Deployment tracking

--------------------------------------------------
## 2. Defining Environment in Workflow

Example:
```yml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "Deploying"
```
When job reaches this stage:
GitHub checks environment rules.

--------------------------------------------------
## 3. Creating Environment

GitHub → Settings → Environments → New Environment

Create:
- staging
- production

--------------------------------------------------
## 4. Required Reviewers (Approval Gate)

Inside environment settings:
Add required reviewers.

Now behavior changes:

When job reaches environment stage:

Execution pauses.

Approval required before proceeding.

This creates manual control.


--------------------------------------------------
## 5. Environment-Specific Secrets

Each environment can have its own secrets.

Example:
- production secret
- staging secret

Used automatically when job references environment.

Accessed via:
```yml
${{ secrets.SECRET_NAME }}
```
But resolved based on environment context.

--------------------------------------------------
## 6. Deployment Flow With Approval

Flow:

Job starts
→ Reaches environment
→ Pauses
→ Reviewer approves
→ Job continues
→ Deployment executes

No approval = no execution.

--------------------------------------------------
## 7. Restricting Deploy to Main Branch

Combine environment with condition:
```yml
deploy:
  if: ${{ github.ref == 'refs/heads/main' }}
  environment: production
```
Now:
Deploy only runs on main branch
AND requires approval.

--------------------------------------------------
## 8. Deployment History Tracking

GitHub tracks:

- Deployment status
- Environment
- Commit SHA
- Time
- Actor

Useful for:
Audit trail.


--------------------------------------------------
## 9. Environment vs Job-Level Secrets

Repository secret:
Available everywhere.

Environment secret:
Available only when job references environment.

Use environment secrets for:
Sensitive production credentials.


--------------------------------------------------
## 10. Example Production Deployment Pattern
```yml
jobs:
  build:
  test:
  deploy-staging:
    needs: test
    environment: staging
  deploy-production:
    needs: deploy-staging
    if: ${{ github.ref == 'refs/heads/main' }}
    environment: production
```
This ensures:

build → test → staging → approval → production


--------------------------------------------------
## 11. Security Insight

Without environment protection:
Anyone who pushes to main can deploy.

With protection:
Even if workflow runs,
deployment pauses for approval.

This prevents accidental releases.


--------------------------------------------------
## 12. Threat Modeling

Ask yourself:

- What if someone modifies workflow to skip approval?
- What if a malicious contributor changes deployment script?
- What if secrets are misconfigured?

Environment rules protect deployment stage,
not earlier CI stages.

--------------------------------------------------
## 13. Mandatory Experiments

1. Create staging and production environments.
2. Add required reviewer to production.
3. Create workflow referencing environment.
4. Push to main.
5. Observe paused state.
6. Approve manually.
7. Confirm execution resumes.
8. Remove approval and observe behavior.

--------------------------------------------------
## 14. Mental Model Upgrade

Environment = Deployment Gate

Approval = Human Control Layer

Secrets = Scoped Credentials

Branch Condition = Code Control Layer

You now combine:
Automation + Governance.


--------------------------------------------------
## 15. Checkpoint Questions

1. What happens when job reaches protected environment?
2. Where are environment secrets stored?
3. Can deployment run without approval?
4. How do you restrict deployment to main?
5. Why is environment protection critical in production?

If unsure, redo experiments.