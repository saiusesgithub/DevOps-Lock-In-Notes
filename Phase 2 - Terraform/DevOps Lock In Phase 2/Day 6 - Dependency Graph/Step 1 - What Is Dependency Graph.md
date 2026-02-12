# Day 6 — Step 01: What Is a Dependency Graph?

**Date:** February 12, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Terraform as a Graph Engine  
**Environment:** Conceptual (no CLI yet)

---

## 🎯 Objective of This Step

Before touching any resources, I must understand:

* What a dependency graph is
* Why Terraform builds one
* Why ordering in files does **NOT** matter
* Why Terraform forbids cycles

If I still think Terraform executes line-by-line,  
this step has failed.

---

## 🧠 Core Mental Model

Terraform does **NOT** execute instructions.

Terraform builds a:

> **Directed Acyclic Graph (DAG)**

Then it evaluates the graph.

---

## 🧱 What Is a Graph?

A graph consists of:

* **Nodes** → things (resources)
* **Edges** → relationships between them

Example:

If:

* Resource A depends on Resource B

Then:

* B must exist before A

Graph representation:

```
B → A
```

Arrow means:

> "A depends on B"

---

## 🧠 What “Directed” Means

The arrow has direction.

If:

```
B → A
```

That does **NOT** mean:

```
A → B
```

Dependency direction matters.

---

## 🧠 What “Acyclic” Means

A graph cannot contain cycles.

This is forbidden:

```
A → B
B → A
```

Why?

Because:

* A needs B
* B needs A
* Nothing can start

Terraform will refuse to run.

---

## 🧠 Why Terraform Uses a Graph

Because Terraform is declarative.

It does **NOT** execute:

```
Step 1
Step 2
Step 3
```

Instead it asks:

> “What depends on what?”

Then builds the graph and determines order.

---

## 🧠 File Order Does NOT Matter

This is critical.

These two are identical:

### Version 1

```
resource A
resource B referencing A
```

### Version 2

```
resource B referencing A
resource A
```

Terraform:

* Reads all files first
* Builds the graph
* Ignores file order completely

---

## 🧠 How Terraform Builds the Graph

Terraform scans:

* Resource references
* Data references
* Interpolations like:

  * `aws_vpc.main.id`
  * `aws_s3_bucket.bucket.arn`

Whenever one resource references another,  
Terraform creates an edge.

---

## 🧠 Why This Makes Terraform Predictable

Because:

* Order is derived from relationships
* Relationships are explicit in config
* Execution order is deterministic

No hidden sequencing.  
No timing hacks.  
No sleep commands.

---

## 🔥 Important Realization

Terraform is not:

* A script runner
* A procedural engine
* A sequence executor

Terraform is:

> A graph constructor + state reconciler

---

## 🧪 Thought Exercise (Before Moving On)

If I define:

* VPC
* Subnet referencing VPC
* EC2 referencing Subnet

What is the graph?

Correct order must be:

```
VPC → Subnet → EC2
```

Not because of file order.

Because of references.

---

## 🚫 What Terraform Will NEVER Do

Terraform will never:

* Guess dependencies
* Execute randomly
* Follow file order
* Allow circular graphs

---

## ✅ End Condition for Step 01

This step is complete only if I can explain:

* What a DAG is
* Why Terraform uses it
* Why file order doesn’t matter
* Why cycles are forbidden

---

Next:

👉 **Day 6 — Step 02: Implicit Dependencies (Hands-On)**
