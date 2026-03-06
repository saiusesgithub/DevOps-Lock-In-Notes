# DevOps Lock-In Phase 4  
## Configuration Management — Ansible

## Day 1 — Step 1 Notes

#### Date : 06/03/2026

### Core Concepts

---

# 1. What is Configuration Management?

Configuration Management is the process of **automating the setup and maintenance of servers**.

It ensures that every server has:

- the same packages
- the same configuration
- the same services running
- the same application deployment

In simple terms:

Configuration management means **defining how a server should look and behave using code**.

---

# 2. The Problem With Manual Server Setup

Before configuration management tools existed, engineers configured servers manually.

Typical workflow:

```bash
ssh into server

sudo apt update
sudo apt install docker
sudo apt install nginx

git clone application
docker build
docker run
```

This approach creates several major problems.

---

## Problem 1 — Human Error

Manual setup leads to mistakes.

Example:

Server A:


Docker version: 24
Node version: 18


Server B:


Docker version: 20
Node version: 16


Now the application behaves differently across servers.

---

## Problem 2 — No Reproducibility

If a server crashes, rebuilding it becomes difficult.

You must remember:

- which packages were installed
- which versions were used
- which commands were executed

Often this knowledge lives only in someone's memory.

---

## Problem 3 — No Scalability

Manual configuration works for:


1 server


But becomes impossible for:


10 servers
100 servers
1000 servers


Running commands manually on each machine is inefficient and error-prone.

---

## Problem 4 — Configuration Drift

Over time servers slowly become different.

Example:

Server A receives updates.

Server B does not.

Now environments are inconsistent.

This is called **configuration drift**.

---

# 3. Solution: Configuration as Code

Modern DevOps solves this by defining server configuration in code.

Example idea:

```
Install Docker
Start Docker
Pull application image
Run container
```

Instead of typing commands manually, you write them in a **configuration file**.

Now deployment becomes:

```
run automation
```

The automation system executes everything consistently.

---

# 4. What is Ansible?

Ansible is a **configuration management and automation tool**.

It allows you to define server setup in **simple YAML files called playbooks**.

Example:

```
Install Docker
Start Docker service
Deploy container
```

All defined in code.

Then executed using:

```bash
ansible-playbook deploy.yml
```

---

# 5. Key Feature: Agentless Architecture

Many configuration tools require agents.

Example tools:

- Puppet
- Chef
- SaltStack

These tools require software installed on every server.

Architecture:

```
Controller
↓
Agent running on each server
```

This increases complexity.

---

## Ansible Approach

Ansible does **not require agents**.

It uses:


SSH


Architecture:

```
Control Machine
↓
Ansible
↓
SSH
↓
Managed Servers
```

Requirements on servers:


SSH
Python


That's it.

This makes Ansible extremely simple to deploy.

---

# 6. Control Node

The **control node** is the machine where Ansible runs.

Examples:

```
Your laptop
CI/CD server
GitHub Actions runner
```

This machine sends instructions to servers.

---

# 7. Managed Nodes

Managed nodes are the servers Ansible configures.

Examples:

```
EC2 instances
Virtual machines
On-premise servers
```

These machines receive instructions from the control node.

---

# 8. Inventory

The inventory file tells Ansible **which servers to manage**.

Example:

```
[web]
server1
server2
```

This allows you to run commands against groups of servers.

Example:

```bash
ansible web -m ping
```

Meaning:

Run the ping module on all servers in the web group.

---

# 9. Modules

Modules are the **building blocks of Ansible automation**.

Each module performs a specific task.

Examples:

```
apt
yum
service
docker_container
copy
git
file
user
```

Example:

```
install package
start service
create file
run command
```

Ansible modules are **idempotent**.

---

# 10. Idempotency

Idempotency means:

Running the same automation multiple times produces the **same result**.

Example task:


Install Docker


First run:


Docker installed


Second run:


Nothing changes


Ansible detects the desired state is already satisfied.

This makes automation **safe and predictable**.

---

# 11. Tasks

A task is a single action performed by Ansible.

Example tasks:

```
Install Docker
Start Docker service
Pull Docker image
Run container
```

Tasks are executed sequentially.

---

# 12. Playbooks

Playbooks are **YAML files that define automation workflows**.

Example structure:

```
Playbook
├ hosts
├ become
└ tasks
```

Example idea:

```
hosts: web_servers

tasks:

install docker

start docker

deploy application
```

Playbooks allow you to automate entire deployments.

---

# 13. DevOps Stack Mental Model

In modern DevOps systems, different tools solve different problems.


Terraform → Infrastructure provisioning

Ansible → Server configuration

Docker → Application packaging

GitHub Actions → Automation pipeline


Example flow:


Terraform creates EC2

Ansible installs Docker

Docker runs the application


Each tool focuses on a specific layer.

---

# Key Takeaway

Ansible is used to automate **server configuration**.

Instead of manually configuring machines, you define the configuration as code and execute it automatically.

This ensures:

- consistency
- reproducibility
- scalability
- reliability