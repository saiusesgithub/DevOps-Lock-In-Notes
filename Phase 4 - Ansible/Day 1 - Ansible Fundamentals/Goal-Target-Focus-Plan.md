# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 1 — Ansible Fundamentals

**Date:** March 6
**Duration:** ~2 hours

---

# Goal

Build a clear mental model of **Configuration Management** and understand **what problem Ansible solves in DevOps systems**.

By the end of today, I should understand:

* Why configuration management exists
* How Ansible works internally
* The difference between **Terraform vs Ansible vs Docker**
* How Ansible communicates with servers
* Basic Ansible command usage

Today is about **conceptual clarity**, not full automation.

---

# Target

By the end of today I will be able to:

• Explain what configuration management is

• Explain why manual server setup is a problem

• Explain how Ansible solves it

• Understand the concepts of:

* Control Node
* Managed Nodes
* Inventory
* Modules
* Playbooks
* Tasks
* Idempotency

I will also have:

* Ansible installed on my machine
* Verified installation
* Executed basic Ansible commands

---

# Focus

Today's focus is **mental models**, not complexity.

Key ideas to understand deeply:

### 1. Configuration Management

Why servers cannot be configured manually at scale.

Example problem:

Manually configuring servers leads to:

* inconsistent environments
* human error
* impossible scaling
* no reproducibility

Configuration must be **defined as code**.

---

### 2. Ansible Architecture
```
Understand the workflow:

Control Machine
↓
Ansible
↓
SSH
↓
Managed Servers
```
Key concept:

Ansible is **agentless**.

Unlike tools like Puppet or Chef, Ansible **does not require software installed on servers**.

It uses **SSH + Python modules**.

---

### 3. DevOps Toolchain Position

Understand where Ansible fits.

Terraform → **Infrastructure provisioning**

Ansible → **Server configuration**

Docker → **Application packaging**

Example flow:

Terraform creates EC2

Ansible installs Docker

Docker runs the application

---

# Plan

## Part 1 — Learn Core Concepts (≈60 minutes)

Study and understand:

* Configuration management
* Why manual configuration fails
* What Ansible is
* Ansible architecture
* Agentless automation
* Idempotency
* Modules
* Playbooks
* Inventory

Goal:

Be able to **explain Ansible in simple terms**.

Example explanation:

"Ansible is a configuration management tool that automates server setup using SSH without requiring agents."

---

## Part 2 — Install Ansible (≈30 minutes)

Tasks:

Install Ansible on the control machine.

Verify installation.

Command:

ansible --version

Expected result:

Ansible version information printed successfully.

---

## Part 3 — First Ansible Commands (≈30 minutes)

Learn how Ansible executes modules.

Experiment with basic commands.

Examples:

ansible localhost -m ping

ansible localhost -m command -a "uptime"

ansible localhost -m shell -a "ls"

Goal:

Understand how Ansible runs **modules against hosts**.

---

# End-of-Day Success Criteria

Day 1 is successful if:

✔ I understand the purpose of configuration management

✔ I understand how Ansible works conceptually

✔ Ansible is installed and working

✔ I ran at least a few Ansible commands locally

No complex automation yet.

Tomorrow we will:

• Connect Ansible to EC2
• Create an inventory file
• Write the first real playbook
• Install Docker automatically on a server