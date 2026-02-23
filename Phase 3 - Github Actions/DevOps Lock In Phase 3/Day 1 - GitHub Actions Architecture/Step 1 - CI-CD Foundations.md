# DAY 1 — CI/CD Foundations

#### Date - 23/02/2026

## 1. What is CI (Continuous Integration)?

Continuous Integration is a development practice where developers merge code frequently into a shared repository, and every merge automatically triggers validation steps such as build, test, and lint.

Goal:
- Detect bugs early
- Keep main branch stable
- Prevent integration conflicts

Mental Model:
"Every change proves itself immediately."

Key Idea:
Merge → Automatically Build + Test → Get Immediate Feedback


--------------------------------------------------

## 2. What is CD?

CD has two meanings in industry:

### A. Continuous Delivery
Code is automatically built and tested and is always in a deployable state.
Deployment to production may still require manual approval.

Mental Model:
"Always ready to release."

### B. Continuous Deployment
Every change that passes automated checks is automatically deployed to production with no manual step.

Mental Model:
"If it passes, it ships."


--------------------------------------------------

## 3. Difference Between CI and CD

CI focuses on:
- Code integration
- Build verification
- Automated testing
- Keeping main branch healthy

CD focuses on:
- Deployment automation
- Release processes
- Environment management
- Production readiness

Simple View:
CI = Verify code correctness.
CD = Ship code safely.


--------------------------------------------------

## 4. Why Automation Matters

Automation provides:

1. Speed – No manual repetitive steps.
2. Consistency – Same process every time.
3. Reliability – Fewer human errors.
4. Confidence – Faster merges and releases.
5. Traceability – Logs show what happened and when.
6. Scalability – Works for large teams.

Without automation:
- Builds become inconsistent
- Bugs are detected late
- Deployment becomes risky


--------------------------------------------------

## 5. Where GitHub Actions Fits in DevOps Lifecycle

GitHub Actions is GitHub’s built-in automation engine.

It can:

- Run CI (build, test, lint)
- Run CD (deploy to staging/production)
- Enforce quality gates before merge
- Run security scans
- Execute scheduled automation jobs
- Respond to repository events

Position in DevOps Flow:

Developer Push → GitHub Event → GitHub Actions Workflow → Runner Executes → Logs + Status


--------------------------------------------------

## 6. Jenkins vs GitHub Actions (High-Level Comparison)

Jenkins:
- Self-hosted (you manage servers)
- Plugin-based architecture
- Very flexible but requires maintenance
- Common in enterprise setups

GitHub Actions:
- Built into GitHub
- YAML-based workflows stored in repo
- GitHub-hosted runners available instantly
- Low infrastructure maintenance
- Marketplace for reusable actions

Simple View:
Jenkins = Powerful but you manage infrastructure.
GitHub Actions = Integrated and convenient for GitHub repos.


--------------------------------------------------

## 7. What is Event-Driven Automation?

Event-driven automation means workflows run automatically when specific events occur.

Examples of events:
- push
- pull_request
- release
- workflow_dispatch (manual trigger)
- schedule (cron)

Execution Model:
Event Happens → Workflow Matches → Runner Starts → Jobs Execute → Result Reported

Core Idea:
No human clicking required after configuration.