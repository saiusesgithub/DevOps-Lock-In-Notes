# Terraform Fundamentals – Deep Reflection (GSP156)

This file documents what I *actually learned* from this lab beyond just creating a VM.

Date - 13/02/2026
---

# 1️⃣ What This Lab Really Taught Me (Beyond “Create a VM”)

This was not about Compute Engine.

It was about understanding:

- How Terraform interacts with a real cloud provider (Google)
- How providers are dynamically installed
- How Terraform state is generated and used
- How execution plans reveal hidden infrastructure details

This lab was my first real interaction with:
- Google provider plugin
- terraform.tfstate inspection
- Execution plan diff format

---

# 2️⃣ Hidden Concepts I Observed

## 🔹 Provider Auto-Installation

When I ran:

terraform init

Terraform automatically downloaded:

hashicorp/google vX.X.X

This reinforced:
- Providers are separate binaries
- Terraform core is provider-agnostic
- Infrastructure power comes from plugins

This explains why Terraform works across:
- AWS
- GCP
- Azure
- Kubernetes
- GitHub
- Cloudflare
etc.

Terraform itself doesn't "know cloud".
Providers teach it.

---

## 🔹 Declarative ≠ Step-by-Step

I did NOT write:

1. Create disk
2. Attach disk
3. Attach network
4. Assign IP

I wrote a single resource block.

Terraform internally:
- Built a resource dependency graph
- Determined creation order
- Attached nested resources correctly

That’s powerful.

---

## 🔹 Execution Plan = Infrastructure Diff

The output of:

terraform plan

looked like a Git diff:

+ create
~ modify
- destroy

This is critical.

Terraform is not blindly creating infrastructure.
It is calculating:

Desired State (instance.tf)
        vs
Current State (terraform.tfstate + cloud reality)

The diff output is the reconciliation result.

---

## 🔹 “(known after apply)” Meaning

This appeared many times in the plan output.

Example:
+ instance_id = (known after apply)

That means:

Some values cannot be known until:
- The cloud API returns them
- The resource is fully created

This clarified:
Terraform handles asynchronous API responses cleanly.

---

## 🔹 State File is the Brain

terraform.tfstate is not optional.

It stores:
- Resource IDs
- Metadata
- Cloud mappings
- Internal references

Without state:
Terraform cannot know what it created.

This explains:
Why state locking matters.
Why remote backends matter.
Why state corruption is dangerous.

This lab was my first real look at:
terraform show

Which revealed how rich the stored metadata is.

---

# 3️⃣ Gemini Code Assist Observation

This lab used AI to generate Terraform code.

Important realization:

AI can generate syntax.
But:
- It does not replace understanding execution plans.
- It does not replace state reasoning.
- It does not replace dependency awareness.

This reinforces my DevOps learning principle:

> Tools can assist generation, but ownership comes from reasoning.

---

# 4️⃣ What I Did NOT Configure (Important)

This lab intentionally skipped:

- provider "google" block
- version constraints
- variables
- outputs
- backend configuration
- IAM roles
- firewall rules
- custom VPC
- service accounts

Which means:

This was a minimal configuration relying on:
- Default credentials
- Cloud Shell environment context
- Implicit provider resolution

This is important because:

In production, I must explicitly define:
- Provider
- Region
- Credentials
- Version locking

---

# 5️⃣ Mental Model Reinforced

Terraform Workflow =

init → plan → apply → state → show

More precisely:

1. init
   - Download providers
   - Setup working directory

2. plan
   - Build resource graph
   - Compare desired vs actual state
   - Show diff

3. apply
   - Execute diff
   - Update state

4. state file
   - Source of truth for Terraform

5. show
   - Inspect current managed resources

---

# 6️⃣ Realization About Infrastructure as Code

Infrastructure becomes:

- Reviewable
- Versionable
- Diffable
- Repeatable
- Destroyable

Destroyable is key.

Cloud Console clicks are not reversible with history.

Terraform code is.

---

# 7️⃣ If I Rebuilt This Without Lab Guidance

To truly test understanding, I should be able to:

- Create provider block manually
- Add required_providers with version constraint
- Parameterize project and zone
- Use variables
- Use outputs
- Move state to remote backend

That is the next evolution.

---

# 8️⃣ How This Connects to My DevOps Lock-In

This lab reinforced:

- Execution plan reasoning
- State awareness
- Provider plugin architecture
- Declarative infrastructure modeling

But it was shallow.

To internalize Terraform deeply, I must:
- Write configs from scratch
- Predict plan output before running
- Break things intentionally
- Rebuild without notes

---

# 9️⃣ Final Thought

This lab was not about a VM.

It was about seeing Terraform operate against a real cloud API.

Now the goal is to move from:

"Running Terraform"

to

"Thinking in Terraform"
