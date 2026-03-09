# DevOps Lock-In Phase 4

## Advanced Ansible

## Day 6 — Production-Style Ansible Patterns

Date - 09/03/2026

Estimated Time: ~4–5 hours

---

# Goal

Move beyond Ansible fundamentals and understand how Ansible is used in **real DevOps repositories and production-style automation**.

By the end of today I should understand:

- how Ansible variables are structured in real projects
- how `group_vars` and `host_vars` work
- how Jinja2 templates are used to generate configuration files
- how handlers restart services only when needed
- how conditionals and registers make automation smarter
- how advanced Ansible projects are organized


This step transitions from:

```
basic playbooks
```

to

```
production-style configuration automation
```

---

# Target

By the end of Day 9 I will have learned and practiced:
```
✔ Variables in playbooks
✔ `group_vars` / `host_vars`
✔ Templates using Jinja2
✔ Handlers
✔ Conditionals
✔ Registers
```
I should also be able to explain how these pieces work together in a real Ansible workflow.

---

# Focus

Today’s focus is **real-world Ansible patterns**, not just single-file playbooks.

Key ideas to understand:

---

## 1. Variables

Playbooks should avoid hardcoded values.

Instead of:

```yaml
ports:
  - "80:80"
```

Use variables like:

```yaml
host_port: 80
container_port: 80
```

This makes playbooks reusable.

---

## 2. group_vars / host_vars

In real Ansible projects, variables are stored outside the playbook.

Example:

```
group_vars/web.yml
```

This allows environment-specific values without editing automation logic.

---

## 3. Templates

Templates allow configuration files to be generated dynamically.

Example use cases:

```
nginx config
app config
environment files
systemd service files
```

Templates use Jinja2 expressions like:

```
{{ variable_name }}
```

---

## 4. Handlers

Handlers restart services only when something changes.

Example:

```
config updated → restart service
config unchanged → no restart
```

This makes automation more efficient and idempotent.

---

## 5. Conditionals

Tasks sometimes need to run only in specific situations.

Example:

```yaml
when: ansible_os_family == "Debian"
```

This makes playbooks smarter and safer.

---

## 6. Registers

Registers store task output so later tasks can use it.

Example:

```yaml
register: docker_check
```

This allows decision-making based on command results.

---

# Plan

## Step 1 — Variables (~40 minutes)

Learn how variables work inside playbooks and why they matter.

Hands-on:

```
create a playbook using variables instead of hardcoded values
```

---

## Step 2 — group_vars and host_vars (~45 minutes)

Learn how Ansible automatically loads variables from external files.

Hands-on:

```
create group_vars/web.yml

move playbook variables out of the playbook
```

---

## Step 3 — Templates (~60 minutes)

Learn Jinja2 templating and dynamic config generation.

Hands-on:

```
create a simple .j2 file

render it onto the server using the template module
```

---

## Step 4 — Handlers (~45 minutes)

Learn how handlers run only when notified by changed tasks.

Hands-on:

```
deploy a config file

notify a handler to restart a service only if the config changes
```

---

## Step 5 — Conditionals (~30 minutes)

Learn how to control task execution using `when`.

Hands-on:

```
run package installation only if OS conditions match
```

---

## Step 6 — Registers (~30 minutes)

Learn how to capture command output and use it later.

Hands-on:

```
run a command
store the output
print or act on the result
```

---

# Expected Outcome After Day 9

I should understand how advanced Ansible workflows are structured:

```
Inventory
   ↓
Variables
   ↓
Templates
   ↓
Tasks
   ↓
Handlers
   ↓
Smarter automation
```

This is much closer to how real Ansible automation works in production.

---

# End-of-Day Success Criteria

Day 9 is successful if:
```
✔ I understand advanced Ansible building blocks
✔ I have practiced variables, templates, handlers, conditionals, and registers
✔ I can explain how production Ansible repositories are structured
```
---

# Next Phase

Day 10 will cover the next level of Ansible usage:

```
dynamic inventory

Ansible Vault

tags

debugging and validation

production deployment patterns
```

This will make the Ansible learning path feel complete.
