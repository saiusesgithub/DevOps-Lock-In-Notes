# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 6 — Step 1

### Topic: Variables in Ansible

Date: March 9

Estimated Time: ~40 minutes

---

# Goal

Understand how variables work in Ansible and why they are important for writing reusable and maintainable automation.

After this step I should understand:

* why hardcoding values in playbooks is bad
* how to define variables in playbooks
* how to reference variables using Jinja2 syntax
* how variables make playbooks reusable

---

# Concept

In automation we should **avoid hardcoding values**.

Example of hardcoded automation:

```yaml
- name: Deploy container
  docker_container:
    name: portfolio
    image: saiusesdocker/portfolio:latest
    ports:
      - "80:80"
```

Problems with this approach:

```
difficult to reuse

difficult to maintain

environment changes require editing the playbook
```

Example problems:

```
Staging server → port 8080
Production server → port 80
```

If values are hardcoded, we must modify the playbook every time.

Instead we use variables.

---

# Variables in Ansible

Variables allow playbooks to be configurable.

Example:

```yaml
vars:
  container_name: portfolio
  image_name: saiusesdocker/portfolio:latest
  host_port: 80
  container_port: 80
```

Variables are referenced using Jinja2 syntax:

```
{{ variable_name }}
```

Example:

```yaml
docker_container:
  name: "{{ container_name }}"
  image: "{{ image_name }}"
```

---

# Example Playbook

Create a test playbook.

File:

```
variable-test.yml
```

Example:

```yaml
- hosts: web
  become: true

  vars:
    package_name: nginx

  tasks:

    - name: Install package using variable
      apt:
        name: "{{ package_name }}"
        state: present
```

---

# What Happens Here

Variable defined:

```
package_name = nginx
```

Used in task:

```yaml
name: "{{ package_name }}"
```

Ansible replaces the variable at runtime.

Actual command executed becomes:

```bash
apt install nginx
```

---

# Jinja2 Variable Syntax

All Ansible variables use Jinja2 expressions.

Syntax:

```
{{ variable }}
```

Examples:

```
{{ package_name }}
{{ host_port }}
{{ container_name }}
```

Jinja2 allows dynamic configuration generation.

---

# Why Variables Matter in DevOps

In real infrastructure automation:

Playbooks should work for:

```
dev
staging
production
```

Only variables should change.

Example:

```
image_name: portfolio-dev
image_name: portfolio-prod
```

The automation logic remains identical.

---

# Mental Model

Think of variables as parameters for infrastructure automation.

Instead of writing fixed instructions:

```
Install nginx
Run container on port 80
```

We write configurable automation:

```
Install {{ package_name }}
Run container on {{ host_port }}
```

This makes Ansible flexible and reusable.

---

# Hands-On Task

Create a small test playbook.

1️⃣ Create file:

```
variable-test.yml
```

2️⃣ Add the playbook example above.

3️⃣ Run:

```bash
ansible-playbook -i inventory variable-test.yml
```

4️⃣ Verify that nginx installs on the server.

---

# Key Takeaways

Variables allow:

```
reusable playbooks

environment-specific configuration

cleaner automation

easier maintenance
```

All advanced Ansible concepts rely on variables.
