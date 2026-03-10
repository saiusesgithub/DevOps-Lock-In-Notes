# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 7 — Step 4

### Topic: Ansible Execution Model

**Date:** March 10

**Estimated Time:** ~35 minutes

---

# Goal

Understand how Ansible executes tasks across multiple hosts and how parallel execution works.

After this step I should understand:

* how Ansible processes tasks
* how tasks run across multiple hosts
* how parallel execution works
* how Ansible scales to large infrastructures

---

# Concept

Ansible automation is executed **task by task across hosts**.

Example playbook:

* Task 1: Install Docker
* Task 2: Deploy container
* Task 3: Restart service

If we have multiple hosts:

* server1
* server2
* server3

Ansible does **not run the entire playbook on one host first**.

Instead, it runs **each task across all hosts before moving to the next task**.

---

# Execution Flow

Example:

```
Task 1 → server1
Task 1 → server2
Task 1 → server3
```

Then:

```
Task 2 → server1
Task 2 → server2
Task 2 → server3
```

Then:

```
Task 3 → server1
Task 3 → server2
Task 3 → server3
```

This is called **task-based execution**.

---

# Visual Flow

```
Task 1
├ server1
├ server2
└ server3

Task 2
├ server1
├ server2
└ server3
```

Ansible ensures **every host completes the task before moving forward**.

---

# Parallel Execution

By default Ansible runs tasks across hosts **in parallel**.

Default number of parallel hosts:

```
5
```

This means Ansible can manage **5 servers simultaneously**.

Example:

* server1
* server2
* server3
* server4
* server5

If there are more servers, they are processed in batches.

---

# Controlling Parallelism

Parallel execution can be controlled using **forks**.

Example:

```bash
ansible-playbook deploy.yml --forks 10
```

This allows Ansible to manage **10 servers at once**.

Forks define how many SSH connections run simultaneously.

---

# Serial Execution

Sometimes infrastructure updates should happen **one server at a time**.

Example scenario:

* Load balancer update
* Database migration
* Rolling deployments

For this we use **serial execution**.

Example:

```yaml
- hosts: web
  serial: 1
```

Execution becomes:

* server1 → complete all tasks
* server2 → complete all tasks
* server3 → complete all tasks

This prevents downtime during updates.

---

# Example Playbook With Serial

```yaml
- hosts: web
  serial: 1
  become: true

  tasks:

    - name: Install nginx
      apt:
        name: nginx
        state: present
```

This ensures servers are updated one at a time.

---

# Why This Matters

Large infrastructures may contain:

* 10 servers
* 50 servers
* 100 servers
* 1000 servers

Ansible’s execution model ensures automation runs efficiently across these systems.

Parallel execution speeds up deployment.

Serial execution ensures safe updates.

---

# Mental Model

Think of Ansible execution as:

**Task-focused automation**

Instead of finishing one host first:

* server1 → all tasks
* server2 → all tasks
* server3 → all tasks

Ansible runs tasks across hosts simultaneously.

This improves performance and consistency.

---

# Key Takeaways

Ansible execution model includes:

* task-by-task execution
* parallel execution across hosts
* configurable concurrency using forks
* serial execution for controlled updates

Understanding this model helps explain how Ansible scales to large infrastructures.
