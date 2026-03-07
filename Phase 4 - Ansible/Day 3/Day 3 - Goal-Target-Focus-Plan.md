# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 3 — Real Automation

Day 3 was originally scheduled for March 8.

However, Day 2 was completed earlier than expected and there was additional free time available so day 3 is being completed on **March 7**.

Estimated Time: ~5 hours

---

# Goal

Move from basic server configuration to **real application deployment automation** using Ansible.

By the end of today I should be able to:

* deploy a Docker container using Ansible
* understand idempotent automation behavior
* introduce variables in playbooks
* make playbooks reusable
* automate application deployment

This step moves from **server setup → application deployment**.

---

# Target

By the end of Day 3 I will have:
```
✔ A playbook that deploys a Docker container
✔ A running container on the EC2 server
✔ A public service exposed through a port
✔ Variables introduced into the playbook
✔ An understanding of idempotency
```
Command that should work:

```bash
ansible-playbook -i inventory deploy.yml
```

Result:

```
Application container running on EC2
```

This proves that Ansible can **fully automate application deployment**.

---

# Focus

Today’s focus is understanding **real infrastructure automation behavior**.

Key ideas to understand:

---

## 1. Docker Deployment Automation

Instead of running manual commands like:

```bash
docker pull nginx
docker run -d -p 80:80 nginx
```

Ansible will automate this using modules.

Automation tasks:

```
Pull Docker image
Run container
Expose ports
Ensure container is running
```

---

## 2. Idempotency

Idempotency means:

Running the same playbook multiple times **should not break anything**.

Example:

First run:

```
Docker container created
```

Second run:

```
No changes required
```

Ansible detects the desired state already exists.

This is a fundamental concept in configuration management.

---

## 3. Playbook Variables

Variables make playbooks reusable.

Instead of hardcoding values like:

```yaml
image: nginx
port: 80
```

We define variables:

```yaml
image_name
container_port
app_port
```

This allows the same playbook to deploy different applications.

---

# Plan

## Part 1 — Deploy Docker Container (~2 hours)

Create a new playbook:

```bash
deploy.yml
```

Tasks:

```
pull nginx image
run docker container
map port 80
ensure container is running
```

Result:

```
EC2 instance running a containerized application
```

---

## Part 2 — Test Idempotency (~1 hour)

Run the playbook multiple times:

```bash
ansible-playbook -i inventory deploy.yml
```

Observe output:

```
ok
changed
skipped
```

Goal:

Understand how Ansible determines whether changes are required.

---

## Part 3 — Introduce Variables (~2 hours)

Refactor the playbook to include variables.

Example:

```yaml
image_name: nginx
container_port: 80
host_port: 80
```

Benefits:

* playbook becomes reusable
* configuration becomes easier to modify
* automation becomes scalable

---

# Expected Architecture After Day 3

```
Laptop
↓
Ansible Playbook
↓
SSH
↓
EC2 Server
↓
Docker Container Running Application
```

Deployment now happens with:

```bash
ansible-playbook deploy.yml
```

---

# End-of-Day Success Criteria

Day 3 is successful if:
```
✔ Docker container runs on EC2
✔ Application port is exposed
✔ Playbook runs without errors
✔ Running the playbook again produces minimal changes
✔ Variables are introduced into the playbook
```
This confirms that Ansible can automate **both server setup and application deployment**.

---

# DevOps Stack Progress

Current stack:

```
Linux
Docker
Terraform
GitHub Actions
AWS
Ansible
```

Automation layers now look like:

```
Terraform → infrastructure
Ansible → server configuration
Docker → application runtime
GitHub Actions → pipeline automation
```

This is approaching a **complete DevOps workflow**.

---

# Next Phase Preview

Day 4 will focus on **professional Ansible structure**:

* roles
* modular playbooks
* production-grade directory layout
* real-world Ansible repository structure
