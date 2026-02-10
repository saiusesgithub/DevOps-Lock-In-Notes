# Day 5 — Step 06: Locals — Reducing Repetition Without Hiding Logic

**Date:** February 10, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** DRY without magic

**Environment:** Variables + tfvars + locals

---

## 🎯 Objective of This Step

Understand **what `locals` are**, **why they exist**, and **how to use them safely**
without turning Terraform into unreadable logic soup.

By the end of this step, you should be able to:

* Explain the difference between variables and locals
* Use locals to remove repetition
* Predict how locals are evaluated
* Avoid hiding important logic inside locals

---

## 🧠 Core Mental Model

> **Variables = inputs**
> **Locals = derived values**

Locals are **Terraform’s scratchpad**.

They:

* Do not accept external input
* Do not create resources
* Do not store state
* Exist only during evaluation

---

## 🧱 What Locals Are

A `locals` block defines **named expressions**:

```hcl
locals {
  name_prefix = "${var.environment}-lock-in"
}
```

This is:

* Computed once
* Reused everywhere
* Read-only

---

## 🧠 What Locals Are NOT

* ❌ Not configuration inputs
* ❌ Not environment selectors
* ❌ Not stateful
* ❌ Not runtime variables

If a value must differ between dev/prod → use variables

---

## 🧪 Why Locals Exist

Without locals:

```hcl
bucket = "${var.environment}-lock-in-bucket"

tags = {
  env = var.environment
}
```

Repeated everywhere → error-prone.

With locals:

```hcl
locals {
  bucket_name = "${var.environment}-lock-in-bucket"
  common_tags = {
    env = var.environment
  }
}
```

Now:

* One source of truth
* Easier refactoring
* Fewer mistakes

---

## 🧠 Evaluation Order (Important)

Terraform evaluates in this order:

1. Variables (inputs)
2. Locals (derived values)
3. Resources (using variables + locals)

Locals cannot depend on resources.

---

## 🧱 Example: Safe Locals Usage

```hcl
locals {
  bucket_name = "${var.environment}-${var.app_name}-bucket"
  tags = {
    environment = var.environment
    app         = var.app_name
  }
}
```

Used in resource:

```hcl
resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name
  tags   = local.tags
}
```

Clear. Predictable. Safe.

---

## 🚫 Dangerous Locals Patterns (Avoid)

### ❌ Hiding Logic

```hcl
locals {
  bucket_name = var.environment == "prod" ? "prod-bucket" : "test-bucket"
}
```

Why bad:

* Logic hidden
* Hard to reason
* Scales poorly

---

### ❌ Encoding Environments

```hcl
locals {
  is_prod = var.environment == "prod"
}
```

Better:

* Explicit variables
* Explicit tfvars

---

## 🧠 Locals vs Variables (Clear Difference)

| Aspect             | Variables     | Locals      |
| ------------------ | ------------- | ----------- |
| Input?             | Yes           | No          |
| External override? | Yes           | No          |
| Purpose            | Configuration | Computation |
| State?             | No            | No          |

---

## 🔥 Best Practices

* Use locals for naming conventions
* Use locals for shared tags
* Keep locals simple and obvious
* Prefer clarity over cleverness

---

## ✅ End Condition for Step 06

This step is complete only if I can:

* Explain why locals exist
* Decide when to use variable vs local
* Predict evaluation order
* Refactor repetition without hiding intent

---

**Next:**
