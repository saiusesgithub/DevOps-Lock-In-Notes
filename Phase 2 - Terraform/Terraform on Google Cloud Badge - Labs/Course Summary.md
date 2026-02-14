# 📘 Build Infrastructure with Terraform on Google Cloud

## Course Summary (Completed Feb 13–14, 2025)

---

# 🗓️ Timeline

* **Feb 13, 2025** → Completed 4 guided labs
* **Feb 14, 2025** → Completed final Challenge Lab (GSP345)

Total duration: 2 days

---

# 🧪 Lab 1 – Provision Basic Infrastructure

### What I Did

* Installed and initialized Terraform
* Configured Google provider
* Created basic GCP resources (VM, network, etc.)
* Used `terraform init`, `plan`, `apply`, and `destroy`

### What I Learned

* Terraform workflow lifecycle
* Structure of resource blocks
* How Terraform state file is created and used

---

# 🧪 Lab 2 – Variables and Outputs

### What I Did

* Defined input variables
* Used variables inside resource definitions
* Created output values
* Practiced modifying configuration safely

### What I Learned

* Parameterizing infrastructure
* Avoiding hardcoded values
* How outputs expose useful resource attributes

---

# 🧪 Lab 3 – Managing Terraform State

### What I Did

* Explored local backend
* Created and configured GCS remote backend
* Migrated state from local → remote
* Used `terraform refresh`
* Imported existing Docker container into Terraform
* Cleaned configuration to match state

### What I Learned

* State is the backbone of Terraform
* Import binds infrastructure to state (does not create config)
* Remote backends are required for team environments
* Drift detection and state synchronization

---

# 🧪 Lab 4 – Working with Modules

### What I Did

* Created reusable Terraform modules
* Passed variables between root and child modules
* Structured infrastructure cleanly
* Managed multiple resources using modular approach

### What I Learned

* Root vs child module separation
* Variable propagation across modules
* Reusability and maintainable IaC design

---

# 🧪 Lab 5 – Challenge Lab (GSP345) – Feb 14, 2025

### What I Did

* Created modular Terraform project structure
* Imported two existing VM instances
* Configured remote backend with GCS
* Modified machine types
* Added and removed instances
* Used Terraform Registry Network Module (v10.0.0)
* Created VPC with 2 subnets
* Connected instances to correct subnets
* Configured firewall rule for TCP 80

### What I Demonstrated

* Independent debugging
* Understanding of Terraform state behavior
* Infrastructure import workflow
* Registry module usage
* Networking configuration in GCP
* Safe resource updates and destruction

---

# 🎯 Overall Course Outcome

After completing this course:

* I can provision infrastructure in GCP using Terraform
* I understand Terraform state (local + remote)
* I can import existing infrastructure into Terraform
* I can build and use custom modules
* I can use modules from the Terraform Registry
* I can safely update and destroy resources

This course established practical, hands-on Terraform competency on Google Cloud.

---

✅ Completion Dates: Feb 13–14, 2025

🎯 Skill Level After Completion: Intermediate (Associate-ready foundation)
