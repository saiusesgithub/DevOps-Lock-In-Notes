# Day 6 — Step 04: Explicit Dependencies (`depends_on`)

**Date:** February 12, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** When to force order — and when NOT to  
**Environment:** AWS provider + existing graph resources

---

## 🎯 Objective of This Step

Understand:

* What `depends_on` actually does
* When implicit dependency is NOT enough
* Why overusing `depends_on` is dangerous
* How explicit dependencies modify the graph

By the end of this step, I must:

* Know when `depends_on` is required
* Avoid using it as a crutch
* Predict how it changes execution order

---

## 🧠 Core Mental Model

`depends_on` manually adds a graph edge.

If you write:

```hcl
depends_on = [aws_vpc.demo_vpc]
```

You are telling Terraform:

> “Even if no reference exists, treat this resource as dependent on the VPC.”

It modifies the DAG explicitly.

---

## 🔎 Why `depends_on` Exists

Terraform automatically creates dependencies when:

* A resource references another resource attribute

Example (implicit):

```hcl
vpc_id = aws_vpc.demo_vpc.id
```

Terraform sees this reference → adds graph edge.

But sometimes:

* No attribute reference exists
* Yet ordering still matters

That’s when `depends_on` is needed.

---

## 🧱 Legitimate Use Case

Example:

You have:

* S3 bucket
* Null resource that triggers after bucket creation
* No direct attribute reference

```hcl
resource "null_resource" "after_bucket" {
  depends_on = [aws_s3_bucket.demo_bucket]
}
```

Without `depends_on`,
Terraform sees no relationship.

---

## ⚠️ Dangerous Misuse Pattern

❌ Adding `depends_on` when implicit dependency already exists

Example:

```hcl
resource "aws_subnet" "demo_subnet" {
  vpc_id = aws_vpc.demo_vpc.id

  depends_on = [aws_vpc.demo_vpc]
}
```

This is redundant.

Terraform already knows.

Overusing `depends_on`:

* Makes graph noisy
* Hides real dependencies
* Encourages imperative thinking

---

## 🧪 Hands-On Exercise

### Step 04A — Create Artificial Explicit Dependency

Take two independent buckets:

```hcl
resource "aws_s3_bucket" "parallel_one" {
  bucket = "lockin-parallel-one-123"
}

resource "aws_s3_bucket" "parallel_two" {
  bucket = "lockin-parallel-two-456"

  depends_on = [aws_s3_bucket.parallel_one]
}
```

---

## 🔮 Predict Before Plan

Ask:

* Were these resources independent before?
* What new graph edge did I create?
* What execution order will Terraform now enforce?
* Will parallelism still happen?

Graph becomes:

```
parallel_one → parallel_two
```

Parallelism removed.

---

## 🧪 Run

```bash
terraform plan
terraform apply
```

Observe:

* Creation order now forced
* Terraform respects explicit dependency

---

## 🧠 What Just Happened Internally

You manually modified the DAG.

Terraform:

* Added directed edge
* Recalculated execution order
* Reduced concurrency

You moved from:

* Implicit graph

To:

* Partially manual graph

---

## 🔥 Critical Realization

`depends_on` does NOT:

* Change infrastructure
* Modify state
* Affect resources directly

It only:

> Changes graph structure.

---

## 🧠 When You MUST Use `depends_on`

Use it only when:

* No attribute reference exists
* You truly need ordering
* Terraform cannot infer relationship

Common examples:

* Provisioners
* Null resources
* External scripts
* Data sources relying on side effects

---

## 🚫 When You Should NOT Use It

Do NOT use `depends_on`:

* To “be safe”
* To control execution order randomly
* To simulate imperative steps
* When implicit reference exists

---

## 🧪 Thought Experiment

If I remove:

```hcl
depends_on = [...]
```

And nothing breaks,
it was unnecessary.

---

## 🔒 Important Philosophy Rule

If you frequently need `depends_on`,
your design might be wrong.

Terraform prefers:

> Reference-based relationships, not manual ordering.

---

## ✅ End Condition for Step 04

This step is complete only if I can:

* Explain how `depends_on` modifies the DAG
* Identify legitimate use cases
* Remove unnecessary explicit dependencies
* Predict execution order after adding/removing it
