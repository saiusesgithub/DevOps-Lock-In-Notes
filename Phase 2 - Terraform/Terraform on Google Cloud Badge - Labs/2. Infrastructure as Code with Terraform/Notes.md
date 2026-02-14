# Infrastructure as Code with Terraform – Deep Reflection (GSP750)

Date - 13/02/2026

This lab was significantly deeper than the previous Terraform Fundamentals lab.

The first lab showed:
- How Terraform works.

This lab showed:
- How Terraform evolves infrastructure.
- How Terraform handles change.
- How Terraform reasons about dependencies.
- How Terraform treats provisioning differently from resources.

This was my first real exposure to:
- In-place updates (~)
- Destroy & recreate (-/+)
- Implicit vs explicit dependencies
- Saved execution plans
- terraform taint
- Provisioners lifecycle behavior

---

# 1️⃣ Terraform is a State Reconciliation Engine

This lab reinforced something critical:

Terraform is not a “create tool”.
It is a **desired state reconciliation engine**.

Every time I ran:

terraform plan

Terraform compared:

Desired State (main.tf)
vs
Actual State (terraform.tfstate + Google Cloud reality)

The execution plan was the diff.

This mental model is now clearer:

Infrastructure as Code = Desired State Definition  
Terraform = State Reconciler

---

# 2️⃣ Resource Change Types (The Most Important Learning)

This lab showed 3 types of changes:

### ✅ + Create
When adding a new resource.

### 🔁 ~ In-place Update
When modifying something like tags.

Terraform updated the VM without destroying it.

This is powerful because:
- Downtime avoided
- Minimal disruption
- State preserved

### ❌ -/+ Destroy and Recreate
When changing boot disk image.

Changing:

image = "debian-cloud/debian-12"

to:

image = "cos-cloud/cos-stable"

Forced Terraform to:

1. Destroy instance
2. Create new one

This was my first time clearly seeing destructive updates.

Not all changes are safe.
Some require full replacement.

Terraform makes this visible before applying.

That transparency is extremely important.

---

# 3️⃣ Dependency Graph in Action

This lab deeply reinforced Terraform’s dependency graph system.

### Implicit Dependency

When I wrote:

nat_ip = google_compute_address.vm_static_ip.address

Terraform automatically inferred:

VM depends on Static IP.

No manual configuration needed.

That interpolation expression was enough.

This is elegant design.

---

### Explicit Dependency

Using:

depends_on = [google_storage_bucket.example_bucket]

This is used only when dependency is not visible in configuration.

Important realization:

Implicit dependencies should always be preferred.
Explicit depends_on is for edge cases.

---

# 4️⃣ Saved Execution Plans (-out)

This lab introduced:

terraform plan -out static_ip
terraform apply static_ip

This was new.

Why this matters:

- Ensures exact plan execution
- Prevents drift between plan and apply
- Useful in CI/CD pipelines
- Enables review before execution

This is production-grade behavior.

---

# 5️⃣ Provisioners Are Special

This lab exposed something subtle:

Adding a provisioner does NOT force recreation.

When I added:

provisioner "local-exec" { ... }

Terraform said:

"No changes. Infrastructure matches configuration."

That was surprising.

Provisioners only run:
- On create
- Or when resource is recreated

They are NOT part of desired state.
They are lifecycle hooks.

This is a very important conceptual distinction.

---

# 6️⃣ terraform taint

This was one of the most interesting commands.

terraform taint google_compute_instance.vm_instance

It marks a resource as "unhealthy".

Next apply:
- Destroy
- Recreate

This is manual lifecycle override.

Very powerful.

This is useful when:
- Provisioner failed
- Config drift suspected
- Manual corruption happened

---

# 7️⃣ Destroy Order & Graph Logic

During:

terraform destroy

Terraform:
- Destroyed VM first
- Then destroyed network

Why?

Because GCP does not allow network deletion while instance exists.

Terraform did NOT require manual ordering.

It used the dependency graph.

This demonstrates:
Terraform handles both creation order and destruction order automatically.

---

# 8️⃣ What This Lab Didn’t Show (Important Gaps)

This lab did NOT cover:

- Remote backends
- State locking
- Multiple environments
- Modules
- Variable files
- Workspaces
- Lifecycle blocks
- Count / for_each
- Zero-downtime patterns

So this lab is intermediate — not advanced.

---

# 9️⃣ Real Infrastructure Lesson

Real infrastructure constantly changes.

Terraform handles change safely only if:

- State is intact
- Dependencies are properly defined
- Changes are reviewed via plan

Blind apply is dangerous.

Execution plan is sacred.

---

# 🔟 Biggest Mental Shift

Before this lab:
Terraform felt like a provisioning tool.

After this lab:
Terraform feels like a deterministic infrastructure state machine.

It tracks:
- Resource identity
- Dependencies
- Change types
- Order of operations
- Provisioning lifecycle

It is far more structured than cloud console clicking.

---

# 1️⃣1️⃣ DevOps Lock-In Perspective

This lab reinforced:

- Always predict plan output before running.
- Understand why change is in-place vs destructive.
- Never ignore execution plan diff.
- Know that provisioners are not state-managed.

If I truly want ownership:

I should be able to:

- Predict when a change triggers replacement.
- Predict resource ordering.
- Explain dependency inference.
- Explain why provisioners don't trigger updates.
- Explain why -out matters in pipelines.

---

# Final Thought

This lab moved me from:

"Terraform creates resources"

to

"Terraform manages lifecycle and reconciliation of infrastructure."

That’s a much more powerful understanding.
