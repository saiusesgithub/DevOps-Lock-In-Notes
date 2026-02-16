# DevOps Lock-In — Phase 3 (GitHub Actions)

**Duration:** 7 Days

**Date:** Feb 15 – Feb 21, 2026

**Primary Tool:** GitHub Actions

**Resource:** DevOps Directive — *GitHub Actions: Beginner to Pro*

[https://courses.devopsdirective.com/github-actions-beginner-to-pro](https://courses.devopsdirective.com/github-actions-beginner-to-pro)

[https://youtu.be/Xwpi0ITkL3U?si=PvLB7st8QwrAT8Er](https://youtu.be/Xwpi0ITkL3U?si=PvLB7st8QwrAT8Er) 

[https://github.com/sidpalas/devops-directive-github-actions-course](https://github.com/sidpalas/devops-directive-github-actions-course)

---

## 🎯 PHASE OBJECTIVE (LOCKED)

By the end of Day 7, GitHub Actions should feel:

* Predictable
* Structured
* Explainable as a system
* Debuggable without panic

> “I can design, read, reason about, and debug GitHub Actions workflows, understand execution flow, data passing, permissions, and structure CI/CD pipelines confidently.”

This phase is **not** about:

* Collecting badges
* Memorizing YAML blindly
* Copy-pasting marketplace workflows
* Becoming a DevOps architect overnight

This phase **is** about:

* Mental models of CI systems
* Understanding execution graphs
* Security awareness
* Designing predictable automation

---

## 🧠 PRIOR CONTEXT (ALREADY COMPLETED)

### Phase 1 — Docker

* Container lifecycle
* Compose networking
* Cloud VM deployments
* System reliability mindset

### Phase 2 — Terraform

* Declarative infrastructure
* State & lifecycle
* Dependency graph reasoning
* Predict-before-apply discipline

**Phase 3 builds on both.**

Now we automate everything.

---

## 🧭 LEARNING RULES (STRICT)

❌ No watching passively
❌ No copying full workflows from docs
❌ No skipping “boring” YAML sections
❌ No building giant pipelines yet

✅ Draw execution graphs
✅ Predict job order before running
✅ Intentionally break workflows
✅ Read logs fully when failure happens
✅ Explain before executing

By the end, CI should feel mechanical.

---

## 🔁 DAILY EXECUTION LOOP (EVERY DAY)

1. Watch 30–40 minutes max
2. Pause frequently
3. Take messy raw notes
4. Implement minimal example
5. Break something intentionally
6. Debug via logs
7. Write 5–10 line reflection

No binge-watching.

---

# 📅 7-DAY STRUCTURED PLAN (With Video Sections)

---

## 🔹 DAY 1 — Foundations & CI Mental Model

**Video Sections:**

* 0:00:00 – 0:04:38 — *Course Overview, Audience, Structure*
* 0:04:38 – 0:10:36 — *Evolution of Software Delivery & CI/CD*
* 0:10:36 – 0:12:38 — *Core CI Workflow Categories (Validate, Build, Deploy, Automate)*
* 0:12:38 – 0:18:58 — *Why GitHub Actions: Adoption & Tool Comparison*
* 0:18:58 – 0:24:00 — *Development Environment Setup (Repo, Devbox, Docker, VS Code)*

**Focus:**

* Why CI/CD exists
* Core workflow types
* Anatomy of a GitHub Actions workflow

**Hands-on:**

* Create repo
* Create `basic.yml` with `on: push`
* Echo workflow triggered

**Daily Test:**

> Explain workflow execution flow (event → runner → job → step).

---

## 🔹 DAY 2 — Core Concepts & Data Flow

**Video Sections:**

* 0:24:00 – 0:43:29 — *Core Concepts*
  (Events, Workflows, Jobs, Steps, Runners, Triggers, Variables, Contexts, Secrets)
* 0:43:29 – 0:44:20 — *GitHub Actions Contexts Overview*

**Focus:**

* Workflow triggers (push, PR, manual)
* Data movement (env vars, outputs)
* Secrets & masking

**Hands-on:**

* Add scheduled workflow
* Add manual `workflow_dispatch`
* Pass output between jobs

**Daily Test:**

> How does a secret differ from a variable in scope and masking?

---

## 🔹 DAY 3 — Runners, Performance & Security

**Video Sections:**

* 0:44:20 – 1:07:11 — *Runners, Artifacts, Caching, Permissions, OIDC*

**Focus:**

* Hosted vs self-hosted runners
* Artifact storage
* Caching dependencies
* Workflow permissions & OIDC auth intro

**Hands-on:**

* Implement artifact upload/download
* Add dependency caching to Node project
* Add permissions to limit scope

**Daily Test:**

> When does caching improve speed, and what can break it?

---

## 🔹 DAY 4 — Advanced Execution & Cloud Authentication

**Video Sections:**

* 0:59:48 – 1:07:11 — *Cloud Authentication with OIDC*
* 1:04:20 – 1:07:11 — *Matrix Strategies, Conditionals & Concurrency*

**Focus:**

* Secure cloud login (AWS OIDC)
* Matrix workflows
* Conditional and parallel execution

**Hands-on:**

* Implement OIDC connection (mock AWS example)
* Add matrix builds
* Use `if:` condition to skip job

**Daily Test:**

> Why is OIDC preferred over static credentials in CI?

---

## 🔹 DAY 5 — Reusability & Extensibility

**Video Sections:**

* 1:07:11 – 1:31:32 — *Marketplace Actions, Composite Actions, Reusable Workflows, Custom JS/Container Actions*

**Focus:**

* Marketplace usage and pinning
* Composite actions
* Reusable workflows
* Concept of authoring custom actions

**Hands-on:**

* Replace repeated steps with composite action
* Use pinned version of a marketplace action (e.g., `actions/checkout@v4`)

**Daily Test:**

> When should you move logic into a reusable workflow vs inline YAML?

---

## 🔹 DAY 6 — CI/CD Design Patterns & Debugging

**Video Sections:**

* 1:31:32 – 2:06:24 — *Common Patterns, Debugging, Monorepo vs Multirepo, Security Hardening*

**Focus:**

* Common CI/CD patterns
* Multi-job pipelines
* Local debugging tools
* Logs & failure analysis

**Hands-on:**

* Add lint + test + build stages
* Introduce controlled error
* Analyze logs to find cause

**Daily Test:**

> What’s your debugging checklist for failed workflows?

---

## 🔹 DAY 7 — Capstone: Build, Release, and Deployment

**Video Sections:**

* 2:06:24 – 3:42:34 — *Capstone Architecture, Testing Pipelines, Docker Build, Versioning, Release Automation, Telemetry*

**Focus:**

* End-to-end CI/CD pipeline design
* Docker build and push
* Tag-triggered release
* GitOps mindset
* Release automation

**Hands-on:**

* Build and push Docker image
* Add environment-aware tags
* Automate version bump and release creation

**Daily Test:**

> Can you describe a complete CI/CD flow (test → build → push → deploy) in your own words?

---

# 🏁 SUCCESS CRITERIA

Phase 3 is complete only if:

* YAML feels readable and explainable
* You can write workflows from scratch
* You can design and debug pipelines calmly
* You can explain CI/CD reasoning confidently

---

## 🔜 WHAT COMES NEXT

After Phase 3 (Course Completion):

* 7 Day GitHub Actions Lock-In (Hands-on Phase)
* Integrate Docker + Terraform + Actions
* Build full automated deployment pipeline

This phase is **conceptual mastery first** — lock-in comes next.

---

**End of Phase 3 Plan**
