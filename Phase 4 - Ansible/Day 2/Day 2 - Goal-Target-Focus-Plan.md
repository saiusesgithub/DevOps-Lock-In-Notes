# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 2 — Inventory + First Playbook

#### Date : 07/03/2026

#### Duration: ~5 hours

---

# Goal

Connect Ansible to a real server and execute the first automation playbook.

By the end of today, I should be able to:

* connect Ansible to an EC2 instance
* configure SSH authentication
* create an Ansible inventory file
* test connectivity using Ansible
* write and run my first playbook
* automatically install Docker on a server

Today is the first step toward **real infrastructure automation**.

---

# Target

By the end of Day 2 I will have:
```
✔ An EC2 instance running
✔ Ansible successfully connected via SSH
✔ A working inventory file
✔ A successful `ansible ping` test
✔ My first playbook created
✔ Docker installed automatically using Ansible
```
Command I should successfully run today:

```bash
ansible-playbook -i inventory setup.yml
```
Result:

Docker installed on EC2

This proves that Ansible can **control and configure real infrastructure**.

---

# Focus

Today’s focus is understanding **how Ansible interacts with real servers**.

Key ideas to understand deeply:

---

## 1. Inventory

An inventory file tells Ansible **which machines it should manage**.

Example:
```
[web]
portfolio_server ansible_host=EC2_IP
```
Concepts to understand:

* host groups
* host variables
* static inventory

---

## 2. SSH Authentication

Ansible communicates with servers using SSH.

Required parameters:
```
ansible_user
ansible_ssh_private_key_file
```
Example:
```
portfolio_server ansible_host=EC2_IP ansible_user=ubuntu ansible_ssh_private_key_file=key.pem
```
---

## 3. Playbooks

Playbooks are YAML files that define **automation tasks**.

Structure:
```
Play
├ hosts
├ become
└ tasks
```
Example tasks today:

* update packages
* install Docker
* start Docker service

---

# Plan

## Part 1 — Prepare Infrastructure (~60 minutes)

Tasks:

Launch an EC2 instance (Ubuntu preferred).

Requirements:

* Public IP
* SSH access
* Security group allowing SSH (port 22)

Verify access:
```bash
ssh -i key.pem ubuntu@EC2_IP
```
Goal:

Confirm that the server is reachable.

---

## Part 2 — Create Inventory (~45 minutes)

Create inventory file.

Example:
```
inventory
```
Content:
```
[web]
portfolio_server ansible_host=EC2_IP ansible_user=ubuntu ansible_ssh_private_key_file=key.pem
```
Test connection:
```bash
ansible web -i inventory -m ping
```
Expected result:

SUCCESS

Goal:

Ansible successfully connects to EC2.

---

## Part 3 — First Playbook (~2 hours)

Create playbook:
```
setup.yml
```
Structure:
```yaml
hosts: web
become: true
tasks:

update packages

install docker

start docker
```
Run playbook:
```bash
ansible-playbook -i inventory setup.yml
```
Expected result:

Docker installed automatically.

---

## Part 4 — Verify Automation (~1 hour)

SSH into EC2 and verify:
```bash
docker --version
```
Expected:

Docker installed successfully.

---

# End-of-Day Success Criteria

Day 2 is successful if:

✔ Ansible connects to EC2
✔ `ansible ping` works
✔ A playbook runs successfully
✔ Docker installs automatically

This proves **Ansible automation works**.

---

# Tomorrow Preview

Day 3 will introduce **real application deployment**.

Tasks tomorrow:

* deploy Docker container using Ansible
* introduce playbook variables
* understand idempotency
* automate full application deployment

By tomorrow your **portfolio website can deploy automatically using Ansible**.
