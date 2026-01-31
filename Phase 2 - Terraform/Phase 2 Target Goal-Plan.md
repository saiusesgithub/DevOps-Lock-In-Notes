# DevOps Lock-In — Phase 2 (Terraform)

**Duration:** 14 Days  
**Date:** 1st Feb - 14th Feb , 2026 

**Primary Tool:** Terraform  
**Resource:** DevOps Directive — *Terraform: Beginner to Pro*  

https://courses.devopsdirective.com/terraform-beginner-to-pro

https://youtu.be/7xngnjfIlK4?si=hptzrw-izR5kdx1G

https://github.com/sidpalas/devops-directive-terraform-course

---

## 🎯 PHASE OBJECTIVE (LOCKED)

By the end of Day 14, Terraform should feel:

- Predictable
- Mechanical
- Calm
- Explainable without commands

> “I can read, write, reason about, and debug Terraform configurations, understand state and lifecycle, structure Terraform for real projects, and explain how teams use Terraform in practice.”

This phase is **not** about:
- Certifications
- Speed
- Terraform Cloud / Enterprise
- AWS mastery

This phase **is** about:
- Mental models
- Operator-level understanding
- Predictability
- Confidence under uncertainty

---

## 🧠 PRIOR CONTEXT (ALREADY COMPLETED)

### Phase 1 — Docker Fundamentals (Completed)
- Linux + SSH foundations
- Docker internals & lifecycle
- Docker Compose (networking, envs, readiness)
- CI mental model (GitHub Actions)
- Cloud VM deployment
- Resilience & restart policies
- Volumes & persistence

**Outcome:**
> Docker is no longer magical. Systems thinking is established.

Phase 2 builds directly on this mindset.

---

## 🧭 LEARNING RULES (STRICT)

❌ No rushing  
❌ No blind copy-paste  
❌ No skipping “boring” topics  
❌ No AWS obsession  

✅ Think before typing  
✅ Predict before apply  
✅ Break things intentionally  
✅ Prefer explanation over execution  
✅ Terraform must feel *boring* by the end  

---

## 🔁 DAILY EXECUTION LOOP (EVERY DAY)

Each day follows **the same loop**:

1. **Watch video (30–35 min max)**
   - Pause often
   - Rewind if confused
   - No multitasking

2. **Raw Notes (Messy, personal)**
   - What confused me?
   - What surprised me?
   - What felt unintuitive?
   - What assumptions broke?

3. **Reasoning (No Code Yet)**
   - Explain the concept in words
   - Draw mental diagrams if helpful
   - Predict behavior before testing

4. **Minimal Practice (If applicable)**
   - Very small experiments
   - No “building projects” yet
   - Focus on observing behavior

5. **End-of-Day Check**
   - Can I explain this without commands?
   - What still feels fuzzy?

---

## 📝 NOTE-TAKING SYSTEM (MANDATORY)

Each day has **three note layers**:

### 1️⃣ Raw Notes (During Video)
- Bullet points
- Half-sentences
- Questions
- Confusion is allowed

### 2️⃣ Refined Notes (Post-Discussion)
- Clean mental models
- Clear explanations
- Why > How
- Written *after* mentor discussion

### 3️⃣ Reflection Snippet (5–10 lines)
- What clicked today?
- What felt wrong initially?
- What I would warn my past self about

---

## 📅 DAY-BY-DAY PLAN (EVEN LOAD)

### 🔹 DAY 1 — Why Terraform Exists
**Theme:** Pain → IaC → Declarative mindset  
**Video (~32 min):**
- `00:00 → 18:30`

**Focus:**
- Evolution of infrastructure
- Why scripts don’t scale
- Declarative vs imperative responsibility shift
- What Terraform actually solves (and what it doesn’t)

**Daily Test:**
> Why was Terraform created, and what problem does it *really* solve?

---

### 🔹 DAY 2 — Terraform as a System
**Theme:** How Terraform thinks  
**Video (~32 min):**
- `18:30 → 28:32`
- `28:32 → ~32:00`

**Focus:**
- Providers
- Resources
- High-level state concept
- Execution lifecycle (no commands)

**Daily Test:**
> Explain Terraform’s workflow without naming a single command.

---

### 🔹 DAY 3 — Setup Without Fear
**Theme:** Removing tool anxiety  
**Video (~34 min):**
- `32:00 → ~45:00`

**Practice:**
- Install Terraform
- Configure AWS credentials
- Run `terraform init`

**Rule:**
AWS is a **dependency**, not the subject.

**Daily Test:**
> What actually happens during `terraform init`?

---

### 🔹 DAY 4 — Plan, Apply, Destroy
**Theme:** Predictability loop  
**Video (~33 min):**
- `45:00 → ~58:00`

**Focus:**
- Why `plan` exists
- Diff-based thinking
- Apply conservatism
- Destroy as a constraint

**Daily Test:**
> Why is `plan` more important than `apply`?

---

### 🔹 DAY 5 — Terraform State (Core Day)
**Theme:** Terraform’s memory  
**Video (~32 min):**
- `58:00 → ~1:10:00`

**Focus:**
- State as source of truth
- Drift
- Why state ≠ infrastructure
- Why losing state is catastrophic

**Daily Test:**
> What breaks if Terraform state is lost?

---

### 🔹 DAY 6 — Variables & Outputs
**Theme:** Flexibility through separation  
**Video (~34 min):**
- `1:10:00 → ~1:24:00`

**Focus:**
- Variables vs runtime config
- Outputs as contracts
- Immutability mindset

**Daily Test:**
> Why is parameterization essential for scaling Terraform?

---

### 🔹 DAY 7 — HCL Language Depth
**Theme:** Reading Terraform fluently  
**Video (~33 min):**
- `1:24:00 → ~1:37:00`

**Focus:**
- Expressions
- Conditionals
- for_each vs count
- Avoiding clever code

---

### 🔹 DAY 8 — Modules
**Theme:** Organization boundary  
**Video (~34 min):**
- `1:37:00 → ~1:51:00`

**Focus:**
- Inputs/outputs
- Module boundaries
- When modules help
- When modules hurt

**Daily Test:**
> When should you *not* create a module?

---

### 🔹 DAY 9 — Environments & Testing
**Theme:** Safety at scale  
**Video (~33 min):**
- `1:51:00 → ~2:03:30`
- `2:03:30 → ~2:07:00`

**Focus:**
- Workspaces vs subdirectories
- Testing mental models
- Validation vs verification

---

### 🔹 DAY 10 — Team Workflows & CI Context
**Theme:** Terraform in real teams  
**Video (~34 min):**
- `2:07:00 → End`

**Focus:**
- PR-based Terraform
- Review & approval flows
- CI as guardrail, not executor

---

## 📆 DAYS 11–14 — CONSOLIDATION & PRACTICE (NO NEW VIDEOS)

### 🔹 Re-Explain Terraform
- Explain Terraform from scratch (no commands)
- Redraw lifecycle
- Identify weak mental links

### 🔹 Mini Terraform Builds
- Very small infra examples
- Focus on predict → plan → observe
- No “full projects”

### 🔹 Reflection & Lock-In
- Write full Phase-2 reflection
- Decide next focus:
  - Deeper Terraform
  - Cloud architecture
  - CI/CD
  - Real project

---

## 🏁 SUCCESS CRITERIA

Phase 2 is complete **only if**:

- Terraform feels boring and predictable
- State is no longer scary
- You can explain Terraform to someone else
- You trust yourself to use Terraform in a real project

---