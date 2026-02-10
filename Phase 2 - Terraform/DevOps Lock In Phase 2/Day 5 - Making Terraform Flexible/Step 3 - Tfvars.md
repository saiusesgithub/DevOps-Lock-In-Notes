# Day 5 — Step 03: tfvars & Variable Resolution Order

**Date:** February 10, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** Supplying inputs safely and predictably

**Environment:** Terraform project with declared variables (no defaults)

---

## 🎯 Objective of This Step

Understand **how Terraform receives variable values**, **where they come from**, and **which one wins** when multiple sources exist.

By the end of this step, you should be able to answer:

* How Terraform resolves variable values
* Why `.tfvars` files exist
* Why resolution order matters for safety
* Why Terraform does NOT guess values

---

## 🧠 Mental Model: Variable Resolution

Declaring a variable = **asking a question**

Providing a value = **answering that question**

Terraform does **not** assume answers.

It resolves values using a **strict, deterministic order**.

This makes Terraform predictable.

---

## 📦 Ways to Provide Variable Values

Terraform supports **multiple input channels**, intentionally ordered.

Common ones (we’ll focus on these):

1. Command-line flags
2. `.tfvars` files
3. Environment variables
4. Interactive prompt

Terraform checks them **in order**, not randomly.

---

## 🥇 Variable Resolution Order (Most → Least Priority)

Terraform resolves variables in this order:

1. `-var` command-line flags
2. `-var-file` explicitly passed
3. `terraform.tfvars`
4. `*.auto.tfvars`
5. Environment variables (`TF_VAR_*`)
6. Interactive prompt
7. Default value (if defined)

If none provide a value → **error**

---

## 🧱 Why This Order Exists

* CLI flags = **most intentional**
* tfvars files = **environment-specific**
* env vars = **external automation**
* prompt = **last-resort human input**
* defaults = **safe fallback only**

Terraform rewards **explicitness**.

---

## ✍️ Hands-On: Create a tfvars File

Create a file named exactly:

```text
terraform.tfvars
```

Add:

```hcl
bucket_name = "devops-lock-in-demo-bucket"
```

**Important:**

* Filename matters
* Terraform auto-loads this file
* No command-line flags needed

---

## 🔄 What Changes Conceptually

**Before:**

* Terraform knew variable exists
* Value missing → plan failed

**Now:**

* Terraform finds value in `terraform.tfvars`
* Input contract satisfied
* Plan can proceed

---

## ▶️ What You Run

```bash
terraform plan
```

---

## 👀 What You Should Observe

* No variable error
* Terraform proceeds to planning
* It uses the value from `terraform.tfvars`
* Behavior is now deterministic

---

## 🧠 Why tfvars Are Safer Than Hardcoding

* Config remains reusable
* Values change without touching structure
* State reflects real inputs
* Environment separation becomes possible

Same code. Different tfvars. Different infra.

---

## 🚫 Common Mistakes (Very Important)

* Committing secrets in tfvars
* Mixing structure and values in `.tf`
* Relying on interactive prompt in automation
* Forgetting resolution order

Terraform does exactly what you tell it — nothing more.

---

## 🧪 Thought Experiment (Lock This In)

If you define:

* Default value in variable
* Value in `terraform.tfvars`
* Value via `-var`

Which one wins?

👉 `-var` (highest priority)

---

## ✅ End Condition for Step 03

This step is complete only if I can:

* Explain the full variable resolution order
* Predict which value Terraform will use
* Explain why Terraform fails when no value exists
* Use tfvars without guessing behavior

---

**Next:**
👉 Step 04 — Multiple Environments Using tfvars (dev/prod mental model)
