# Day 6 — Step 03: Parallelism & Independent Resources

**Date:** February 12, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Why Terraform can run things in parallel  
**Environment:** AWS provider + dependent & independent resources

---

## 🎯 Objective of This Step

Understand **why Terraform can safely create resources in parallel**
and how it decides when that is allowed.

By the end of this step, I must:

* Identify independent resources
* Predict which ones run in parallel
* Explain how the dependency graph enables parallelism
* Understand what the `-parallelism` flag controls

---

## 🧠 Core Mental Model

Terraform parallelizes when:

> There is no dependency edge between two nodes.

If:

```
A → B
```

Then:

* A must finish before B

But if:

```
A     C
 \   /
 independent
```

Then:

* A and C can run at the same time

---

## 🔎 What Makes Resources Independent?

Two resources are independent when:

* Neither references the other
* They do not share dependency edges
* They do not implicitly depend on each other

Example:

```hcl
resource "aws_s3_bucket" "bucket_one" {
  bucket = "lockin-bucket-one"
}

resource "aws_s3_bucket" "bucket_two" {
  bucket = "lockin-bucket-two"
}
```

No references between them.

Graph:

```
bucket_one      bucket_two
```

No edges.

Terraform may create both simultaneously.

---

## 🧱 Hands-On Exercise

### Step 03A — Add Two Independent Resources

Add:

```hcl
resource "aws_s3_bucket" "parallel_one" {
  bucket = "lockin-parallel-one-123"
}

resource "aws_s3_bucket" "parallel_two" {
  bucket = "lockin-parallel-two-456"
}
```

---

## 🔮 Predict Before Running Plan

Ask yourself:

* Does either bucket reference the other?
* Does either depend on VPC/subnet?
* Will Terraform create them in parallel?
* In what order will they appear in plan?

---

## 🧪 Run

```bash
terraform plan
terraform apply
```

Observe:

* Terraform may interleave creation logs
* Order in output is **NOT** execution order
* Apply may show overlapping operations

---

## 🧠 Why Terraform Can Safely Parallelize

Because:

* Graph guarantees no dependency violations
* Terraform schedules nodes whose parents are complete
* Independent nodes execute concurrently

It is safe because:

> The graph defines legal execution boundaries.

---

## ⚙️ The `-parallelism` Flag

Terraform has a default parallelism limit (usually 10).

You can override it:

```bash
terraform apply -parallelism=1
```

This forces sequential execution.

Why useful?

* Debugging
* Rate-limit sensitive APIs
* Testing graph behavior

---

## 🧠 Important Clarification

Parallel execution does **NOT** mean:

* Random execution
* Uncontrolled behavior
* Race conditions

It means:

> Deterministic graph + concurrent scheduling

---

## 🔥 Key Realization

Terraform is not:

* Executing top-to-bottom
* Creating resources arbitrarily

Terraform is:

> Scheduling graph nodes when dependencies are satisfied.

Parallelism is a result of graph structure, not a feature added later.

---

## 🧪 Thought Test

If:

* VPC exists
* Subnet depends on VPC
* Two buckets are independent

Graph:

```
         subnet
           ↑
          vpc

bucket1      bucket2
```

Execution:

* VPC first
* Subnet after VPC
* Buckets can run anytime (parallel to others)

---

## 🚫 What You Should NOT Do

Do not add fake dependencies to "control order".

If no real dependency exists,  
parallel execution is correct behavior.

---

## ✅ End Condition for Step 03

This step is complete only if I can:

* Identify independent resources by reading config
* Predict which resources run in parallel
* Explain how graph enables parallel scheduling
* Use `-parallelism` intentionally
