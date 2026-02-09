# Day 4 — Step 05: Drift + State Loss (Hands-On Failure)

**Date:** February 8, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** Breaking reality and breaking memory (on purpose)

**Environment:** Existing AWS S3 resource + local state

---

## 🎯 Objective of This Step

Experience **real Terraform failure modes** with your own hands:

1. Safe failure → **Drift** (reality changes, memory intact)
2. Dangerous failure → **State loss** (memory gone, reality intact)

By the end of this step, Terraform should feel:

* Powerful
* Honest
* Dangerous if misused

No simulations. This is real behavior.

---

## 🔥 Part A — Introduce Drift Manually (Safe Failure)

### What You Will Do

* Keep Terraform configuration unchanged
* Modify the S3 bucket **directly in AWS Console**
* Let Terraform discover the change

Examples of safe drift actions (pick ONE):

* Enable bucket versioning
* Add a tag manually
* Change a bucket setting that Terraform did not define

Do **not** delete the bucket.

---

### Prediction (Must Answer Before Doing)

Before touching AWS, you should be able to say:

* Terraform state still exists
* Terraform still knows it owns the bucket
* Reality will no longer match state
* `terraform plan` will detect drift
* Terraform will propose a corrective action

Nothing should be destroyed automatically.

---

### What You Run (After Manual Change)

* Run `terraform plan`

### What You Should Observe

* Terraform refreshes state
* Provider detects changed attributes
* Plan shows a **difference**, not a recreation

This proves:

> Drift is detectable and recoverable when ownership is intact.

---

## 💣 Part B — Delete State File (Controlled Corruption)

### What You Will Do

1. Make a **copy** of `terraform.tfstate` (backup)
2. Delete the original `terraform.tfstate`
3. Do **not** change configuration

Reality still exists. Terraform’s memory does not.

---

### Prediction (Must Lock This In)

After deleting state:

* Terraform believes it owns nothing
* Terraform has no record of the S3 bucket
* Terraform will treat config as brand new

Expected plan behavior:

* Proposes to **create** the bucket again
* No awareness of existing real resource

This is **state amnesia**.

---

### What You Run

* Run `terraform plan`

### What You Should Observe

* Terraform proposes creating the S3 bucket
* No mention of deletion or modification
* No understanding of reality

This is the **most dangerous Terraform state** to be in.

---

## 🧠 Critical Insight From Step 05

Two identical infrastructures.
Two completely different outcomes.

Difference:

* In Part A → Terraform had memory
* In Part B → Terraform had none

This proves:

> Terraform safety depends entirely on state correctness.

---

## 🚫 What You MUST NOT Do

* Do NOT run `terraform apply` after deleting state
* Do NOT recreate resources
* Do NOT panic-fix

Stop and reason.

---

-------------------
-------------------

# Day 4 — Step 05 (Part A): Introducing Drift via Manual Changes

**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Safe drift when state ownership is intact  

---

## 🎯 Objective

Understand how Terraform behaves when:
- Infrastructure is modified manually
- State still exists and ownership is intact
- Desired configuration does not include the manual change

This step demonstrates **safe drift**.

---

## 🧠 What I Did

- Created an S3 bucket using Terraform
- Manually added a tag to the bucket using AWS Console
- Did NOT modify Terraform configuration
- Ran `terraform plan`
- Observed detected drift
- Ran `terraform apply`

---

## 🔍 What Terraform Detected

Terraform refreshed state and compared:

- **Desired state (config):** no tags defined
- **Real-world state (AWS):** tag exists
- **Terraform state:** mismatch detected

Terraform proposed:
- An **in-place update**
- Removal of the manually added tag

This confirms:
> Terraform detects drift only for attributes it manages.

---

## ⚙️ What Happened on Apply

- Terraform called AWS APIs
- Removed the manually added tag from the S3 bucket
- Updated the state file to reflect:
  - No tags (matching configuration)

So yes:

> Terraform removed the tag from AWS **because the desired state did not include it**.

---

## 🧠 Key Mental Model

Terraform does NOT ask:

“Is this change reasonable?”

Terraform asks:

“Does reality match configuration?”


If not → Terraform enforces configuration.

---

## ✅ Why This Is Safe Drift

- State existed
- Terraform knew it owned the bucket
- Terraform proposed a **predictable change**
- No recreation or deletion occurred

This is **controlled reconciliation**, not danger.

---

## ✅ End Result

- AWS bucket tags match Terraform configuration
- Terraform state and reality are aligned again
- Drift resolved safely


## ❓ Now the critical question: What if you wanted to KEEP the new tag?

This is very important, so read slowly.

### ❌ Wrong mental model

“I added a tag in AWS, Terraform should remember it”

Terraform does not learn intent from manual changes.

Manual changes are treated as mistakes, not decisions.

### ✅ Correct way to keep the tag

If you want the tag to persist, you must:

Declare it in Terraform configuration

That means:

Add the tag to the aws_s3_bucket resource in .tf

Then run terraform plan → terraform apply

Only then does Terraform consider the tag:

Part of desired state

Something to preserve

Something to re-create if deleted later


---

## 🔒 Why Terraform behaves this way (by design)

If Terraform:

Automatically adopted manual changes

Mutated desired state silently

Then:

Config would stop being source of truth

Infra would become unpredictable

Reproducibility would die

Terraform must treat config as authoritative.


#### If you want Terraform to keep something, it must exist in configuration — nowhere else.



----------
---------

# Day 4 — Step 05 (Part B): Deleting State — Terraform Loses Its Memory

**Theme:** State amnesia and why Terraform becomes dangerous
**Environment:** Existing AWS S3 bucket, local state backend

---

## 🎯 Objective

Experience **state loss** hands-on and observe how Terraform behaves when its memory is gone but reality still exists.

By the end of this step, you must *feel* why deleting state is one of the most dangerous actions in Terraform.

---

## 🧠 Preconditions (Must Be True)

* S3 bucket exists in AWS
* Terraform configuration still declares the bucket
* `terraform plan` currently shows **No changes**
* State file exists locally

If any of these are false → stop.

---

## 🛡️ Safety First (Non‑Negotiable)

1. **Create a backup** of `terraform.tfstate`

   * Copy it to `terraform.tfstate.bak`
2. Do **not** modify any `.tf` files
3. Do **not** run `apply` after state deletion

We are breaking memory, not reality.

---

## 💣 Action: Delete the State File

Delete **only** the state file:

* `terraform.tfstate`

Do NOT delete:

* `.terraform/`
* `.terraform.lock.hcl`
* `.tf` files

At this moment:

* AWS still has the bucket
* Terraform has **no memory** of it

---

## 🔮 Prediction (Say This Before Running Anything)

After deleting state:

* Terraform believes it manages **nothing**
* Terraform treats configuration as **brand new**
* Reality is ignored because ownership is unknown

Expected behavior:

* `terraform plan` proposes **creating** the S3 bucket
* No indication that the bucket already exists

This is state amnesia.

---

## ▶️ What You Run

* Run `terraform plan`

Do **not** apply.

---

## 👀 What You Should Observe

* Terraform plans to create `aws_s3_bucket.demo_bucket`
* Plan looks reasonable but is **lying**
* Terraform is not malicious — it is ignorant

This is why state correctness determines safety.

---

## 🧠 Critical Insight

Two identical realities:

* AWS bucket exists
* Same Terraform config

Different outcomes:

* With state → safe, boring
* Without state → destructive plan

**State = ownership.**

---

## 🚫 Absolute Rules After This Point

* Do NOT run `terraform apply`
* Do NOT recreate resources
* Do NOT “just try” fixes

Stop and reason.

---

## ✅ End Condition for Part B

This part is complete only if you can explain:

* Why Terraform wants to recreate the bucket
* Why the plan is dangerous
* Why this behavior is correct given missing state

Next step:
👉 **Step 06 — State Recovery (Import & Trust Restoration)**
