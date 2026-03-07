# DevOps Lock-In Phase 4

## Configuration Management — Ansible

#### Date : 07/03/2026

## Day 2 — Step 3

### First Playbook (Automating Server Setup)

---

# Goal

Create and execute the first Ansible playbook to automate server configuration.

By the end of this step I should be able to:

* understand the structure of an Ansible playbook
* define tasks in YAML
* execute a playbook
* automate server configuration
* install Docker on EC2 automatically

This replaces manual server setup commands.

---

# 1. What is a Playbook?

A playbook is a **YAML file that defines automation tasks**.

Instead of running commands manually like:

```bash
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
```

We define these steps in code.

Example idea:

```
Install Docker
Start Docker service
Enable Docker on boot
```

Then run the playbook once.

---

# 2. Playbook Structure

Basic structure:

```
Playbook
├ hosts
├ become
└ tasks
```

Explanation:

| Field  | Purpose                  |
| ------ | ------------------------ |
| hosts  | target servers           |
| become | run tasks with sudo      |
| tasks  | list of automation steps |

---

# 3. Create First Playbook

Create a file:

```bash
setup.yml
```

Example structure:

```yaml
hosts: web
become: true

tasks:

- name: Update apt packages
  apt:
    update_cache: yes

- name: Install Docker
  apt:
    name: docker.io
    state: present

- name: Start Docker service
  service:
    name: docker
    state: started
```

Explanation:

### hosts

```yaml
hosts: web
```

Targets servers in the **web group from inventory**.

---

### become

```yaml
become: true
```

Runs commands with **sudo privileges**.

Most server configuration requires root access.

---

### tasks

Tasks define the actual automation steps.

Example tasks:

```
update package cache
install docker
start docker service
```

Each task uses an **Ansible module**.

---

# 4. Modules Used

### apt module

Used for installing packages on Ubuntu/Debian.

Example:

```yaml
apt:
  name: docker.io
  state: present
```

Meaning:

Ensure Docker is installed.

---

### service module

Used for controlling system services.

Example:

```yaml
service:
  name: docker
  state: started
```

Meaning:

Start the Docker service.

---

# 5. Run the Playbook

Execute the playbook using:

```bash
ansible-playbook -i inventory setup.yml
```

Explanation:

| Command Part     | Meaning        |
| ---------------- | -------------- |
| ansible-playbook | run playbook   |
| -i inventory     | inventory file |
| setup.yml        | playbook file  |

---

# 6. Expected Execution Flow

When the playbook runs:

```
Control Machine
↓
Ansible reads playbook
↓
Read inventory
↓
SSH to EC2
↓
Execute tasks sequentially
↓
Return results
```

Tasks run in order.

Example:

```
Task 1 → update packages
Task 2 → install docker
Task 3 → start docker
```

---

# 7. Example Output

You should see something like:

```bash
TASK [Update apt packages]
changed: [ansible_practice_ec2]

TASK [Install Docker]
changed: [ansible_practice_ec2]

TASK [Start Docker service]
changed: [ansible_practice_ec2]

PLAY RECAP
ansible_practice_ec2 : ok=3 changed=3 unreachable=0 failed=0
```

---

# 8. Verify Installation

After the playbook finishes, verify Docker.

SSH into EC2:

```bash
ssh -i ~/ansible-practice-ec2-key.pem ubuntu@18.60.153.2
```

Run:

```bash
docker --version
```

Expected result:

```bash
Docker version XX.X.X
```

---

# 9. Why This Step Matters

This step proves that Ansible can automate server setup.

Before:

```
SSH → run commands manually
```

Now:

```bash
ansible-playbook setup.yml
```

Automation replaces manual work.

---

# 10. Infrastructure Automation Stack

Your DevOps stack now looks like:

```
Terraform → create infrastructure
Ansible → configure servers
Docker → run applications
GitHub Actions → automate pipeline
```

Each tool solves a different layer of automation.

---

# End-of-Step Success Criteria

Step 3 is successful if:
```
✔ Playbook runs without errors
✔ Docker installs automatically
✔ Docker service starts successfully
✔ Docker version can be verified on EC2
```
This confirms that Ansible can **fully configure servers automatically**.

---

# What Happens Next

Day 3 will introduce:

* Docker container deployment
* playbook variables
* idempotency
* application automation

You will go from **server setup → full application deployment**.

---

# Playbook YAML Structure Error

## Problem

When running the playbook:

```bash
ansible-playbook -i inventory setup.yml
```

Ansible produced the error:

```text
ERROR! A playbook must be a list of plays, got a <class 'ansible.parsing.yaml.objects.AnsibleMapping'> instead
```

The error also pointed to the first line of the playbook:

```yaml
hosts: web
```

```
^ here
```

---

## Cause

Ansible playbooks must be written as a **list of plays**.

In YAML, lists start with a dash (`-`).

The playbook was written as a dictionary instead of a list.

Incorrect structure:

```yaml
hosts: web
become: true
tasks:
```

Because the dash was missing, Ansible could not interpret the playbook correctly.

---

## Fix

Add a dash (`-`) before `hosts` to indicate the first play.

Correct structure:

```yaml
- hosts: web
  become: true

  tasks:
```

---

## Explanation

Ansible playbooks are structured as:

```
Playbook
 ├ Play 1
 ├ Play 2
 └ Play 3
```

Because multiple plays are allowed, the playbook must begin with a list item.

Example:

```yaml
- hosts: web
  tasks:
    ...

- hosts: db
  tasks:
    ...
```

The dash (`-`) represents a play inside the playbook list.

---

## Lesson Learned

If Ansible reports:

```
A playbook must be a list of plays
```

Check that the playbook starts with:

```yaml
- hosts:
```

and not just:

```yaml
hosts:
```
---

```bash
ansible-playbook --syntax-check setup.yml
```