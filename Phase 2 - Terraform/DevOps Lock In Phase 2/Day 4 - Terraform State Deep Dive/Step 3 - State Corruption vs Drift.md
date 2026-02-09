# Day 4 — Step 03: State Corruption vs Drift
**Date:** February 8, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** When Terraform’s memory itself becomes wrong  

---

## 🎯 Goal of This Step

Clearly separate two *very different* failure modes:

- **Drift** → reality changed, state still valid
- **Corruption** → state itself is broken or untrustworthy

By the end of this step, you must be able to answer:

> “Is this a drift problem or a state corruption problem?”

That decision determines **whether Terraform is safe to run at all**.

---

## 🧠 High-Level Distinction (Lock This In)

### Drift
- State exists
- State structure is valid
- Terraform still knows what it manages
- Reality ≠ state

### State Corruption
- State is missing, damaged, or lying
- Terraform’s ownership model is broken
- Terraform may not know what it manages
- Actions become **high-risk**

Drift is common.  
Corruption is dangerous.

---

## 🔄 Drift (Recap, in One Line)

> Drift = Terraform remembers *something*, but reality has changed.

Terraform can:
- Detect drift
- Plan against it
- Fix it safely (with review)

Terraform is still **in control**.

---

## 💣 What State Corruption Actually Means

State corruption occurs when **Terraform’s memory is unreliable**.

This includes:
- State file deleted
- State file partially overwritten
- Manual edits to state without understanding
- Wrong backend pointing to wrong state
- Two environments sharing one state file
- Interrupted writes during apply
- Copy-pasted state between projects

At this point, Terraform is **guessing**.

---

## 🚨 Why State Corruption Is Worse Than Drift

With drift:
- Terraform still knows what it owns

With corruption:
- Terraform may think:
  - Resources don’t exist when they do
  - Resources exist when they don’t
  - It owns things it never created
  - It owns nothing at all

This leads to:
- Accidental recreation
- Accidental deletion
- Duplicate infrastructure
- Irreversible data loss

Most Terraform horror stories start here.

---

## 🧱 Examples to Internalize

### Example 1 — Drift
- S3 bucket versioning enabled manually
- State still tracks bucket
- Plan shows a change
- Safe to apply after review

### Example 2 — Corruption
- `terraform.tfstate` deleted
- Terraform thinks **nothing exists**
- `terraform apply` wants to recreate everything
- `terraform destroy` does nothing (or worse, wrong things)

Same infrastructure.  
Completely different risk profile.

---

## 🔍 How Terraform Behaves Under Each Condition

| Situation | Terraform Knows Ownership? | Safe to Plan? | Safe to Apply? |
|--------|-----------------------------|---------------|----------------|
| No drift | ✅ Yes | ✅ Yes | ✅ Yes |
| Drift | ✅ Yes | ✅ Yes | ⚠️ With review |
| Corruption | ❌ No | ❌ Risky | ❌ Dangerous |

---

## 🧠 Core Mental Model (Very Important)

Drift = reality problem

Corruption = memory problem


Terraform can handle **reality problems**.  
Terraform cannot safely handle **memory problems** without recovery steps.

---

## 🚫 What We Still Are NOT Doing

- No recovery yet
- No state repair
- No imports
- No backends
- No remote state

We are still building judgment, not fixing.

---

## ✅ End Condition for Step 03

This step is complete only if you can confidently say:

- “This is drift — safe to plan”
- “This is corruption — stop immediately”
- “Refresh helps here”
- “Refresh is dangerous here”

Only after this clarity do we move to **recovery strategies**.
