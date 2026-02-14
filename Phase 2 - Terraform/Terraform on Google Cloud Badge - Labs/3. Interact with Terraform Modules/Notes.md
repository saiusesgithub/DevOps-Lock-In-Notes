# Interact with Terraform Modules – Deep Reflection (GSP751)

Date - 13/02/2026

This lab changed how I think about Terraform structure.

Previous labs taught me:
- How Terraform creates resources.
- How Terraform handles lifecycle changes.
- How Terraform manages state and dependencies.

This lab taught me:
- How to scale Terraform beyond a single file.
- How to design reusable infrastructure.
- How to encapsulate infrastructure logic.
- How to think in modules instead of flat configs.

This is where Terraform started feeling like real software engineering.

---

# 1️⃣ Every Terraform Configuration Is Already a Module

One key realization:

Terraform treats every directory as a module.

The directory I run terraform from is the **root module**.

When I reference another directory using:

module "xyz" {
  source = "./modules/xyz"
}

That directory becomes a **child module**.

This means:

Modules are not a special feature.
They are the default architecture.

That mental shift is important.

---

# 2️⃣ Registry Modules vs Local Modules

This lab had two distinct parts:

## Part A – Using a Registry Module

I used:

source  = "terraform-google-modules/network/google"
version = "~> 6.0"

Important lessons:

- Modules are versioned.
- Version pinning prevents breaking changes.
- Modules abstract away complexity.
- Inputs and outputs define module boundaries.

I didn’t write networking logic myself.
I consumed someone else's encapsulated logic.

This is infrastructure reuse.

---

## Part B – Building My Own Module

This was more important.

I built:

modules/gcs-static-website-bucket/

With:

- website.tf
- variables.tf
- outputs.tf
- README.md
- LICENSE

This forced me to think:

What should be configurable?
What should be internal?
What should be exposed?

That’s module design.

---

# 3️⃣ Encapsulation Is Real

Inside my module:

google_storage_bucket.bucket

Outside my module:

module.gcs-static-website-bucket.bucket

The caller cannot access internal resource names directly.

Only outputs are exposed.

This creates:

Controlled interface boundaries.

Exactly like:

- Public vs private methods in OOP.
- API contracts in microservices.

Terraform modules are infrastructure APIs.

---

# 4️⃣ Input Variables Define the Contract

Inside variables.tf:

variable "name" { ... }
variable "project_id" { ... }
variable "lifecycle_rules" { ... }

These are the module's API inputs.

Anything without default = required.

Anything with default = optional.

This defines:

The module interface contract.

Changing variable structure later is a breaking change.

That means:

Module design requires forward thinking.

---

# 5️⃣ Outputs Define What the Outside World Sees

Inside outputs.tf:

output "bucket" {
  value = google_storage_bucket.bucket
}

Outside:

module.gcs-static-website-bucket.bucket

This is how information flows upward.

Terraform module communication flow:

Child module → Outputs → Parent module → Possibly other resources

This is data flow modeling.

---

# 6️⃣ Module Installation Mechanism

When I ran:

terraform init

Terraform created:

.terraform/modules/

This is where remote modules get downloaded.

Important:

- Remote modules are cached locally.
- Local modules are symlinked.
- Changing local module code does NOT require re-init.

That distinction matters in real projects.

---

# 7️⃣ Modules Reduce Duplication

Without modules:

If I needed 3 buckets:
I would copy-paste resource blocks 3 times.

With modules:

module "bucket_1" { ... }
module "bucket_2" { ... }

The logic is centralized.

This reduces:

- Drift
- Copy errors
- Maintenance burden

This is DRY applied to infrastructure.

---

# 8️⃣ Dynamic Blocks = Advanced Abstraction

Inside website.tf:

dynamic "retention_policy" { ... }
dynamic "encryption" { ... }
dynamic "lifecycle_rule" { ... }

This was important.

Dynamic blocks allow:

Optional nested configurations.

This means:

Module consumers can choose advanced features without rewriting logic.

That’s powerful abstraction.

---

# 9️⃣ Separation of Root vs Child Responsibilities

Root module:

- Decides what modules to use.
- Supplies inputs.
- Exposes high-level outputs.

Child module:

- Defines resources.
- Encapsulates implementation.
- Defines its own variables and outputs.

Clear separation of concerns.

This is layered architecture.

---

# 🔟 Module Directory Structure Is Convention, Not Enforcement

Terraform does NOT require:

main.tf
variables.tf
outputs.tf

But they are best practice.

Terraform only cares about:

*.tf files in a directory.

This means:

Structure is for humans.
Not for Terraform.

Good structure improves maintainability.

---

# 1️⃣1️⃣ Real Production Insight

Modules are required when:

- Managing multiple environments (dev, staging, prod)
- Managing multi-region deployments
- Sharing infra patterns across teams
- Standardizing security configurations

Large organizations do NOT write flat Terraform.

They build module libraries.

---

# 1️⃣2️⃣ What This Lab Did NOT Cover

Important omissions:

- Module version publishing
- Private module registries
- Semantic versioning strategies
- Module testing
- Module CI pipelines
- Breaking changes handling
- Module deprecation strategies

So this lab covered:

Module consumption + basic module creation.

Not enterprise module lifecycle management.

---

# 1️⃣3️⃣ Biggest Mental Shift

Before this lab:
Terraform was resource configuration.

After this lab:
Terraform is infrastructure composition.

I am not writing resources.
I am assembling modules.

Modules are infrastructure building blocks.

This is a higher level of abstraction.

---

# 1️⃣4️⃣ DevOps Lock-In Reflection

If I truly understand modules, I should be able to:

- Design a reusable VPC module.
- Separate compute, networking, and storage modules.
- Pass outputs between modules safely.
- Avoid tight coupling.
- Predict module dependency behavior.
- Refactor flat Terraform into modular architecture.

Modules are not optional in serious Terraform work.

They are the foundation of scalable IaC.

---

# Final Thought

This lab transformed Terraform from:

"A tool that creates resources"

to

"A framework for designing reusable infrastructure systems."

That is a significant evolution.
