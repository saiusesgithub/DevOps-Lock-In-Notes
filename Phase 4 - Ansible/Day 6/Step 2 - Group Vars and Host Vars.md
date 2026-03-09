# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 6 — Step 2

### Topic: group_vars and host_vars

Date: March 9

Estimated Time: ~45 minutes

---

# Goal

Understand how Ansible loads variables automatically from external files using:

* group_vars
* host_vars

After this step I should understand:

* why variables should not stay inside playbooks
* how Ansible automatically loads variables from folders
* how different environments can use different values

---

# Problem With Variables Inside Playbooks

In Step 1 we defined variables inside the playbook.

Example:

```yaml
vars:
  package_name: nginx
  host_port: 80
```

This works but is not ideal for real DevOps systems.

Problems:

```
playbooks become cluttered

environment configuration mixes with automation logic

difficult to manage multiple environments
```

Example scenario:

```
Dev → port 8080
Staging → port 3000
Production → port 80
```

If variables are inside playbooks, we must edit the playbook for each environment.

---

# Real DevOps Solution

Store variables in separate files.

Ansible automatically loads variables from:

```
group_vars/
host_vars/
```

This separates:

```
Automation Logic
Configuration Data
```

---

# group_vars

Used when multiple hosts share the same configuration.

Example inventory:

```
[web]
server1
server2
server3
```

Variables for the entire group go in:

```
group_vars/web.yml
```

Example file:

```yaml
package_name: nginx
host_port: 80
container_port: 80
```

Now every host in group web automatically receives these variables.

---

# host_vars

Used when a specific host needs unique values.

Example inventory:

```
[web]
server1
server2
```

Folder structure:

```
host_vars/
    server1.yml
```

Example:

```yaml
host_port: 8080
```

Now:

```
server1 → port 8080
server2 → default port
```

---

# Directory Structure

Example Ansible project layout:

```
ansible/
│
├── inventory
│
├── group_vars
│     └── web.yml
│
├── host_vars
│     └── server1.yml
│
├── playbooks
│     └── deploy.yml
│
└── roles
```

This is how real infrastructure automation repositories are structured.

---

# How Ansible Loads Variables

When running a playbook:

```bash
ansible-playbook deploy.yml
```

Ansible automatically checks:

```
group_vars/
host_vars/
```

And loads variables matching:

```
group name
host name
```

No extra configuration is required.

---

# Example Playbook Using group_vars

Playbook:

```yaml
- hosts: web
  become: true

  tasks:

    - name: Install package
      apt:
        name: "{{ package_name }}"
        state: present
```

Variables come from:

```
group_vars/web.yml
```

Ansible automatically replaces:

```
{{ package_name }}
```

with:

```
nginx
```

---

# Hands-On Task

1️⃣ Create directory:

```bash
group_vars
```

2️⃣ Create file:

```bash
group_vars/web.yml
```

Example content:

```yaml
package_name: nginx
host_port: 80
container_port: 80
```

3️⃣ Modify your test playbook to remove `vars:` section.

4️⃣ Run playbook again:

```bash
ansible-playbook -i inventory variable-test.yml
```

5️⃣ Confirm nginx installs correctly.

---

# Mental Model

Think of playbooks as:

```
Infrastructure logic
```

Think of group_vars / host_vars as:

```
Environment configuration
```

This separation makes infrastructure automation clean and scalable.

---

# Key Takeaways

group_vars allows:

```
shared configuration for host groups

environment configuration separation

cleaner playbooks

scalable automation
```

This is the standard method used in real Ansible repositories.
