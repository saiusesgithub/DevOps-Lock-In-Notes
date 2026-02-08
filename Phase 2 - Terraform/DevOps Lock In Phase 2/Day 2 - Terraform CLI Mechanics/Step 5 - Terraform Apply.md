# Step-05 - Terraform Apply

**Date:** February 8, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Step Theme:** Understanding `terraform apply` as execution, not reasoning

---

## 🎯 Step Objective

Understand **what `terraform apply` actually does** and how it relates to `terraform plan`.

This step exists to:

* Remove fear around `terraform apply`
* Prove that apply does not invent changes
* Reinforce that execution always follows reasoning

No infrastructure will be created in this step.

---

## 1️⃣ What `terraform apply` Is (Conceptually)

`terraform apply` is Terraform’s **execution phase**.

Its responsibility is simple:

> Execute the changes described in the plan.

It does **not**:

* Decide what to change
* Invent new actions
* Guess user intent

All reasoning happens before execution.

---

## 2️⃣ What Happens Internally When You Run `terraform apply`

When you run `terraform apply`, Terraform:

1. Generates a plan internally
2. Displays the plan to the user
3. Asks for confirmation
4. Executes the plan exactly as shown

If the plan contains **no changes**, nothing is executed.

---

## 3️⃣ What `terraform apply` Reads

`terraform apply` reads:

* Terraform configuration files (`.tf`)
* State (if it exists)
* Provider schemas (if any)

In the current setup:

* Configuration exists
* State does not exist
* Providers do not exist

This is a valid scenario.

---

## 4️⃣ What Happens in Our Case

With a configuration that declares no resources:

* Desired state: no resources
* Current state: no managed resources
* Plan: no changes

During apply:

* No infrastructure is created
* No state file is written
* No cloud APIs are called

Apply exits successfully having done nothing.

---

## 5️⃣ What `terraform apply` Does NOT Do

`terraform apply` does NOT:

* Create state when there are no resources
* Create `.terraform/` without providers or modules
* Touch cloud APIs unnecessarily
* Modify configuration files

Execution without changes is a valid and expected outcome.

---

## 6️⃣ Why `terraform apply` Is Not Dangerous

`terraform apply` is only dangerous when:

* The plan is skipped
* State is misunderstood
* Changes are not reviewed

When the plan is understood:

* Apply is predictable
* Apply is boring
* Apply is safe

The danger comes from human behavior, not Terraform.

---

## 7️⃣ Correct Mental Model to Lock In

> `terraform apply` executes a plan.
> It does not think.

If apply surprises you, the mistake happened before execution.

---
## 🔎 Day 2 – Step 05: terraform apply — Questions & Refined Answers

### 1) Why does apply do nothing when the plan has no changes?
Because the desired state already matches the current state. There is nothing to execute.

---

### 2) Why can apply run without an existing state file?
Terraform can assume an empty current state initially. During apply, it then creates a state file to record ownership and reconciliation.

---

### 3) Why does apply not invent resources?
Terraform only executes actions explicitly described in the plan, which itself is derived strictly from configuration.

---

### 4) Why is apply safe when the plan is reviewed?
Because apply executes exactly what the plan describes and nothing more. No hidden actions exist outside the plan.

---

### 5) Why was a state file created even though there are no resources?
Because Terraform records that the configuration has been applied and that the correct managed state is “zero resources.”

---

## 🔎 Why Terraform Creates a State File Even with an Empty Configuration

Terraform creates a state file during `terraform apply` even when no resources exist because **state is not only a list of resources** — it is a record of ownership and reconciliation.

Key reasons:

- Terraform must record that the configuration has been **applied intentionally**
- It establishes a **baseline** that “zero resources” is the correct managed state
- It stores a **lineage ID** to uniquely identify this state over time
- It records the **Terraform version** used for reconciliation
- It allows Terraform to distinguish between:
  - “This configuration was never applied”
  - “This configuration was applied and is intentionally empty”

Without writing state:
- Terraform could not reliably track future changes
- Terraform would not know whether to recreate resources later
- Ownership and lifecycle guarantees would break

**Mental model to lock in:**

> `terraform apply` always records state to remember what it manages —  
> even when what it manages is *nothing*.
