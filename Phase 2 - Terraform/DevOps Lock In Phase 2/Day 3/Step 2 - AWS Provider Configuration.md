# Step-02 - AWS-Provider-Configuration

**Date:** February 8, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Step Theme:** Connecting Terraform Core to AWS through the provider (still minimal, still controlled)

---

## 🎯 Step Objective

Introduce the **AWS provider configuration** and understand:

* What Terraform needs to know about AWS
* What happens during `terraform init` when a provider is declared
* How authentication and region selection fit into Terraform’s model

This step is about **configuration and reasoning**, not creating resources yet.

---

## 1️⃣ What “Configuring a Provider” Really Means

Configuring a provider does **not** create infrastructure.

It means:

* Declaring *which platform* Terraform will talk to
* Providing *enough information* for the provider to authenticate
* Allowing Terraform Core to load the correct provider plugin

Until a resource exists, Terraform will only:

* Initialize the provider
* Validate configuration
* Prepare for future plans

---

## 2️⃣ What the AWS Provider Needs (Conceptually)

At minimum, the AWS provider needs:

* **Credentials** (who are you?)
* **Region** (where should resources exist?)

These are **provider concerns**, not Terraform Core concerns.

Terraform Core does not:

* Store AWS credentials
* Validate IAM permissions
* Know which regions exist

All of that is delegated to the AWS provider.

---

## 3️⃣ Where Credentials Come From (Important Mental Model)

Terraform does **not** require credentials inside `.tf` files.

The AWS provider can source credentials from:

* Environment variables
* Shared credentials file
* AWS CLI configuration
* IAM roles (later)

Terraform Core only passes execution to the provider.
The provider decides *how* to authenticate.

---

## 4️⃣ Why Region Is Mandatory

AWS is region-scoped.

Without a region:

* The provider does not know *where* to create resources
* API calls cannot be routed correctly

Region selection is therefore:

* Required
* Explicit
* Part of provider configuration

---

## 5️⃣ What Changes When a Provider Is Added

Once an AWS provider block exists:

* `terraform init` will download the AWS provider plugin
* `.terraform/` directory will be populated
* `.terraform.lock.hcl` will record the provider version

Still:

* No cloud resources are touched
* No state changes yet (until apply)

---

## 6️⃣ Boundaries for This Step

Hard limits:

* No AWS resources yet
* No S3 bucket yet
* No variables yet
* One provider only

The goal is **provider wiring**, not infrastructure.

---

## ✅ Step 02 Completion Check

You should be able to explain:

* What the AWS provider block represents
* Where credentials come from
* Why region is mandatory
* What `terraform init` will do differently now

If you cannot predict `terraform init` behavior here, stop.

---

### Step-02 — AWS Provider Configuration: Questions, Answers & Mental Model

**Q: What files will be created by `terraform init` once an AWS provider is declared?**  
A: The `.terraform/` directory will be created to store the AWS provider binary, and `terraform.lock.hcl` will be created to lock the provider version.

---

**Q: Will AWS APIs be called during `terraform init`? Why or why not?**  
A: No. `terraform init` is a local preparation step. It only downloads provider binaries and prepares Terraform to run later; it does not authenticate or make cloud API calls.

---

**Q: What new information does Terraform Core learn when an AWS provider block exists?**  
A: Terraform Core learns which provider is required and which region value to pass. It does not see or handle credentials; authentication is fully owned by the provider.

---

**Q: Will a state file be created at this step? Why or why not?**  
A: No. State is created during `terraform apply`, not during `terraform init`. Since no resources are reconciled yet, no state is written.

---

### 🔒 Locked Mental Model

- `terraform init` prepares tooling, not infrastructure  
- Providers are downloaded and version-locked during init  
- Terraform Core never handles credentials  
- Cloud APIs are only called during apply/destroy  
- State represents applied reality, not configuration existence


---

## 🧩 Provider Configuration Used in This Step

```hcl
provider "aws" {
  region = "us-east-1"
}
```

This is the **minimal valid AWS provider configuration**.

It:

* Declares which provider Terraform needs
* Specifies the region to operate in
* Does NOT include credentials
* Does NOT create infrastructure

---

## ❓ Questions & Answers — Step 02

### Q: What will `terraform init` do now that the AWS provider block exists?

A: It will identify that the AWS provider is required, download the provider binary into the `.terraform/` directory, and record the selected provider version in `terraform.lock.hcl`.

---

### Q: What files and folders are expected to appear after `terraform init`?

A:

* `.terraform/` — stores provider binaries and internal metadata
* `terraform.lock.hcl` — locks the exact provider version used

---

### Q: Will AWS APIs be called during `terraform init`? Why or why not?

A: No. `terraform init` is a local preparation step. It only installs provider plugins and prepares Terraform Core. Authentication and cloud API calls happen only during `apply` or `destroy`.

---

### Q: What new information does Terraform Core learn when an AWS provider block exists?

A: Terraform Core learns which provider is required and which region value to pass to it. Terraform Core does not read, store, or validate credentials.

---

### Q: Will a state file be created at this step? Why or why not?

A: No. State files are created or updated only during `terraform apply` or `terraform destroy`, when reconciliation occurs.

---

## 🔒 Locked Mental Models (Must Remember)

* Providers are plugins that talk to cloud APIs
* Terraform Core never handles credentials
* `terraform init` prepares tooling, not infrastructure
* Cloud APIs are only touched during apply/destroy
* State existence means Terraform has taken ownership before
* Empty state is a valid and intentional state