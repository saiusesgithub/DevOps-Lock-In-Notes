# Step-03 - First-Real-Resource-S3-Bucket

**Date:** February 8, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Step Theme:** Introducing the first real cloud resource and observing Terraform behavior end‑to‑end

---

## 🎯 Step Objective

Create **exactly one real AWS resource** using Terraform and understand, in detail:

* What changes when a resource block is added
* How `plan` predicts real infrastructure changes
* How `apply` executes those predictions
* How Terraform state changes once something real exists

This step is about **behavior**, not S3 features.

---

## 🧠 Pre‑Step Mental Lock‑In

Before touching any code, the following must be true:

* Terraform is already initialized
* AWS provider is configured
* No resources exist yet
* Current state represents **zero resources**

We are about to move from:

> “Terraform manages nothing”
> ⟶
> “Terraform manages one real thing”

This transition is critical.

---

## 🧱 Why S3 Is the First Resource

S3 is intentionally chosen because:

* No networking complexity
* No compute lifecycle
* No background processes
* No ordering noise

It allows us to focus purely on **Terraform mechanics**.

---

## 🧩 What a Resource Block Represents

A Terraform resource block:

* Declares a desired object in the real world
* Is owned entirely by Terraform once applied
* Will be tracked in state after creation

Terraform does **not**:

* Create resources implicitly
* Guess names or defaults
* Manage anything not declared

---

## 🧪 Prediction Discipline (Mandatory)

Before writing the resource block, you must be able to answer:

* What will `terraform plan` show?
* What will `terraform apply` do?
* What AWS API will be called?
* What new data will appear in state?

No execution happens until predictions are clear.

---

## 🧱 Minimal S3 Resource Configuration

The next action will be to add **one** resource block:

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "<globally-unique-bucket-name>"
}
```

Important constraints:

* Bucket name **must be globally unique**
* No ACLs
* No versioning
* No tags
* No extras

Minimalism is intentional.

---

## 🚫 Hard Boundaries for This Step

* One resource only
* No additional arguments
* No variables
* No modules
* No console clicks

Terraform must be the **single source of truth**.

---

## 🔍 What Will Change After Apply

After a successful `terraform apply`:

* An S3 bucket will exist in AWS
* Terraform state will contain:

  * Resource type
  * Resource name
  * Provider‑assigned ID
  * Resource attributes

Terraform now **owns** this bucket.

---

## 🔁 Lifecycle Expectation

You will:

1. Add the resource block
2. Run `terraform plan`
3. Read and understand the plan
4. Run `terraform apply`
5. Confirm creation
6. Inspect state

Destroying the bucket will come in the next step.

---

## 🧱 Resource Block Used

```hcl
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "devops-lock-in-demo-bucket"
}
```

## ❓ Prediction Questions (Before Plan)

**Q: What will `terraform plan` show after adding this resource?**
A: Terraform will show **1 resource to be created** because the desired state includes an S3 bucket that does not exist in current state.

---

**Q: Will AWS APIs be called during `terraform plan`?**
A: Terraform plan may read from AWS in some cases, but for this configuration no meaningful AWS API calls are required. No resources are created or modified during plan.

---

**Q: Will AWS APIs be called during `terraform apply`?**
A: Yes. During apply, the AWS provider authenticates and calls the **S3 CreateBucket API** to create the bucket.

---

## 📋 Observed `terraform plan` Behavior

Key observations from the plan output:

* Terraform showed `+ create` for `aws_s3_bucket.demo_bucket`
* Many attributes were marked as `(known after apply)`

### Why `(known after apply)` Appears

* These values are assigned by AWS only after creation
* Terraform does not guess or invent values
* The provider returns these values after successful creation

Mental model:

> `(known after apply)` = values AWS will return later

---

## ❓ Prediction Questions (Before Apply)

**Q: What local files will change after apply?**
A: Only `terraform.tfstate` will be updated. Configuration files remain unchanged.

---

**Q: What will change inside the state file?**
A: A new entry for `aws_s3_bucket.demo_bucket` will be added, including the real AWS resource ID and attributes returned by the provider.

---

## ⚙️ Observed `terraform apply` Behavior

During apply:

* Terraform re-generated the plan
* Prompted for confirmation
* AWS provider authenticated
* S3 CreateBucket API was called
* Bucket was created successfully

Apply output confirmed:

```
Resources: 1 added, 0 changed, 0 destroyed
```

---

## 🧠 Critical Terraform Behaviors Locked In

### Why Apply Recomputes the Plan

* Terraform does not blindly trust previous output
* Apply always re-evaluates desired vs current state
* Exact plans can be enforced only using `-out` (deferred topic)

---

### Why State Is Central After This Step

After apply:

* Terraform state now contains real infrastructure
* Terraform has taken **ownership** of the S3 bucket
* Manual changes in AWS would cause **drift**

State is now the authoritative record of reality.

---

## 🔒 Locked Mental Models

* `terraform plan` predicts, it does not mutate
* `terraform apply` executes provider actions
* Providers talk to cloud APIs, Terraform Core does not
* State is updated only after successful reconciliation
* Empty state → real state is a critical transition

---