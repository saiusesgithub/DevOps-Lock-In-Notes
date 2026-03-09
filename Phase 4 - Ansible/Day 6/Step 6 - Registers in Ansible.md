# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 6 — Step 6

### Topic: Registers

Date: March 9

Estimated Time: ~40 minutes

---

# Goal

Understand how Ansible captures task results using **register variables** and how those results can be used in later tasks.

After this step I should understand:

* what registers are
* how to capture command output
* how to access registered values
* how registers enable smarter automation

---

# Concept

Sometimes automation needs to **check system state before making decisions**.

Examples:

* check if Docker is installed
* check if a container is running
* check service status
* check file existence

To do this, Ansible must **capture task output**.

This is done using **register**.

---

# Register Keyword

The `register` keyword stores the output of a task into a variable.

Example:

```yaml
- name: Check docker version
  command: docker --version
  register: docker_output
```

Now the variable:

```
docker_output
```

contains the result of that command.

---

# Structure of Registered Output

A registered variable contains multiple fields.

Example structure:

```
docker_output
│
├── stdout
├── stderr
├── rc
├── changed
└── failed
```

Important fields:

```
stdout  → command output
stderr  → error output
rc      → return code
```

---

# Printing Registered Output

To see the captured result we use the debug module.

Example:

```yaml
- name: Print docker version
  debug:
    var: docker_output.stdout
```

This prints the command output.

Example result:

```
Docker version 24.0.2
```

---

# Example Playbook

Create:

```
register-test.yml
```

Example:

```yaml
- hosts: web
  become: true

  tasks:

    - name: Check docker version
      command: docker --version
      register: docker_output

    - name: Print docker version
      debug:
        var: docker_output.stdout
```

---

# Execution Flow

Step 1:

```
Run docker --version
```

Step 2:

```
Store output in docker_output
```

Step 3:

```
Print docker_output.stdout
```

---

# Using Registers with Conditionals

Registers are often combined with `when`.

Example:

```yaml
- name: Check if docker exists
  command: docker --version
  register: docker_check
  ignore_errors: yes
```

Next task:

```yaml
- name: Install docker if missing
  apt:
    name: docker.io
    state: present
  when: docker_check.failed
```

Flow:

```
Check docker
     ↓
If command fails → install docker
If command works → skip installation
```

This makes automation intelligent.

---

# Example Output Fields

Common fields inside a register variable:

```
docker_check.stdout
docker_check.stderr
docker_check.rc
docker_check.changed
docker_check.failed
```

These allow playbooks to make decisions based on system state.

---

# Hands-On Task

Create a test playbook.

1️⃣ Create file:

```
register-test.yml
```

2️⃣ Add example playbook above.

3️⃣ Run:

```bash
ansible-playbook -i inventory register-test.yml
```

4️⃣ Observe output printed by the debug module.

---

# Mental Model

Registers allow Ansible to remember task results.

Instead of running tasks blindly:

```
Run task
Run task
Run task
```

Ansible can now evaluate system state:

```
Check system
Store result
Make decision
Execute task
```

This makes automation state-aware.

---

# Key Takeaways

Registers allow:

* capturing command output
* decision-making automation
* conditional execution
* intelligent infrastructure management

Registers are heavily used in advanced Ansible automation.

---
