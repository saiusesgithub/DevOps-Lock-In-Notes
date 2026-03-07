# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 3 — Step 2

### Understanding Idempotency

Originally Planned: March 8

Actual Execution: March 7 2026

Day 3 is being completed earlier due to available time after finishing Day 2.

---

# Goal

Understand the concept of **idempotency**, one of the most important principles in configuration management and infrastructure automation.

By the end of this step I should understand:

* what idempotency means
* why it is critical in DevOps automation
* how Ansible ensures idempotent operations
* how to observe idempotent behavior during playbook execution

---

# 1. What is Idempotency?

Idempotency means:

Running the same operation **multiple times produces the same final result**.

In automation systems this means:

Running a playbook again **does not break the system or duplicate resources**.

---

# Example Concept

Imagine installing Docker.

Manual command:

```bash
sudo apt install docker.io
```

If Docker is already installed, the command still runs.

But an automation tool should detect:

```
Docker is already installed
```

So no change is needed.

---

# 2. Idempotency in Ansible

Ansible modules are designed to be **idempotent**.

This means a module checks the system state before making changes.

Example task:

```yaml
- name: Install Docker
  apt:
    name: docker.io
    state: present
```

Meaning:

```
Ensure Docker is installed
```

Ansible checks:

```
Is Docker installed?
```

If not:

```
Install Docker
```

If already installed:

```
Do nothing
```

---

# 3. Example with Docker Container

Example playbook task:

```yaml
- name: Run nginx container
  docker_container:
    name: nginx_container
    image: nginx
    state: started
```

First run:

```
Container does not exist
```

Result:

```
Container created
```

Second run:

```
Container already running
```

Result:

```
No change required
```

---

# 4. Observing Idempotency

Run your deployment playbook.

```bash
ansible-playbook -i inventory deploy.yml
```

First execution might show:

```
changed=1
```

Example output:

```text
TASK [Run nginx container]
changed: [ansible_practice_ec2]
```

Run the playbook again

```bash
ansible-playbook -i inventory deploy.yml
```

Expected output:

```
ok=1
changed=0
```

Example:

```text
TASK [Run nginx container]
ok: [ansible_practice_ec2]
```

---

# Understanding Output Status

Ansible task output shows the system state.

| Status  | Meaning                         |
| ------- | ------------------------------- |
| ok      | system already in desired state |
| changed | modification applied            |
| skipped | task intentionally skipped      |
| failed  | task failed                     |

Example recap:

```text
PLAY RECAP
ansible_practice_ec2 : ok=1 changed=0 failed=0
```

This confirms idempotent automation behavior.

---

# 5. Why Idempotency Matters

Without idempotency, automation would be dangerous.

Example problems without idempotency:

```
duplicate containers
repeated installations
broken configurations
unpredictable systems
```

Idempotency ensures automation remains safe and predictable.

---

# 6. Idempotency Across DevOps Tools

This principle exists across many DevOps tools.

Examples:

```
Ansible → idempotent modules
Terraform → desired state infrastructure
Kubernetes → declarative system state
```

All of these tools operate on the idea of:

```
Define desired state
System converges to that state
```

---

# 7. Mental Model

Think of automation as state enforcement.

Example desired state:

```
Docker installed
Container running
Port exposed
```

Automation tools continuously ensure the system matches that state.

---

# Example State Enforcement

Desired state:

```
Nginx container running
```

Automation checks:

```
Is container running?
```

If not:

```
Start container
```

If yes:

```
No action required
```

---

# 8. Key Takeaway

Idempotency allows automation to be re-run safely at any time.

This makes infrastructure automation:

* predictable
* reliable
* repeatable
* scalable

Without idempotency, infrastructure automation would not be safe.

---

# End-of-Step Success Criteria

Step 2 is successful if:
```
✔ Running the playbook once deploys the container
✔ Running the playbook again produces no changes
✔ Output shows changed=0 on second execution
✔ System remains stable
```
---

# Next Step

Day 3 — Step 3

Introduce variables in playbooks to make automation reusable and configurable
