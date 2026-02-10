# Day 5 — Step 07: Outputs — Exposing Terraform’s Results

**Date:** February 10, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** Observability, not configuration

**Environment:** Variables + locals + outputs

---

## 🎯 Objective of This Step

Understand **what outputs are**, **why they exist**, and **what they are NOT**.

By the end of this step, you should be able to:

* Explain why outputs exist at all
* Distinguish outputs from variables and locals
* Predict when outputs are evaluated
* Avoid abusing outputs as “return values”

---

## 🧠 Core Mental Model

> **Outputs = information Terraform exposes AFTER apply**

They answer the question:

> “What useful facts did Terraform learn after creating infrastructure?”

Outputs are **read-only views into state**.

---

## 🧱 What Outputs Are

Outputs expose values **from Terraform state**:

```hcl
output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
```

This:

* Reads from state
* Does NOT affect infrastructure
* Exists only after apply

---

## 🧠 What Outputs Are NOT

* ❌ Not inputs
* ❌ Not variables
* ❌ Not configuration
* ❌ Not execution logic
* ❌ Not used by Terraform internally

Terraform itself does not care about outputs.
They are for humans and other systems.

---

## 🔍 When Outputs Are Evaluated

Outputs are evaluated:

* After `terraform apply`
* From the current state
* Never during plan as final values

That’s why you often see:

```
(known after apply)
```

---

## 🧱 Common Legitimate Uses of Outputs

### 1️⃣ Human Visibility

```hcl
output "bucket_arn" {
  value = aws_s3_bucket.example.arn
}
```

So you can:

* See it in terminal
* Copy-paste into dashboards/docs

---

### 2️⃣ Feeding Other Terraform Projects (Remote State)

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

Consumed by another stack using `terraform_remote_state`.

---

### 3️⃣ CI/CD & Automation

Outputs are commonly consumed by:

* GitHub Actions
* Scripts
* Deployment pipelines

---

## 🚫 Dangerous Misuses of Outputs

### ❌ Using outputs as inputs

```hcl
output "env" {
  value = var.environment
}
```

Useless:

* Terraform already knows inputs
* Adds noise

---

### ❌ Encoding logic in outputs

```hcl
output "is_prod" {
  value = var.environment == "prod"
}
```

Bad:

* Logic belongs in variables/locals
* Outputs should expose facts, not decisions

---

## 🧠 Outputs vs Locals vs Variables (Final Comparison)

| Concept   | Purpose             | Direction           |
| --------- | ------------------- | ------------------- |
| Variables | Configuration input | Outside → Terraform |
| Locals    | Derived values      | Inside Terraform    |
| Outputs   | Exposed results     | Terraform → Outside |

This triangle is core Terraform architecture.

---

## 🧪 Important Safety Note

Outputs:

* Do NOT create dependencies
* Do NOT affect plan/apply
* Do NOT change infrastructure

They are purely observational.

---

## 🔥 Best Practices

* Output identifiers (IDs, ARNs, URLs)
* Avoid outputting secrets (unless explicitly needed)
* Keep output names stable
* Treat outputs as a public interface

---

## ✅ End Condition for Step 07

This step is complete only if I can:

* Explain why outputs exist
* Explain why Terraform doesn’t need them
* Decide what should vs shouldn’t be an output
* Describe outputs as “state views” 