# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 4 — Professional Structure

Day 4 was originally scheduled for March 9.

However, due to completing Day 3 earlier and having additional available time, Day 4 is being executed on **March 7 2026**

Estimated Time: ~2 hours

---

# Goal

Understand how professional Ansible projects are structured and convert the current playbook setup into a **modular, production-style Ansible layout**.

By the end of today I should understand:

* why roles exist
* how Ansible roles work
* how to structure an Ansible repository
* how large infrastructure automation projects are organized

This step transitions from:

learning scripts

to

production-style infrastructure automation

---

# Target

By the end of Day 4 I will have:
```
✔ Converted playbooks into roles
✔ Created a professional Ansible directory structure
✔ Separated configuration logic into modular components
✔ Understood how large Ansible projects are organized
```
Resulting project structure should resemble:
```
ansible/

inventory
ansible.cfg

playbooks/
deploy.yml

roles/
docker/
tasks/

deploy/
tasks/
```

This structure mirrors how **real DevOps repositories are organized**.

---

# Focus

Today's focus is **project organization and modular automation**.

Key ideas to understand:

---

## 1. Why Roles Exist

As infrastructure grows, playbooks become large.

Example problem:

Playbook with 100+ tasks
multiple services
multiple environments

This becomes difficult to maintain.

Roles solve this problem by organizing tasks into modules.

Example idea:
```
role: docker
role: nginx
role: application
role: database
```
Each role manages a specific part of the system.

---

## 2. Modular Infrastructure

Roles allow infrastructure automation to be modular.

Example structure:

docker role → installs Docker

deploy role → deploys application

monitoring role → installs monitoring tools

This makes automation reusable across projects.

---

## 3. Professional Repository Layout

Production Ansible projects follow a predictable structure.

Example:
```
ansible/

inventory
ansible.cfg

playbooks/

roles/
```
Benefits:

clear separation of responsibilities

modular infrastructure code

easier debugging

team collaboration

---

# Plan

## Part 1 — Understand Roles (~45 minutes)

Learn the standard Ansible role structure.

Example role:
```
roles/docker/

tasks/
handlers/
defaults/
vars/
```
For now we will only use:
```
tasks/
```
Roles allow automation logic to be separated from playbooks.

---

## Part 2 — Convert Playbook to Roles (~45 minutes)

Current playbook contains:
```
install docker
deploy container
```
We will separate this into roles.

Example:
```
roles/docker/
roles/deploy/
```
Each role manages a specific function.

---

## Part 3 — Restructure Ansible Project (~30 minutes)

Create a clean directory structure.

Example:
```
ansible/

inventory
ansible.cfg

playbooks/
deploy.yml

roles/

docker/
tasks/main.yml

deploy/
tasks/main.yml
```
Now the playbook simply calls roles.

Example idea:
```
roles:

docker

deploy
```
---

# Expected Architecture After Day 4
```
Control Machine
↓
Ansible Playbook
↓
Roles
↓
SSH
↓
EC2 Instance
↓
Docker Container Running Application
```
Automation becomes modular and maintainable.

---

# End-of-Day Success Criteria

Day 4 is successful if:

✔ Roles are created
✔ Tasks moved into role directories
✔ Playbook calls roles instead of tasks
✔ Project structure resembles production Ansible layout

---

# DevOps Stack Progress

Current stack:

Linux
Docker
Terraform
GitHub Actions
AWS
Ansible

Automation layers:

Terraform → infrastructure provisioning
Ansible → configuration management
Docker → application runtime
GitHub Actions → pipeline automation

At this point you are **very close to a complete DevOps workflow**.

---

# Next Phase

Day 5 will combine everything:

Terraform → create EC2
Ansible → configure server
Docker → deploy application
GitHub Actions → automate the pipeline

This will form a **complete infrastructure automation system**.
