# DevOps Lock-In (Phase 3: GitHub Actions) — Detailed Day-by-Day Context

### Coverage: Day 1 → Day 6
### Timeline: 23 Feb 2026 → 28 Feb 2026

> This is a **“what you did + what you proved + what you locked in”** recap.
> It’s written so you can re-open this any time and instantly remember the full journey.

---

# ✅ DAY 1 — Feb 23, 2026
## Theme: GitHub Actions Architecture + YAML Mastery (Foundation + mental model)

### What you focused on (high-level)
You started from **zero knowledge** and built the absolute core mental model of GitHub Actions:
- what CI/CD means,
- how GitHub Actions fits into it,
- how workflows are triggered,
- how YAML must be written,
- how a runner executes jobs and steps.

### What you did in detail

#### 1) CI/CD Foundations (theory block)
You wrote and understood:
- **CI (Continuous Integration)** as automation that runs on code changes to catch issues early.
- **CD (Continuous Delivery/Deployment)** as automation that moves changes closer to production (or deploys them).
- The difference between **CI vs CD** (integration/testing vs delivery/release/deploy).
- Why automation matters in DevOps lifecycle (speed, reliability, repeatability, fewer human errors).
- Where GitHub Actions sits (event → workflow → jobs → steps executed on runners).
- A high-level **Jenkins vs GitHub Actions** comparison.
- Event-driven automation concept (GitHub emits events; workflows react).

You made sure you could explain GitHub Actions **without even opening GitHub** (that’s huge).

#### 2) YAML Deep Dive (not just “indentation”)
You didn’t treat YAML as a “format” — you treated it as a language with rules.

You studied:
- syntax rules and indentation laws
- mapping vs sequence
- scalars (strings/booleans/numbers)
- quoting rules
- multiline blocks (`|` literal vs `>` folded)

Then you did failure-driven learning:
- created invalid indentation deliberately
- created wrong structure deliberately
- duplicate keys deliberately
- pushed to GitHub and watched the workflow error output

So you learned YAML by **breaking it** and seeing real failure messages.

#### 3) First workflow (but correctly)
You created a proper first workflow file:
- `.github/workflows/ci.yml`
- added `name`, `on: push`, `jobs`, `runs-on`, multiple `steps`
- pushed and inspected logs line-by-line

You understood the file is not “config” only — it’s a **runtime instruction**.

#### 4) Runner architecture understanding
You learned what `ubuntu-latest` means:
- runner images are managed and updated
- runner is ephemeral
- state does not persist between jobs
- the runner is basically a temporary machine created to run your job

#### 5) Step execution model experiments
You tested step-level state:
- created a file in step 1
- used it in step 2
- proved: **steps share state inside one job**

Then you tested job-level isolation:
- understood: **jobs do not share state by default**

#### 6) Internal execution flow model
You created the full mental pipeline:

Push → Event → Workflow Trigger → Runner Allocation → Job → Step → Logs → Result

This gave you the first “engine-level” understanding.

#### 7) Rebuild test
You deleted the workflow and rebuilt from memory.

**Outcome of Day 1**
You built:
- a clean mental model of GHA structure
- YAML fundamentals + failure patterns
- runner/job/step boundaries
- first workflow confidence

---

# ✅ DAY 2 — Feb 24, 2026
## Theme: Trigger Control + Event Data + Conditional Logic (Precision control)

### What you focused on (high-level)
You moved from “workflow runs” to:
- **controlling when it runs**
- understanding why it ran
- reading event payload and contexts

### What you did in detail

#### Step 1) Branch + Path Filtering (advanced control)
You learned:
- `branches`, `branches-ignore`
- wildcards (`release/*`)
- `paths`, `paths-ignore`
- AND-combination: branch condition AND path condition
- PR branch targeting logic (base branch in `pull_request`)
- evaluation order: branch filter → path filter → run

You tested:
- push to main vs dev
- changes inside `src/**` vs outside
- confirmed runs are blocked at trigger evaluation stage (before runner allocation)

#### Step 2) workflow_dispatch with inputs (manual pipeline control)
Even though this existed earlier, on Day 2 you treated it as:
- manual execution system
- with parameters and conditional logic

You learned:
- defining inputs
- accessing them via event payload / contexts
- conditional jobs/steps based on inputs
- combined push + manual trigger in same workflow

#### Step 3) schedule (cron) deep dive
You learned:
- cron syntax in detail
- UTC-only reality
- schedule runs only from default branch workflow file
- schedule delays and inactivity quirks
- `${{ github.event.schedule }}` usage

You understood scheduled automation as “maintenance pipelines”.

#### Step 4) Event Payload + Context Deep Dive
You learned:
- contexts (github/env/runner/steps/etc.)
- printing event JSON using `toJson(github.event)`
- difference between push payload and PR payload
- why workflow behavior changes per event

#### Step 5) Day 2 Consolidation Challenge
You built a single workflow with:
- push + branch/path filters
- pull_request
- workflow_dispatch with inputs
- schedule cron
- context printing
- conditional jobs based on event type and inputs

Then you tested each trigger and recorded what changed.

**Outcome of Day 2**
You gained:
- precise workflow triggering control
- event-driven debugging mindset
- ability to reason about runs without guessing

---

# ✅ DAY 3 — Feb 25, 2026
## Theme: Jobs, Dependencies & Execution Graph Engineering (DAG thinking)

### What you focused on (high-level)
You stopped thinking in “steps” and started thinking in **graphs**:
- jobs as nodes
- needs as edges
- parallel execution and controlled sequencing

### What you did in detail

#### Step 1) Job architecture foundation
You proved:
- each job runs on separate runner (separate machine)
- jobs run in parallel by default
- filesystem doesn’t share between jobs

Experiment:
- created multiple jobs with `sleep`
- confirmed runtime proves parallelism
- confirmed file created in job A not accessible in job B

#### Step 2) needs dependency graph engineering
You engineered DAGs:
- simple chains (`build → test → deploy`)
- multi-dependency joins (`needs: [build, lint]`)
- failure propagation (dependent jobs skipped)
- acyclic constraint (cycles rejected)

You measured runtime to confirm parallel branches + sequential joins.

#### Step 3) Failure control & resilience
You learned:
- step-level and job-level `continue-on-error`
- `success()`, `failure()`, `always()`
- matrix `fail-fast`
- resilient pipeline patterns (notify on failure, cleanup always)

You treated failure as a “signal” you can route.

#### Step 4) runs-on variations + cross-OS
You learned:
- ubuntu vs windows vs mac differences
- shell differences (bash vs PowerShell)
- case sensitivity differences
- overriding shell
- using matrix to test cross-OS

#### Step 5) Matrix strategy deep engineering
You learned:
- cartesian product expansion
- controlling job explosion
- include/exclude rules
- fail-fast behavior
- matrix variables and conditions

#### Step 6) Full Execution Graph Challenge
You built a real execution graph combining:
- parallel branches
- needs joins
- matrix tests
- failure handlers
- controlled deploy gating

Then did a rebuild-from-memory.

**Outcome of Day 3**
You gained:
- DAG mindset
- job isolation understanding
- controlled pipeline architecture skill
- resilient execution control

---

# ✅ DAY 4 — Feb 26, 2026
## Theme: Environment Variables, Secrets, Permissions & Security Engineering (hardening)

### What you focused on (high-level)
You treated workflows as **security-sensitive infrastructure**:
- what can leak
- what can be escalated
- how to gate production

### What you did in detail

#### Step 1) Environment variable scope engineering
You learned:
- workflow/job/step env scopes
- precedence rules (step > job > workflow)
- expression env vs shell env
- dynamic env via `$GITHUB_ENV`

You tested persistence across steps vs non-persistence of local shell vars.

#### Step 2) Secrets architecture + masking + leak prevention
You learned:
- repo vs org vs environment secrets
- `secrets` context usage
- masking is exact-match only
- fork PR secrets behavior (not exposed)
- safe patterns (inject via env, never echo)

You did deliberate experiments around masking edge cases.

#### Step 3) Environment protection rules + approvals
You created production-grade safety:
- staging vs production environments
- required reviewers approval gates
- environment-specific secrets
- branch restrictions combined with environment gating
- deployment audit trail and risk control

#### Step 4) permissions block + GITHUB_TOKEN hardening
You learned:
- GITHUB_TOKEN exists per run
- default permissions can be dangerous
- set least privilege with `permissions:` explicitly
- job-level permissions separation
- `id-token` for future OIDC patterns

You treated permissions as authorization boundaries.

#### Step 5) Contexts deep dive (expression engine)
You mastered:
- contexts: github/env/runner/matrix/steps/job/secrets/inputs
- expression evaluation timing vs runtime shell evaluation
- toJSON debugging patterns
- common mistakes (confusing $VAR with ${{ env.VAR }})

#### Step 6) Secure pipeline challenge
You designed a hardened pipeline:
- build → test → staging deploy → approval → production deploy
- explicit permissions
- environment secret isolation
- branch restrictions
- failure notify path
- simulated attack tests mindset

**Outcome of Day 4**
You gained:
- security-first workflow design
- secret handling discipline
- production deploy governance

---

# ✅ DAY 5 — Feb 27, 2026
## Theme: Reusability, Supply Chain Security, Caching & Artifacts (platform engineering)

### What you focused on (high-level)
You shifted from “one repo workflows” to:
- modular CI platform components
- external dependency security
- performance engineering
- cross-job file movement

### What you did in detail

#### Step 1) Reusable workflows
You learned:
- `workflow_call`
- calling reusable workflows
- passing inputs + secrets explicitly
- cross-repo usage
- pinning versions (avoid @main)

You treated reusable workflows as “pipeline functions”.

#### Step 2) Composite actions
You learned:
- step-level modularization
- `.github/actions/.../action.yml`
- inputs/outputs in composite actions
- limitations (no jobs/needs/matrix)
- internal CI building blocks

#### Step 3) Marketplace actions + version pinning + supply chain security
You learned:
- why @main/@latest is risky
- tag vs SHA pinning
- action types (JS/Docker/composite)
- why least privilege reduces damage if action compromised
- `checkout` advanced options (persist-credentials)

#### Step 4) Caching engineering
You learned:
- cache keys design
- `hashFiles` invalidation
- restore keys fallback
- cache poisoning risk
- matrix-safe cache strategy
- save/restore behavior

You focused on correctness + speed.

#### Step 5) Artifacts engineering
You learned:
- artifact upload/download for cross-job file transfer
- artifact retention governance
- artifacts vs cache difference
- matrix naming collisions
- storage discipline (don’t upload workspace)

#### Step 6) Modular pipeline engineering challenge
You combined:
- reusable workflow + composite action
- pinned marketplace actions
- caching + artifacts
- permissions hardening
- layered architecture mindset

**Outcome of Day 5**
You gained:
- modular CI design skills
- supply chain security awareness
- performance optimization + output transfer mastery

---

# ✅ DAY 6 — Feb 28, 2026
## Theme: Execution Governance, Observability, Runner Architecture (scale mindset)

### What you focused on (high-level)
You shifted from “making CI work” to:
- controlling CI behavior under load
- cancellation & concurrency
- deep debugging visibility
- runner infrastructure thinking

### What you did in detail

#### Step 1) Concurrency & execution control
You learned:
- concurrency groups as “locks”
- dynamic group naming per branch
- cancel-in-progress policies
- job-level concurrency for deployments
- cancellation effects on DAG and job status

You tested rapid push scenarios mentally/experimentally.

#### Step 2) Advanced run states & cancellation engineering (added to fix missing step)
You learned:
- job states: success/failure/cancelled/skipped
- cancelled() vs failure()
- why failure() doesn’t trigger on cancelled
- cleanup strategies for cancel vs failure
- dependent job behavior after cancellation
- concurrency cancellation producing cancelled state

#### Step 3) Debugging & observability engineering
You learned:
- enabling ACTIONS_STEP_DEBUG and ACTIONS_RUNNER_DEBUG
- log grouping with ::group::
- structured logs (::warning::, ::error::)
- toJSON dumps for context visibility
- set -x / set -e style debugging
- systematic isolation approach (minimize pipeline until failure reproduced)

#### Step 4) Self-hosted runner architecture
You learned:
- what self-hosted runner is
- why teams use it (private network, GPU, compliance)
- security risks (persistent state, infra pivot risk)
- labels and targeting
- scaling models (autoscaling runners, Kubernetes ARC)
- why untrusted PRs shouldn’t run on self-hosted runners

#### Step 5) Workflow performance & governance patterns
You learned:
- CI sprawl prevention
- trigger optimization (branch+path filters)
- tiered CI strategy (fast PR checks vs heavy main checks)
- matrix explosion governance
- artifact retention discipline
- permission governance baseline
- naming conventions + observability governance
- cost mindset (jobs = VMs = minutes)

**Outcome of Day 6**
You gained:
- execution control under rapid events
- cancellation-aware pipeline design
- strong debugging/observability discipline
- runner-level infrastructure awareness
- governance mindset for real-world CI at scale

---

# ✅ Overall Phase 3 Progress Summary (Day 1 → Day 6)

By Day 6 you can:

- Explain GHA architecture from first principles
- Write correct YAML and debug it by reading errors
- Control triggers precisely (branch/path/manual/schedule)
- Read event payload and use contexts properly
- Design workflows as DAGs with `needs`
- Engineer resilient failure/cancel behavior
- Secure workflows using env/secrets/permissions/environments
- Build modular CI with reusable workflows + composite actions
- Harden supply chain with SHA-pinned actions + least privilege
- Speed up CI using caching and move outputs using artifacts
- Control concurrency + governance to prevent CI chaos
- Debug using structured logs + debug flags
- Understand hosted vs self-hosted runner architecture

---