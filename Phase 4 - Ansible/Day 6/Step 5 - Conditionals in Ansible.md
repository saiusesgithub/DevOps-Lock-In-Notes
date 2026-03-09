# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 6 — Step 5

### Topic: Conditionals (when)

Date: March 9

Estimated Time: ~35 minutes

---

# Goal

Understand how to control task execution in Ansible using conditions.

After this step I should understand:

* what conditionals are
* how the `when` keyword works
* how to run tasks only under specific conditions
* how conditionals make automation smarter

---

# Concept

In many automation scenarios, tasks should only run **if certain conditions are met**.

Examples:

* install packages only on specific operating systems
* run tasks only if a file exists
* execute commands only if a service is missing
* skip steps when something is already configured

Without conditionals, automation would run **every task every time**, which is inefficient.

Conditionals allow tasks to run **only when required**.

---

# The `when` Keyword

Ansible uses the `when` keyword to define conditions.

Example:

```yaml
- name: Install nginx only on Debian systems
  apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"
```

Here the task executes only if the system belongs to the Debian OS family.

---

# Using System Facts

Ansible automatically gathers system information called facts.

Examples of useful facts:

```
ansible_os_family
ansible_distribution
ansible_hostname
ansible_memtotal_mb
ansible_processor_vcpus
```

These facts can be used in conditions.

Example:

```yaml
when: ansible_distribution == "Ubuntu"
```

This ensures the task runs only on Ubuntu servers.

---

# Example Playbook

Create:

```
conditional-test.yml
```

Example:

```yaml
- hosts: web
  become: true

  tasks:

    - name: Install nginx if OS is Debian
      apt:
        name: nginx
        state: present
      when: ansible_os_family == "Debian"
```

If the server is Debian-based (Ubuntu, etc.), the task runs.

If not, Ansible skips the task.

---

# Multiple Conditions

Ansible allows combining conditions.

Example:

```yaml
when:
  - ansible_os_family == "Debian"
  - ansible_processor_vcpus >= 2
```

This runs the task only when both conditions are satisfied.

---

# Using Logical Operators

You can use logical operators like:

```
and
or
not
```

Example:

```yaml
when: ansible_distribution == "Ubuntu" and ansible_memtotal_mb > 1024
```

Meaning:

Run only if the server is Ubuntu and has more than 1GB RAM.

---

# Skipping Tasks

When a condition is false, Ansible shows:

```
skipping: [server]
```

This indicates the task was intentionally skipped.

---

# Why Conditionals Matter in DevOps

Conditionals make automation adaptable across different environments.

Example infrastructure:

```
Dev server → small instance
Production server → large instance
```

Tasks may behave differently depending on system properties.

Conditionals allow the same playbook to work across many environments.

---

# Hands-On Task

Create a test playbook.

Create file:

```
conditional-test.yml
```

Add example playbook above.

Run:

```bash
ansible-playbook -i inventory conditional-test.yml
```

Observe task execution.

If conditions match → task runs.

If conditions fail → task is skipped.

---

# Mental Model

Conditionals add decision-making ability to automation.

Instead of blindly executing every task:

```
Run task
Run task
Run task
```

Ansible evaluates conditions:

```
Check system state
If condition true → run task
If condition false → skip task
```

---

# Key Takeaways

Conditionals allow:

* smarter automation
* environment-aware deployments
* reusable playbooks
* safer infrastructure management

This is a critical feature for writing flexible Ansible automation.
