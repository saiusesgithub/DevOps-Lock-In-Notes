# Day 1 — Step 02: Terraform Core Loop (How Terraform Thinks)

**Date:** February 8, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Step Theme:** Terraform’s internal loop — how Terraform actually thinks and decides

---

This step explains **what Terraform does internally every time you run it**.  
Not commands yet. Not syntax yet.  
Only **behavior**.

If this loop is clear, `plan`, `apply`, and `destroy` will never feel confusing later.

---

## 1. The Terraform Core Loop (Big Picture)

Every Terraform run follows the same mental loop:

1. Read **desired state** (configuration)
2. Read **current state** (state file + provider reality)
3. Compare both
4. Produce a **plan** (prediction)
5. Optionally **apply** that plan (execution)

Terraform never skips this loop.

Even `destroy` follows the same logic.

---

## 2. What Terraform Reads First (Very Important)

Terraform always reads **three things** before doing anything meaningful:

### 2.1 Desired State (Configuration)
- What you *want* the infrastructure to look like
- Defined in Terraform configuration files
- Static description, not instructions

### 2.2 Current State (Terraform State)
- What Terraform *believes* currently exists
- What resources Terraform thinks it owns
- Mappings between Terraform resources and real-world IDs

### 2.3 Provider Reality (External System)
- Actual infrastructure state in the real world
- Fetched via provider APIs
- Used to validate and refresh Terraform’s understanding

Terraform does **not** blindly trust state; it reconciles it with provider data.

---

## 3. Comparison Phase (The Heart of Terraform)

Once Terraform has:
- Desired state
- Current state
- Provider reality

It performs a **diff**.

Terraform asks, for every resource:
- Does this exist?
- Does it match the desired configuration?
- Is anything missing?
- Is anything extra?

This comparison produces **change decisions**, not actions.

Examples of decisions:
- Create
- Update
- Replace
- Do nothing
- Destroy

No infrastructure is touched at this stage.

---

## 4. What a Terraform Plan Really Is

A Terraform **plan** is:

- A **prediction**
- A **proposal**
- A **calculated diff**

A plan answers:
> “If I apply this configuration right now, these are the exact changes Terraform will make.”

Key properties of a plan:
- Deterministic (given same inputs)
- Read-only
- Safe to run repeatedly
- Does not change infrastructure

If the plan is empty:
- Terraform does nothing
- Desired state already matches current state

---

## 5. Apply: Executing the Plan (Not Recomputing Logic)

When you run apply:
- Terraform does **not** rethink everything from scratch
- It executes the actions derived from the plan
- Actions are performed via providers

Important:
- Apply is **execution**
- Plan is **reasoning**

Separating these two is a deliberate safety feature.

---

## 6. Destroy Is Still the Same Loop

Destroy is not a “special delete command”.

Destroy means:
- Desired state = nothing should exist
- Terraform compares current state to empty desired state
- Terraform plans deletions
- Terraform executes deletions

Destroy is simply **reconciliation toward zero resources**.

This is why destroy is safe *when state is correct*.

---

## 7. Why Terraform Is Predictable (When Used Correctly)

Terraform is predictable because:
- Desired state is explicit
- State records ownership
- Plans show all changes in advance
- Execution follows the plan

Terraform becomes dangerous only when:
- State is corrupted
- State is deleted unknowingly
- Manual changes are made outside Terraform without awareness

The system itself is deterministic.

---

## 8. What Terraform Will Never Do Automatically

Terraform will **not**:
- Guess what you meant
- Hide changes from you
- Apply changes without showing a plan
- Manage resources it does not own (unless imported)

Terraform is conservative by design.

---

## 9. Mental Model to Lock In (Critical)

Think of Terraform as:

> A planner that reconciles a declared desired state with recorded and observed reality, then executes the minimal set of actions required to align them.

If you remember only this sentence, Step 02 is successful.

---

## 🔎 Step 2 — Core Loop Questions & Refined Answers

### 1) What does Terraform read before doing anything?
Terraform reads three things:
- **Desired state** from configuration
- **Current state** from the state file
- **Real-world state** via provider APIs to refresh and validate state

It then compares all three.

---

### 2) What does a Terraform plan represent?
A plan represents the **exact set of changes** required to move from the current state to the desired state, based on Terraform’s comparison.

---

### 3) Why is apply execution and not reasoning?
Because all reasoning (diff calculation and decision-making) already happened during `plan`.  
`apply` simply executes the approved plan via providers.

---

### 4) Why is destroy not dangerous by itself?
Destroy is not dangerous because it also goes through the **plan phase**, showing exactly which resources will be deleted before anything happens.

Danger comes from **wrong or missing state**, not from destroy itself.

---

### 5) Why is Terraform behavior predictable?
Terraform is predictable because:
- Desired state is explicit
- State tracks ownership
- All changes are previewed in the plan
- Apply executes only what was planned
