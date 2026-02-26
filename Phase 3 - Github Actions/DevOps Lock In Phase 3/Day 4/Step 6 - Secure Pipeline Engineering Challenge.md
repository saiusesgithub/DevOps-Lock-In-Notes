# DAY 4 — Secure Production-Grade Pipeline Challenge

#### Date: 26th February 2026

--------------------------------------------------
## Objective

Combine:
- Environment variables
- GITHUB_ENV dynamic variables
- Secrets
- Environment-level secrets
- Protected environments
- Required approvals
- permissions block
- Context-based conditions
- Least privilege model

Design a hardened deployment workflow.

--------------------------------------------------
## 1. Target Architecture

Flow:

build → test → deploy-staging → approval → deploy-production

Security layers:
- Explicit permissions
- Environment isolation
- Branch restriction
- Secrets scoped per environment
- Conditional deploy logic

--------------------------------------------------
## 2. Step 1 — Global Hardening

At top of workflow:
```yml
permissions:
  contents: read

env:
  APP_NAME: gha-secure-demo
  DEPLOY_ENV: staging
```
This enforces least privilege baseline.

--------------------------------------------------
## 3. Step 2 — Build Job
```yml
build:
  runs-on: ubuntu-latest
  permissions:
    contents: read
  steps:
    - name: Print metadata
      run: |
        echo "Repo: ${{ github.repository }}"
        echo "Branch: ${{ github.ref }}"
        echo "Actor: ${{ github.actor }}"

    - name: Set dynamic version
      run: echo "APP_VERSION=1.0.${{ github.run_number }}" >> $GITHUB_ENV

    - name: Show dynamic variable
      run: echo "Version is $APP_VERSION"
```
--------------------------------------------------
## 4. Step 3 — Test Job
```yml
test:
  needs: build
  runs-on: ubuntu-latest
  steps:
    - run: echo "Running tests"
    - run: sleep 2
```
--------------------------------------------------
## 5. Step 4 — Deploy to Staging
```yml
deploy-staging:
  needs: test
  runs-on: ubuntu-latest
  environment: staging
  permissions:
    contents: read
  env:
    API_KEY: ${{ secrets.STAGING_API_KEY }}
  steps:
    - run: echo "Deploying to staging"
    - run: echo "Using secret safely (not printed)"
```
--------------------------------------------------
## 6. Step 5 — Deploy to Production (Hardened)
```yml
deploy-production:
  needs: deploy-staging
  if: ${{ github.ref == 'refs/heads/main' }}
  runs-on: ubuntu-latest
  environment: production
  permissions:
    contents: read
    deployments: write
  env:
    API_KEY: ${{ secrets.PRODUCTION_API_KEY }}
  steps:
    - run: echo "Deploying to production"
    - run: echo "Version: $APP_VERSION"
```
Production environment must have:
- Required reviewer
- Separate production secret

--------------------------------------------------
## 7. Step 6 — Failure Notification Job
```yml
notify:
  if: failure()
  runs-on: ubuntu-latest
  permissions:
    contents: read
  steps:
    - run: echo "Pipeline failed"
```
--------------------------------------------------
## 8. Security Controls Checklist

You must verify:

- ✓ permissions explicitly defined
- ✓ No secret printed
- ✓ Environment-specific secrets used
- ✓ Production requires approval
- ✓ Deployment restricted to main
- ✓ Dynamic version created via GITHUB_ENV
- ✓ Failure handler exists

--------------------------------------------------
## 9. Simulated Attack Tests

Test these:

1. Push from non-main branch.
   → Production must NOT deploy.

2. Remove staging secret.
   → Staging should fail.

3. Remove approval from production.
   → Deployment should pause.

4. Try to print secret.
   → Masked.

5. Remove permissions block.
   → Observe default behavior.

--------------------------------------------------
## 10. Visual Architecture
```
Global permissions (least privilege)
        ↓
build (metadata + dynamic version)
        ↓
test
        ↓
deploy-staging (env isolation)
        ↓
deploy-production (approval gate)
        ↓
notify (on failure only)
```
--------------------------------------------------
## 11. Threat Modeling Exercise

Ask yourself:

- What if malicious contributor edits workflow?
- What if someone tries to bypass branch condition?
- What if secrets are leaked?
- What if permissions are too broad?

Think in attack scenarios.

--------------------------------------------------
## 12. Rebuild Challenge

Delete workflow.

Recreate from memory:

- permissions block
- env definitions
- dynamic variable using GITHUB_ENV
- staging environment job
- production environment job with branch restriction
- failure notification job

No copy.
No reference.

--------------------------------------------------
## 13. Day 4 Mastery Questions

1. What is difference between repo and environment secrets?
2. When are expressions evaluated?
3. Why define permissions explicitly?
4. What prevents accidental production deployment?
5. How does GITHUB_ENV work?
6. What protects secrets in forked PRs?
7. What happens if approval not given?

If unsure,
redo rebuild challenge.

--------------------------------------------------
## End of Day 4 Outcome

You now understand:

- Variable scope engineering
- Secure secret handling
- Deployment gating
- Least privilege enforcement
- Context-driven logic
- Production pipeline governance

This is real DevOps security engineering.