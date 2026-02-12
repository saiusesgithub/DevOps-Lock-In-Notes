# Day 6 — Reflection: Dependency Graph & Execution Model Ownership
**Date:** February 12, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Terraform as a Graph Engine

---

## 🎯 What Day 6 Was Actually About

Day 6 was not about writing more resources.

It was about permanently removing this incorrect belief:

> “Terraform executes top to bottom.”

Today was about understanding:

Terraform = Graph Builder + Scheduler

Not a script runner.

---

# 🧱 Step-by-Step: What I Did Today

---

## Step 01 — Understanding the Dependency Graph

What I did:
- Learned what a Directed Acyclic Graph (DAG) is
- Understood nodes (resources) and edges (relationships)
- Internalized that cycles are forbidden

What changed mentally:
- Stopped thinking in execution order
- Started thinking in relationships

Key realization:
File order does NOT matter. Relationships matter.

---

## Step 02 — Implicit Dependencies (Hands-On)

What I did:
- Created VPC
- Created Subnet referencing VPC
- Created Security Group referencing VPC
- Ran `terraform plan`
- Predicted creation order before running

What I observed:
- Terraform automatically created graph edges
- VPC created first
- Subnet and SG created after
- No `depends_on` required

Mistake I avoided:
- Adding unnecessary `depends_on`

Big lesson:
References create edges automatically.

---

## Step 03 — Parallelism & Independent Resources

What I did:
- Created two independent S3 buckets
- Predicted they could run in parallel
- Observed apply behavior
- Learned about `-parallelism`

What I understood:
Terraform schedules nodes whose dependencies are satisfied.

Parallelism is not random.
It is graph-driven.

Key realization:
Parallelism is safe because graph guarantees correctness.

---

## Step 04 — Explicit Dependencies (`depends_on`)

What I did:
- Forced artificial dependency between independent resources
- Observed graph change
- Saw parallelism disappear

What I learned:
`depends_on` adds manual graph edges.

Mistake I consciously avoided:
- Using `depends_on` “just to be safe”

Big realization:
Overusing `depends_on` makes Terraform more imperative.

---

## Step 05 — Breaking the Graph (Circular Dependency)

What I did:
- Intentionally created a cycle
- Ran `terraform plan`
- Observed cycle error
- Fixed it properly

What I understood:
Terraform must topologically sort the DAG.

Cycles make that impossible.

Terraform is enforcing math, not being stubborn.

---

## Step 06 — Visualizing the Graph (`terraform graph`)

What I did:
- Generated graph output
- Interpreted DOT format
- Observed parent-child relationships
- Confirmed implicit & explicit edges

What changed:
I stopped imagining the graph.
I saw it.

Major realization:
Everything Terraform does revolves around the DAG.

---

# 🧠 What I Now Understand Clearly

I can now confidently explain:

- Why file order does not matter
- How Terraform builds dependency edges
- How implicit dependencies are detected
- When explicit dependencies are needed
- Why cycles are forbidden
- Why parallelism is safe
- How destroy is just a reversed graph

Terraform feels:

Less magical  
More structural  
More mathematical  

---

# 🔥 Biggest Mental Shift

Before:
I thought Terraform “figures out order.”

Now:
I know Terraform builds a graph and schedules nodes.

That is a massive shift.

---

# 🧱 Rebuild-From-Memory Status

If I were given:

- VPC
- Subnet
- SG
- Buckets

I can:

- Draw the graph
- Predict execution order
- Identify parallelizable resources
- Detect potential cycles
- Explain execution behavior confidently

---

# 🏁 Final Verdict for Day 6

Day 6 is successfully completed.

Terraform is no longer:

A black box.

It is:

A deterministic graph engine.

---

Next logical step:

👉 **Day 7 — Full Rebuild-From-Memory Final Test**

