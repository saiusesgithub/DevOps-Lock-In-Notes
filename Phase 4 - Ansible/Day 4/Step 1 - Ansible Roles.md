# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 4 — Step 1

### Understanding Ansible Roles

Originally Planned: March 9 

Actual Execution: March 7 2026

---

# Goal

Understand what Ansible roles are and why they are used in professional infrastructure automation.

By the end of this step I should understand:

* what an Ansible role is
* why roles exist
* how roles organize automation
* the standard role directory structure
* how roles improve scalability of playbooks

---

# 1. The Problem with Large Playbooks

When learning Ansible, playbooks usually contain all tasks directly.

Example:

```yaml
- hosts: web
  become: true

  tasks:

    - install docker
    - start docker
    - deploy nginx container
    - configure firewall
    - configure logging
```

This works for small environments.

But real infrastructure may require:
```
Docker installation
Application deployment
Database setup
Monitoring tools
Security configuration
Networking configuration
```
A single playbook could grow to hundreds of tasks, making it difficult to manage.


# 2. Solution: Roles

Roles provide a way to organize automation into reusable modules.

Instead of writing everything in one playbook, tasks are separated into roles.

Example idea:
```
Role: docker
Role: application
Role: monitoring
Role: database
```
Each role manages a specific part of infrastructure.

# 3. Conceptual Example

Without roles:
```
deploy.yml
```
Contains everything:
```
install docker
configure docker
deploy container
configure application
configure networking
```
With roles:
```
roles/

docker/
application/
monitoring/
database/
```
Each role contains only tasks related to its purpose.

# 4. Role Execution Model

The playbook becomes much simpler.

Example:

```yaml
- hosts: web
  become: true

  roles:
    - docker
    - deploy
```

Execution flow:
```
Playbook
↓
Role: docker
↓
Role: deploy
```
Each role runs its own tasks.

5. Standard Role Structure

Ansible roles follow a standard directory layout.

Example:
```
roles/

docker/

tasks/
main.yml

handlers/
defaults/
vars/
files/
templates/
meta/
```
Explanation:
```
Directory	               Purpose
tasks	                   main automation tasks
handlers	               service restarts
defaults	               default variables
vars	                   role-specific variables
files	                   static files
templates                  configuration templates
meta	                   role metadata
```
For this project we will initially use:
```
tasks/main.yml
```

# 6. Example Role

Example role for Docker installation.

Directory:
```
roles/docker/tasks/main.yml
```
Contents:
```
install docker
start docker
enable docker service
```
The playbook simply calls the role.

# 7. Benefits of Roles

Roles provide several advantages.

### Modularity

Automation is separated into logical components.

Example:
```
docker role
deploy role
monitoring role
```

### Reusability

Roles can be reused across projects.

Example:

same docker role used in multiple projects

### Maintainability

Changes can be made inside the role without modifying playbooks.

### Scalability

Large infrastructure automation becomes manageable.

# 8. Real DevOps Example

Production infrastructure might contain roles like:
```
docker
nginx
postgres
redis
application
monitoring
security
```
Each role manages one service.

The playbook orchestrates them.

# 9. Mental Model

Think of roles as modules for infrastructure automation.

Example comparison:
```
Programming

functions
modules
packages
```
```
Equivalent in Ansible:

tasks
roles
playbooks
```
Roles provide structure similar to software architecture.

Key Takeaway

Roles allow infrastructure automation to be:
```
modular
reusable
maintainable
scalable
```

Instead of large monolithic playbooks, automation becomes organized into components.

End-of-Step Success Criteria

Step 1 is successful if I understand:

✔ why roles exist
✔ how roles organize automation
✔ the basic role directory structure
✔ how playbooks call roles
