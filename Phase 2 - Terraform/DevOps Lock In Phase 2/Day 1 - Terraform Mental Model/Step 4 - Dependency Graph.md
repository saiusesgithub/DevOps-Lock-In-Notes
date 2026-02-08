# Day 1 — Step 04: Dependency Graph & Why Terraform Feels Predictable

**Date:** February 8, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Step Theme:** How Terraform derives order, safety, and predictability without scripts

---

This step explains **how Terraform decides order without being told**, and why its behavior
becomes predictable once the dependency graph is understood.

If this concept is weak, Terraform feels “smart”.
If this concept is strong, Terraform feels **boring**.

---

## 1. The Problem Terraform Had to Solve

Infrastructure resources often depend on each other:

- A server depends on a network
- A database depends on storage
- A load balancer depends on targets

In a script:
- You manually enforce order
- One mistake breaks everything

Terraform solves this **without step ordering**.

---

## 2. Terraform Does Not Use File Order

Terraform does **not** read configuration top-to-bottom.

- File order does not matter
- Resource order does not matter
- Folder structure does not define execution order

Terraform first **loads everything**, then reasons.

---

## 3. What a Dependency Graph Is (Conceptual)

A dependency graph is a model where:
- Resources are **nodes**
- Relationships are **edges**

An edge means:
> “This resource depends on that resource.”

Terraform builds this graph automatically before planning.

---

## 4. How Terraform Detects Dependencies

Terraform detects dependencies in two ways:

### 4.1 Implicit Dependencies
- Created through references
- Example conceptually:
  - Resource A uses output or attribute from Resource B
- Terraform infers that B must exist before A

### 4.2 Explicit Dependencies
- Declared directly when needed
- Used only when Terraform cannot infer relationships automatically

Most real-world dependencies are implicit.

---

## 5. Execution Comes From the Graph, Not You

Once the graph exists:
- Terraform determines safe order
- Independent resources run in parallel
- Dependent resources wait automatically

You do not tell Terraform:
- “Create this first”
- “Then do that”

Terraform derives this from the graph.

---

## 6. Why Terraform Is Predictable

Terraform is predictable because:
- Desired state is explicit
- State tracks ownership
- Dependency graph enforces order
- Plan shows exact changes

Nothing happens implicitly.
Everything is derived.

---

## 7. Why Terraform Feels “Smart” at First

Terraform feels smart because:
- It hides the graph
- It hides dependency resolution
- It hides parallel execution decisions

Once you understand the graph:
- Behavior is obvious
- Plans make sense
- Execution order is expected

“Smart” is just **well-defined logic**.

---

## 8. Common Beginner Mistake

Trying to force Terraform into script-like thinking:

- Adding unnecessary explicit dependencies
- Splitting resources to control order
- Writing config to “guide” execution order

This usually makes Terraform **worse**, not safer.

Terraform should be allowed to reason.

---

## 9. Dependency Graph and Destroy

Destroy also uses the graph:
- Reverse dependencies are honored
- Resources are destroyed in safe order
- Terraform avoids breaking dependencies during deletion

This is why destroy works cleanly when state is correct.

---

## 10. Final Mental Model to Lock In

Terraform behavior is predictable because:

> Execution order is derived from a dependency graph built from declared relationships, not from human-defined steps.

Once this is internalized, Terraform stops being surprising.

---

## 🔎 Step 4 — Dependency Graph & Predictability: Questions & Refined Answers

### 1) Why doesn’t file order matter in Terraform?
File order doesn’t matter because Terraform does not execute configuration line-by-line.  
It loads all configuration files together, builds a dependency graph, and executes resources based on relationships, not file position.

---

### 2) How does Terraform know what to create first?
Terraform builds a dependency graph where resources are nodes and dependencies are directed edges.  
Resources with no dependencies are created first, and dependent resources are created only after their dependencies exist.

---

### 3) Why is explicit ordering rarely needed?
Explicit ordering is rarely needed because Terraform automatically infers dependencies when one resource references attributes or outputs of another.  
Most relationships are implicit and discovered during graph construction.

---

### 4) Why can Terraform run resources in parallel?
Terraform can run resources in parallel because the dependency graph clearly identifies which resources are independent.  
Resources with no dependency relationship can be safely created or modified at the same time.

---

### 5) Why does Terraform behavior feel predictable?
Terraform behavior is predictable because:
- Desired state is explicitly declared
- State tracks ownership and identity
- The dependency graph enforces correct ordering
- The plan shows all changes before execution

Given the same configuration and state, Terraform will always produce the same plan.
