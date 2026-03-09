# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 6 — Step 3

### Topic: Templates (Jinja2)

Date: March 9

Estimated Time: ~60 minutes

---

# Goal

Understand how Ansible templates work and how they are used to generate configuration files dynamically.

After this step I should understand:

* what Jinja2 templates are
* how Ansible renders templates
* how variables are injected into configuration files
* why templates are used in real DevOps automation

---

# Concept

Many infrastructure systems require configuration files.

Examples:

```
nginx
application configs
environment files
systemd service files
```

Normally these files contain values like:

```
ports
domain names
container names
environment variables
```

Instead of copying static configuration files, Ansible generates them dynamically using **templates**.

Templates use **Jinja2 syntax**.

---

# What is Jinja2?

Jinja2 is a templating language used by Ansible.

It allows variables to be inserted into files.

Example:

```text
{{ variable_name }}
```

During execution Ansible replaces the variable with its value.

---

# Example Template

Create folder:

```bash
templates/
```

Create file:

```bash
templates/test.conf.j2
```

Example template:

```text
server {
    listen {{ host_port }};
    server_name example.com;

    location / {
        proxy_pass http://localhost:{{ container_port }};
    }
}
```

Here the variables are:

```
{{ host_port }}
{{ container_port }}
```

These values come from variables defined in:

```
group_vars
playbook vars
host_vars
```

---

# Template Module

Ansible uses the template module to render templates.

Example playbook task:

```yaml
- name: Deploy configuration file
  template:
    src: templates/test.conf.j2
    dest: /tmp/test.conf
```

What happens:

```
Ansible reads the template
Variables are replaced with actual values
The rendered file is copied to the server
```

---

# Example Variable Source

Example file:

```
group_vars/web.yml
```

Example variables:

```yaml
host_port: 80
container_port: 80
```

Rendered output becomes:

```text
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:80;
    }
}
```

---

# Why Templates Matter in DevOps

Templates allow one automation system to support many environments.

Example:

```
Dev
Staging
Production
```

Instead of writing three different configuration files, we use one template.

Only variables change.

Example:

Dev:

```yaml
host_port: 3000
```

Production:

```yaml
host_port: 80
```

The same template generates different outputs.

---

# Directory Structure

Typical Ansible structure:

```
ansible/
│
├── inventory
│
├── group_vars
│     └── web.yml
│
├── templates
│     └── test.conf.j2
│
├── playbooks
│     └── template-test.yml
│
└── roles
```

---

# Hands-On Task

1️⃣ Create templates folder:

```bash
templates/
```

2️⃣ Create template:

```bash
templates/test.conf.j2
```

Example content:

```text
Server running on port {{ host_port }}
Container port is {{ container_port }}
```

3️⃣ Create playbook:

```bash
template-test.yml
```

Example:

```yaml
- hosts: web
  become: true

  tasks:

    - name: Render template
      template:
        src: templates/test.conf.j2
        dest: /tmp/test.conf
```

4️⃣ Run playbook:

```bash
ansible-playbook -i inventory template-test.yml
```

5️⃣ SSH into server and verify file:

```bash
cat /tmp/test.conf
```

Expected output:

```text
Server running on port 80
Container port is 80
```

---

# Mental Model

Think of templates as:

```
dynamic configuration generators
```

Instead of storing static files, Ansible creates configuration files based on variables.

This is extremely useful for:

```
web servers
application configs
container configs
environment variables
```

---

# Key Takeaways

Templates allow:

```
dynamic configuration generation
environment-specific configuration
reusable infrastructure automation
scalable DevOps systems
```

Most real-world Ansible projects rely heavily on templates.




---

## Jinja Templates — What actually happens

Think of a template as a configuration file with placeholders.

## Example template file

**Jinja**

```
templates/app.conf.j2
```

**Plain text**

```
Application running on port {{ port }}
Environment: {{ env }}
```

These `{{ }}` are variables placeholders.

Variables come from somewhere.

## Example `group_vars/web.yml`

**YAML**

```yaml
port: 80
env: production
```

## When Ansible runs the template task

Playbook task:

**YAML**

```yaml
* name: Create config file
  template:
  src: templates/app.conf.j2
  dest: /tmp/app.conf
```

Ansible does this internally:

### Step 1 — Read template

```
Application running on port {{ port }}
Environment: {{ env }}
```

### Step 2 — Replace variables

```
Application running on port 80
Environment: production
```

### Step 3 — Write final file to server

```
/tmp/app.conf
```

## So template =

```
template file + variables
↓
Ansible renders final config
```

## This is used everywhere in DevOps

```
nginx configs
docker compose files
.env files
systemd services
```
