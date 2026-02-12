# Day 6 — Step 05: Breaking the Graph (Circular Dependencies)

**Date:** February 12, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Why Terraform forbids cycles  
**Environment:** AWS provider + existing resources

---

## 🎯 Objective of This Step

Deliberately break Terraform’s dependency graph.

By the end of this step, I must:

* Understand what a circular dependency is
* Trigger a cycle error intentionally
* Read Terraform’s cycle error carefully
* Fix the graph correctly
* Explain why Terraform refuses cyclic graphs

If I still think Terraform “could just figure it out,”  
this step has failed.

---

## 🧠 Core Mental Model

Terraform requires a:

> **Directed Acyclic Graph (DAG)**

Acyclic means:

* No loops
* No circular paths
* No “A depends on B and B depends on A”

Because execution must have a valid starting node.

---

## 🔥 What Is a Circular Dependency?

A cycle looks like:

```
A → B
B → A
```

Or even longer:

```
A → B → C → A
```

No valid starting point exists.

Terraform cannot determine execution order.

---

## 🧪 Hands-On: Create a Cycle Intentionally

### Step 05A — Force a Simple Cycle

Add two dummy resources:

```hcl
resource "null_resource" "a" {
  depends_on = [null_resource.b]
}

resource "null_resource" "b" {
  depends_on = [null_resource.a]
}
```

---

## 🔮 Predict Before Running Plan

Ask:

* What edge does A create?
* What edge does B create?
* Is there a starting node?
* Can Terraform topologically sort this graph?

Answer:

> No. It cannot.

---

## 🧪 Run

```bash
terraform plan
```

---

## 🧠 Expected Error

Terraform should output something like:

```
Error: Cycle: null_resource.a, null_resource.b
```

This is Terraform telling you:

> “Your graph is invalid.”

---

## 🧠 Why Terraform Refuses Cycles

Because Terraform:

* Builds graph
* Performs topological sort
* Schedules execution

Topological sort is only possible if the graph is acyclic.

A cycle means:

* No valid starting node
* No valid execution order
* No safe plan possible

So Terraform stops immediately.

---

## 🔍 Real-World Cycles (More Subtle)

Cycles can occur unintentionally:

Example:

* Security group referencing instance
* Instance referencing security group

Or:

* Output used incorrectly
* Locals referencing resources incorrectly

Terraform detects all cycles before apply.

---

## 🔥 Critical Realization

Terraform is not being stubborn.

It is enforcing mathematical correctness.

The DAG must satisfy:

> Every node must have a path that eventually reaches a root.

---

## 🛠 Fixing the Cycle

Remove one edge:

```hcl
resource "null_resource" "a" {}

resource "null_resource" "b" {
  depends_on = [null_resource.a]
}
```

Now graph:

```
a → b
```

Valid.

Terraform can proceed.

---

## 🧠 Deep Understanding

This is why Terraform:

* Does not allow circular locals
* Does not allow circular module references
* Does not allow circular resource references

Graph integrity is fundamental.

---

## 🧪 Thought Exercise

If Terraform allowed cycles,  
what could happen?

* Infinite waiting
* Random execution
* Partial infra creation
* Deadlocks

Terraform prevents all of that.

---

## 🚫 Important Lesson

If you ever see a cycle error:

Do **NOT**:

* Add random `depends_on`
* Try to reorder files
* Try to trick Terraform

Instead:

* Draw the graph
* Remove unnecessary dependency
* Simplify design

---

## ✅ End Condition for Step 05

This step is complete only if I can:

* Define a circular dependency
* Explain why DAG must be acyclic
* Trigger and fix a cycle error
* Draw the dependency graph manually
