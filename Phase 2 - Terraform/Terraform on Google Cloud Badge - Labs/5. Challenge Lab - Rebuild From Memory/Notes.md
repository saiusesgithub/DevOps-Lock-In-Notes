# 🚀 Build Infrastructure with Terraform on Google Cloud

## Challenge Lab (GSP345) – Personal Reflection Canvas

Date - 14/02/2026

---

# 🧠 Lab Nature

This was a **true challenge lab**:

* No step-by-step guidance
* Only objectives
* Required debugging independently
* Required real understanding of Terraform state, modules, and networking

This lab simulated a real-world scenario where infrastructure already exists and must be brought under Terraform control.

---

# 📁 Task 1 – Built Modular Terraform Architecture

### Directory Structure Created

```
main.tf
variables.tf
modules/
 ├── instances/
 │    ├── instances.tf
 │    ├── variables.tf
 │    └── outputs.tf
 └── storage/
      ├── storage.tf
      ├── variables.tf
      └── outputs.tf
```

### What I Actually Did

* Defined provider with project, region, zone
* Passed variables from root → child modules
* Ensured proper indentation and structure
* Initialized Terraform cleanly

### Key Learning

Terraform modules are isolated.
Variables must be explicitly passed.
Nothing is implicitly shared.

This reinforced modular IaC design thinking.

---

# 🧩 Task 2 – Imported Existing VM Instances

Two instances already existed:

* tf-instance-1
* tf-instance-2

### My Approach

1. Wrote minimal `google_compute_instance` configuration
2. Included required arguments only:

   * machine_type
   * boot_disk
   * network_interface
   * metadata_startup_script
   * allow_stopping_for_update
3. Used `terraform import`
4. Applied changes

### What This Taught Me

* Import binds infrastructure to state
* Import does NOT generate configuration
* Configuration must already match real resource
* Minimal config causes in-place updates during apply

### Critical Insight

Terraform state is the mapping layer between config and reality.

---

# ☁️ Task 3 – Remote Backend with GCS

### What I Did

* Created Cloud Storage bucket via storage module
* Applied infrastructure
* Converted backend from local → GCS
* Used prefix `terraform/state`
* Migrated state using `terraform init -migrate-state`

### What I Understood

Remote backend enables:

* Shared state
* Centralized tracking
* Team safety
* Production-level architecture

State migration is safe if done carefully.

---

# 🔄 Task 4 – Modified Infrastructure

### Changes Made

* Updated machine types to `e2-standard-2`
* Added third VM instance
* Applied updates successfully

### Key Learning

Terraform detects:

* In-place updates
* Destroy & recreate scenarios

Machine type changes can require stopping instances.
`allow_stopping_for_update = true` prevents forced recreation.

---

# 💥 Task 5 – Destroyed Resource Cleanly

### What I Did

* Removed third instance from configuration
* Ran `terraform apply`

### Important Understanding

Terraform does not destroy resources manually.

It destroys only what:

* Exists in state
* Is removed from configuration

State-driven lifecycle control is core Terraform behavior.

---

# 🌐 Task 6 – Used Registry Network Module

### Module Used

* Version pinned to 10.0.0
* Created VPC with global routing
* Created 2 subnets:

  * subnet-01 → 10.10.10.0/24
  * subnet-02 → 10.10.20.0/24

### What I Practiced

* Reading module documentation
* Passing required variables
* Connecting instances to correct subnets
* Updating network and subnetwork fields properly

### Major Realization

Registry modules abstract complexity, but you must:

* Understand outputs
* Understand required inputs
* Reference values correctly

Modules don’t remove responsibility — they reduce repetition.

---

# 🔥 Task 7 – Firewall Configuration

### Firewall Created

* Name: tf-firewall
* Network: VPC Name
* Allowed ingress:

  * TCP 80
  * Source: 0.0.0.0/0

### What I Understood

Firewall requires:

* Correct network reference (self_link or ID)
* Correct source_ranges

Networking errors are common when:

* Network names mismatch
* Wrong self_link is used

This required state inspection awareness.

---

# 🎯 What This Lab Proved About Me

I can now:

* Import legacy infrastructure
* Build modular Terraform architecture
* Configure remote backends
* Use registry modules correctly
* Modify infrastructure safely
* Destroy resources cleanly
* Configure networking and firewall rules

This is beyond beginner Terraform.

---

# 🧠 Biggest Technical Takeaways

1. Terraform state is the backbone of everything
2. Import requires config discipline
3. Remote backend is mandatory in team environments
4. Registry modules require understanding, not copying
5. Networking + compute must be aligned carefully
6. Removing config = destroy (if tracked in state)

---

# 🚀 Growth Direction From Here

To move to advanced level:

* Practice workspaces (dev / prod separation)
* Add environment-based tfvars
* Implement remote state locking scenario
* Rebuild this entire architecture on AWS
* Integrate Terraform into CI/CD pipeline

---

# 📌 Final Reflection

This lab forced real thinking.

It required:

* Debugging
* Reading error messages
* Understanding state behavior
* Designing modular structure

This was not syntax practice.

This was infrastructure engineering.

---

🔥 Confidence Level After Completion: High
🎯 Terraform Skill Level: Associate-ready
