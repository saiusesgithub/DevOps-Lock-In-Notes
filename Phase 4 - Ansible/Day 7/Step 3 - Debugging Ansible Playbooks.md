# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 7 — Step 3

### Topic: Debugging Ansible Playbooks

**Date:** March 10

**Estimated Time:** ~40 minutes

---

# Goal

Understand how to debug Ansible playbooks when tasks fail or behave unexpectedly.

After this step I should understand:

* how to inspect variables using debug
* how to increase Ansible verbosity
* how to inspect system facts
* how to diagnose automation failures

Debugging is a critical skill when working with infrastructure automation.

---

# Why Debugging Matters

Automation often fails because of:

* incorrect variables
* incorrect paths
* incorrect permissions
* unexpected system state
* wrong assumptions about server configuration

Without debugging tools it becomes difficult to understand what went wrong.

Ansible provides several built-in debugging methods.

---

# Method 1 — Debug Module

The **debug module** prints variables or messages during playbook execution.

## Example

```yaml
- name: Print variable value
  debug:
    var: container_port
```

This displays the variable value during execution.

### Example output

```
container_port: 80
```

---

## Printing Custom Messages

Debug can also print custom messages.

```yaml
- name: Print message
  debug:
    msg: "Docker installation step completed"
```

### Output

```
Docker installation step completed
```

This helps track playbook execution flow.

---

# Debugging Registered Variables

Registers capture command outputs.

```yaml
- name: Check docker version
  command: docker --version
  register: docker_output
```

Debug the output:

```yaml
- debug:
    var: docker_output.stdout
```

### Example result

```
Docker version 24.0.2
```

---

# Debugging System Facts

Ansible collects system information called **facts**.

To inspect them:

```yaml
- name: Print OS information
  debug:
    var: ansible_distribution
```

### Example output

```
Ubuntu
```

Another useful fact:

```yaml
- debug:
    var: ansible_processor_vcpus
```

This prints CPU count.

Facts help automation adapt to system environments.

---

# Method 2 — Verbose Execution

Ansible supports different verbosity levels.

## Command

```bash
ansible-playbook deploy.yml -v
```

## Levels

* `-v` → basic details
* `-vv` → more details
* `-vvv` → connection debugging
* `-vvvv` → full debug output

### Example

```bash
ansible-playbook deploy.yml -vv
```

This shows more detailed execution logs.

---

# Method 3 — Check Mode (Dry Run)

Check mode simulates playbook execution **without making changes**.

## Command

```bash
ansible-playbook deploy.yml --check
```

This allows you to see:

* what changes WOULD happen
* without modifying the system

This is extremely useful before production deployments.

---

# Method 4 — Task-by-Task Debugging

When debugging a failing playbook, it is useful to isolate tasks.

## Example workflow

* run playbook
* identify failing task
* debug variables
* rerun specific task

Tags can help run only specific sections.

### Example

```bash
ansible-playbook deploy.yml --tags docker
```

This runs only Docker-related tasks.

---

# Example Debug Playbook

Create file:

`debug-test.yml`

```yaml
- hosts: web
  become: true

  tasks:

    - name: Check docker version
      command: docker --version
      register: docker_output

    - name: Print docker output
      debug:
        var: docker_output.stdout

    - name: Print OS type
      debug:
        var: ansible_distribution
```

## Run

```bash
ansible-playbook -i inventory debug-test.yml
```

Observe printed outputs.

---

# Mental Model

Think of debugging as **observing automation state**.

Instead of guessing what happened:

* Check variables
* Inspect system facts
* Print command outputs
* Increase verbosity

This makes troubleshooting much easier.

---

# Key Takeaways

Ansible debugging tools include:

* debug module
* verbosity flags
* check mode
* inspecting registered variables
* inspecting system facts

These tools help diagnose automation issues and understand system behavior.