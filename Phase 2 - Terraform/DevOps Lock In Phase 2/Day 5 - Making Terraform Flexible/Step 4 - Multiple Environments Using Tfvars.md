# Day 5 — Step 04: Multiple Environments Using tfvars (dev/prod Mental Model)

**Date:** February 10, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** One codebase, multiple realities

**Environment:** Same Terraform config, different tfvars

---

## 🎯 Objective of This Step

Understand **how Terraform supports multiple environments (dev / prod)**
**without duplicating code** and **without changing logic**.

By the end of this step, you should be able to:

* Explain how dev/prod separation works in Terraform
* Predict how the same config creates different infrastructure
* Explain why tfvars are the *environment boundary*
* Avoid the biggest beginner mistake: copying folders

---

## 🧠 Core Mental Model

Terraform does **NOT** have environments.

Instead, it has:

> **Different inputs → different infrastructure**

Environment ≠ folder

Environment ≠ branch

Environment = **values**

---

## 🧱 The Correct Abstraction

* `.tf` files → **structure & logic**
* `.tfvars` files → **environment-specific values**
* State → **remembers what exists for that environment**

Same code.
Different tfvars.
Different state.
Different infra.

---

## 📂 Folder Structure (Mental, Not Mandatory)

Example (conceptual):

```text
terraform/
├── main.tf
├── variables.tf
├── dev.tfvars
├── prod.tfvars
```

**Important:**

* Terraform does not care about this structure
* Humans do

---

## ✍️ Define Environment-Specific Values

**dev.tfvars**

```hcl
bucket_name = "devops-lock-in-dev-bucket"
```

**prod.tfvars**

```hcl
bucket_name = "devops-lock-in-prod-bucket"
```

Same variable.
Different value.

---

## ▶️ How You Select the Environment

You explicitly choose the tfvars file:

```bash
terraform plan  -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

or

```bash
terraform plan  -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

No guessing.
No magic.
No implicit behavior.

---

## 🧠 Why This Is Powerful

* No code duplication
* No branching logic in `.tf`
* No if/else for environments
* Clean separation of concerns

Terraform stays boring.

---

## 🚫 What NOT to Do (Critical)

* ❌ Copy entire folders for dev/prod
* ❌ Hardcode environment values
* ❌ Use workspaces blindly without understanding state
* ❌ Modify `.tf` files per environment

These lead to drift, confusion, and outages.

---

## 🔐 State Isolation (Very Important)

Each environment must have its own state.

Why?

* State = Terraform’s memory
* Sharing state = shared reality
* dev touching prod = disaster

We’ll formalize this later with:

* separate folders
* or remote backends
* or workspaces (after understanding tradeoffs)

---

## 🧪 Thought Experiment

If you run:

```bash
terraform apply -var-file=dev.tfvars
```

Then later:

```bash
terraform apply -var-file=prod.tfvars
```

In the same directory with the same state:

👉 Terraform will try to change **dev into prod**

This is why state isolation matters.

---

## ✅ End Condition for Step 04

This step is complete only if I can:

* Explain how Terraform handles dev/prod without environments
* Explain why tfvars represent environment boundaries
* Predict what happens if state is shared
* Confidently choose values without touching `.tf`

---

**Next:**
👉 Step 05 — Variable Validation & Constraints
