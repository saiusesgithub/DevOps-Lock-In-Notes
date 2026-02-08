# Step-01 - Providers-and-Terraform-Core

**Date:** February 8, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Step Theme:** Understanding providers as the bridge between Terraform core and real infrastructure

---

## 🎯 Step Objective

Understand **why providers exist**, what **Terraform Core** does (and does not do), and how Terraform is able to manage real infrastructure without being cloud-specific.

This step is purely conceptual. No AWS yet. No code execution.

---

## 1️⃣ Terraform Core — What It Actually Is

Terraform Core is the engine that:

* Parses Terraform configuration files
* Builds the dependency graph
* Computes plans (diff between desired and current state)
* Orchestrates apply and destroy
* Reads and writes state

Terraform Core **does not know**:

* What AWS is
* What S3 is
* How to call cloud APIs
* How infrastructure is actually created

Terraform Core is cloud-agnostic by design.

---

## 2️⃣ Why Terraform Core Cannot Talk to AWS Directly

If Terraform Core talked directly to AWS:

* Terraform would need AWS-specific logic built in
* Supporting multiple clouds would be impossible to scale
* Updating cloud APIs would require changing Terraform itself

This would make Terraform:

* Monolithic
* Hard to maintain
* Slow to evolve

Terraform avoids this by delegating cloud-specific logic.

---

## 3️⃣ What a Provider Is

A **provider** is a plugin that:

* Knows how to talk to a specific platform (AWS, Azure, GCP, GitHub, etc.)
* Implements resource creation, update, read, and delete logic
* Translates Terraform’s desired state into real API calls

Terraform Core talks only to providers.
Providers talk to the real world.

---

## 4️⃣ Provider Responsibilities (Very Important)

Providers are responsible for:

* Authentication and authorization
* Validating resource schemas
* Making API calls to create/update/delete resources
* Reading real-world state and returning it to Terraform Core

Terraform Core never makes cloud API calls itself.

---

## 5️⃣ How Terraform Core and Providers Work Together

High-level flow:

1. Terraform Core reads configuration
2. Terraform Core determines which providers are required
3. Providers are initialized (via `terraform init`)
4. Terraform Core asks providers:

   * What resources exist?
   * What attributes do they have?
5. Terraform Core computes the plan
6. Terraform Core instructs providers to execute the plan

Terraform Core **coordinates**. Providers **execute**.

---

## 6️⃣ Why Providers Are Versioned Separately

Providers are versioned independently because:

* Cloud APIs evolve frequently
* Bugs and features change independently of Terraform Core
* Users need reproducible infrastructure behavior

Provider versions are locked using `.terraform.lock.hcl` to ensure consistency.

---

## 7️⃣ Key Mental Model to Lock In

> Terraform Core is the brain.
> Providers are the hands.

Terraform thinks in graphs and diffs.
Providers act in APIs and resources.

---

### Step-01 — Providers & Terraform Core: Questions and Answers

**Q: Why can’t Terraform Core talk to AWS directly?**  
A: Terraform Core is designed to be cloud-agnostic. If it talked directly to AWS, Terraform would become cloud-specific, harder to maintain, and unable to scale across many platforms.

---

**Q: What exactly does a provider do that Terraform Core cannot?**  
A: A provider translates Terraform’s desired state into real cloud API calls, performs create/read/update/delete operations, and returns the real-world state back to Terraform.

---

**Q: Who owns authentication — Terraform Core or the provider?**  
A: The provider owns authentication because authentication is platform-specific and Terraform Core has no cloud knowledge.

---

**Q: If a provider has a bug, does upgrading Terraform Core fix it? Why or why not?**  
A: No. Providers are versioned and released independently of Terraform Core. A provider bug is fixed by upgrading the provider, not Terraform Core.

---

**Q: Why are providers implemented as plugins?**  
A: Providers are plugins so cloud-specific logic can evolve independently of Terraform Core. This allows faster updates, isolated bug fixes, and support for many platforms without changing Terraform itself.
