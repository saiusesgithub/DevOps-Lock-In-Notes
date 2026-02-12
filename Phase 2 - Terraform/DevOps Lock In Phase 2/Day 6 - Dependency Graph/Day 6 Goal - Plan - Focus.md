# 📅 Day 6 — Dependency Graph & Implicit Ordering (Execution Plan)
**Date:** February 12, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Why Terraform doesn’t need step ordering  
**Environment:** AWS provider + multiple related resources

---

## 🎯 Primary Goal for Today

Remove all remaining “magic” around Terraform execution order.

By the end of Day 6, I must:

- Understand how Terraform builds a dependency graph
- Predict resource creation order without guessing
- Explain why file order does not matter
- Understand implicit vs explicit dependencies
- Safely use (and avoid abusing) `depends_on`
- Explain why Terraform can run resources in parallel

If Terraform still feels like “it just figures it out somehow,”  
then Day 6 has failed.

---

## 🧠 Core Question of the Day

> If Terraform doesn’t execute top-to-bottom, how does it know what to create first?

Today is about answering that precisely.

---

## 🧱 What We Will Cover (Step Structure)

### Step 01 — Mental Model: What Is a Dependency Graph?
- Nodes = resources
- Edges = relationships
- Directed acyclic graph (DAG)
- Why cycles are forbidden

---

### Step 02 — Implicit Dependencies (The Default)
- Referencing one resource inside another
- How Terraform detects dependencies automatically
- Why interpolation creates graph edges

Hands-on:
- Create 2–3 dependent AWS resources
- Predict order before running `plan`

---

### Step 03 — Parallelism & Non-Dependent Resources
- Why Terraform can create resources in parallel
- How Terraform determines safe parallel execution
- What `-parallelism` flag does

Hands-on:
- Create two independent resources
- Observe plan/apply behavior

---

### Step 04 — Explicit Dependencies (`depends_on`)
- When implicit dependency is insufficient
- When explicit dependency is necessary
- Why `depends_on` is powerful but dangerous
- How overusing it harms graph clarity

Hands-on:
- Create artificial dependency
- Observe execution order change

---

### Step 05 — Breaking the Graph (Intentional Failure)
- Create circular dependency
- Observe Terraform error
- Understand why DAG must remain acyclic

Hands-on:
- Force cycle
- Read error carefully
- Fix properly

---

### Step 06 — Graph Visualization (Optional but Powerful)
- Use `terraform graph`
- Understand what Terraform internally constructs
- See graph instead of imagining it

---

## 🔥 Prediction Discipline Rule (Enforced Today)

Before every:
- `terraform plan`
- `terraform apply`

I must state:
- What will be created first?
- What will run in parallel?
- Why?

If I cannot predict → I do not run.

---

## 🚫 Hard Boundaries

- No blindly adding `depends_on`
- No copying complex examples
- No “it works so it’s fine”
- No skipping error analysis

Today is about **reasoning, not success**.

---

## ✅ End Condition for Day 6

Day 6 is complete only if I can:

- Explain why file order doesn’t matter
- Predict execution order from configuration
- Identify implicit vs explicit dependency
- Create and fix a circular dependency
- Describe how Terraform safely parallelizes work

When that happens:

> Terraform stops feeling magical.  
> It becomes a graph engine.