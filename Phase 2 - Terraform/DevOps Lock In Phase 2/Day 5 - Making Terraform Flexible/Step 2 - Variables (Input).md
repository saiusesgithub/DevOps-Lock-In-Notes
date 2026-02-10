# Day 5 — Step 02: Variables — Declaring Inputs Properly

**Date:** February 10, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** Turning hardcoded values into explicit inputs

**Environment:** Existing Terraform project (AWS provider configured)

---

## 🎯 Objective of This Step

Learn **what variables really are in Terraform**, how they are declared, and why they exist.

By the end of this step, you should be able to explain:

* What a Terraform variable represents (conceptually)
* Why variables are not “just parameters”
* What happens when variables are missing
* Why declaring variables changes how Terraform plans behave

No tfvars yet.
No defaults abuse.
Just **clean input declaration**.

---

## 🧠 What a Variable Is (Mental Model)

A Terraform variable is:

> **A formal declaration of something that is allowed to change.**

It tells Terraform:

* “This value is external to the structure”
* “This value may vary between runs or environments”
* “This value is not hardcoded intent”

Variables make **change explicit**, not hidden.

---

## 🧱 What Variables Are NOT

Variables are **not**:

* Environment files
* Secrets storage
* Dynamic logic
* A way to avoid thinking

They are **contracts** between:

* The Terraform configuration (structure)
* The operator/runtime (values)

---

## 🔍 Variable Declaration Anatomy

A variable has three core parts conceptually:

1. **Name** — how Terraform refers to it
2. **Type** — what kind of value is allowed
3. **Description / intent** — why it exists

Optional:

* Default value (only when safe)

Declaring a variable does **not** assign a value.
It only declares **expectation**.

---

## ✍️ What We Declare First (Hands-On)

We start by identifying a **hardcoded value**.

From earlier steps:

* S3 bucket name is hardcoded

That is behavior, not structure → perfect variable candidate.

---

## 🧪 Hands-On: Declare a Variable

Create a new file (or use existing structure):

```hcl
variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to create"
}
```

**Important:**

* No default yet
* Terraform now expects a value at runtime
* This is intentional friction

---

## 🔄 Use the Variable in a Resource

Replace the hardcoded bucket name:

```hcl
resource "aws_s3_bucket" "demo_bucket" {
  bucket = var.bucket_name
}
```

Now the configuration:

* Describes structure (S3 bucket exists)
* Delegates behavior (name) to input

---

## 🔮 Prediction (Must Lock This In)

Before running anything, predict:

* Terraform now knows a variable exists
* Terraform does NOT know its value yet
* `terraform plan` will FAIL
* Failure message will complain about missing input

This failure is correct behavior.

---

## ▶️ What You Run

Run:

```bash
terraform plan
```

Do **NOT** fix the error yet.

---

## 👀 What You Should Observe

Terraform will error with something like:

> “No value for required variable”

* It will list the variable name
* It will not attempt to touch AWS

Terraform is enforcing the input contract.

---

## 🧠 Key Insight (Lock This In)

Variables make missing intent visible early.

Hardcoded values hide missing decisions.
Variables force decisions to be explicit.

---

## 🚫 Common Mistakes to Avoid (Important)

* Adding defaults “just to make it work”
* Using variables everywhere blindly
* Treating variables as optional noise

**Rule:**

* If a value must change between environments → variable
* If it must never change → hardcode

---

## ✅ End Condition for Step 02

This step is complete only if I can:

* Explain why Terraform failed when variable had no value
* Explain why that failure is a good thing
* Identify which values deserve variables
* Use `var.<name>` confidently in resources

---

**Next:**
👉 Step 03 — tfvars & Variable Resolution Order
