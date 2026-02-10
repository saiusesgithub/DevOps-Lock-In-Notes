# Day 5 — Step 05: Variable Validation & Constraints

**Date:** February 10, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** Preventing bad inputs before damage happens

**Environment:** Variables-driven configuration

---

## 🎯 Objective of This Step

Understand **how Terraform protects infrastructure from bad inputs** using
**variable validation and constraints**.

By the end of this step, you should be able to:

* Explain why validation belongs in Terraform (not humans)
* Define safe boundaries for variables
* Predict failures *before* plan/apply
* Stop invalid infrastructure from ever being planned

---

## 🧠 Core Mental Model

Terraform variables are **inputs to a machine**.

Machines do not:

* “use common sense”
* “guess intent”
* “warn nicely”

So Terraform must be **defensive by design**.

> **Validation is guardrails, not convenience**

---

## 🚨 Why Validation Matters

Without validation:

* Wrong region → resources fail mid-apply
* Empty bucket name → confusing provider errors
* Typos → partial infrastructure created
* Humans forget rules → Terraform doesn’t

Terraform validation:

* Fails **early**
* Fails **locally**
* Fails **predictably**

---

## 🧱 Types of Variable Constraints

Terraform supports multiple layers of protection:

### 1️⃣ Type Constraints

```hcl
variable "bucket_name" {
  type = string
}
```

Prevents:

* numbers
* lists
* objects

---

### 2️⃣ Default Values (Optional)

```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

Used when:

* value is optional
* safe fallback exists

---

### 3️⃣ Validation Blocks (Critical)

```hcl
variable "bucket_name" {
  type = string

  validation {
    condition     = length(var.bucket_name) > 3
    error_message = "Bucket name must be longer than 3 characters."
  }
}
```

Terraform checks this:

* before plan
* before apply
* before touching cloud

---

## 🧠 What Validation Actually Does

Terraform evaluates:

* `condition` → must be true
* otherwise → stop execution

This happens during:

* `terraform plan`
* `terraform apply`

No cloud calls.
No partial state.
No rollback needed.

---

## 🧪 Real-World Examples

### Enforce Allowed Environments

```hcl
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

---

### Prevent Accidental Production Destruction

```hcl
variable "enable_destroy" {
  type    = bool
  default = false
}
```

Later used to gate destructive actions.

---

### Enforce AWS Naming Rules

```hcl
variable "bucket_name" {
  type = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.bucket_name))
    error_message = "Bucket name must be lowercase and valid for S3."
  }
}
```

---

## 🚫 What Validation Is NOT

* ❌ Not runtime protection
* ❌ Not drift prevention
* ❌ Not IAM security
* ❌ Not a replacement for reviews

Validation only protects **inputs**.

---

## 🧠 Why Validation Belongs in Terraform (Not Docs)

Docs:

* Are ignored
* Are outdated
* Rely on discipline

Terraform:

* Enforces rules
* Never forgets
* Never gets tired

If it’s important, enforce it in code.

---

## 🔥 Common Beginner Mistakes

* ❌ Validating too late (after apply)
* ❌ Trusting README instructions
* ❌ Over-validating everything
* ❌ Using validation instead of design fixes

---

## ✅ End Condition for Step 05

This step is complete only if I can:

* Explain why Terraform fails early with validation
* Write validation for real-world constraints
* Predict when validation runs
* Explain why validation prevents outages
