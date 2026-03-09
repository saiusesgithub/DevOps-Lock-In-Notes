# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 6 — Step 4

### Topic: Handlers

Date: March 9

Estimated Time: ~45 minutes

---

# Goal

Understand how Ansible handlers work and why they are used in real infrastructure automation.

After this step I should understand:

* what handlers are
* why handlers exist
* how tasks notify handlers
* how handlers improve idempotent automation

---

# Problem Without Handlers

In many automation scenarios we deploy configuration files.

Example:

* nginx configuration
* application config
* docker daemon config
* system service files

After updating a configuration file, the service usually needs to restart.

Example:
```
Update nginx.conf
Restart nginx
```
Without handlers, we might write automation like this:

```yaml
- name: Deploy nginx config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf

- name: Restart nginx
  service:
    name: nginx
    state: restarted
```

Problem:

The service restarts every time the playbook runs, even when the configuration did not change.

This is inefficient and unnecessary.

---

# Solution — Handlers

Handlers solve this problem.

A handler runs only when notified by a task that changed something.

Example flow:
```
Deploy config
↓
If config changed → notify handler
↓
Handler restarts service

If nothing changed:

Deploy config
↓
No change detected
↓
Handler NOT executed
```
This makes automation efficient and idempotent.

---

# Handler Syntax

Handlers are defined in a separate section of the playbook.

Example structure:

```
tasks:

handlers:
```

---

# Example Playbook

Example:

```yaml
- hosts: web
  become: true

  tasks:

    - name: Deploy configuration
      template:
        src: templates/test.conf.j2
        dest: /tmp/test.conf
      notify: restart test service

  handlers:

    - name: restart test service
      debug:
        msg: "Configuration changed — restarting service"
```

---

# What Happens During Execution

Step 1:

Template module checks if file changed

Step 2:

If file changed → notify handler

Step 3:

Handler executes at the end of the playbook

Important behavior:

Handlers run after all tasks complete.

---

# Example With Service Restart

Real example:

```yaml
tasks:

- name: Deploy nginx config
  template:
    src: templates/nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx

handlers:

- name: restart nginx
  service:
    name: nginx
    state: restarted
```

Flow:
```
Config changed
↓
Notify restart nginx
↓
Handler runs
```
If config unchanged:
```
No change
↓
No restart
```
---

# Why Handlers Matter

Handlers provide:

* efficient automation
* fewer unnecessary restarts
* safer configuration management
* idempotent infrastructure changes

This is extremely important in production systems.

Example:

* Database server restart
* Application server restart
* Load balancer restart

You do not want these restarting unnecessarily.

---

# Hands-On Task

Create a simple handler test.

Example playbook:

handler-test.yml

Example content:

```yaml
- hosts: web
  become: true

  tasks:

    - name: Deploy test file
      copy:
        content: "Test file content"
        dest: /tmp/handler-test.txt
      notify: restart demo service

  handlers:

    - name: restart demo service
      debug:
        msg: "Handler executed because file changed"
```

---

# Test Execution

Run:

```bash
ansible-playbook -i inventory handler-test.yml
```

First run:

File created → handler runs

Second run:

File unchanged → handler does not run

This demonstrates Ansible idempotency.

---

# Mental Model

Handlers act like event-driven automation.
```
Task changes something
↓
Trigger handler
↓
Perform dependent action
```
This prevents unnecessary operations.

---

# Key Takeaways

Handlers allow:

* conditional service restarts
* efficient configuration management
* event-driven automation
* idempotent infrastructure operations

Most real-world Ansible deployments rely heavily on handlers.




---

## "How does Ansible know if something changed?"

This is the key mechanism behind handlers.

Ansible modules are state-aware.

---

Example without template

Task:

```yaml
- name: Create file
  copy:
    content: "Hello"
    dest: /tmp/test.txt
```

First run

File does not exist.

Ansible:

```
create file
```

Output:

```
changed: true
```

Second run

File already exists with same content.

Ansible compares.

```
existing file content == desired content
```

So it does nothing.

Output:

```
changed: false
```

---

Same thing with template

Template task:

```yaml
- name: Deploy config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx
```

What Ansible actually does

Step 1 — Render template locally

```
listen 80
```

Step 2 — Check remote file

```
/etc/nginx/nginx.conf
```

Step 3 — Compare both files

If different:

```
replace file
changed = true
```

If identical:

```
do nothing
changed = false
```

---

Now how handlers work

Handler only runs when:

```
changed = true
```

Example:

```yaml
tasks:

- name: Deploy nginx config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx
```

Handler:

```yaml
handlers:

- name: restart nginx
  service:
    name: nginx
    state: restarted
```

---

First run

Config file changes.

```
template → changed = true
notify handler
```

Result:

```
restart nginx
```

---

Second run

Config identical.

```
template → changed = false
```

Handler not triggered.

---

Visual Flow

```
Deploy template
       ↓
Did file change?
       ↓
YES --------→ notify handler → restart nginx
NO  --------→ skip handler
```

---

Why this is powerful

Without handlers:

```
restart nginx every time
```

With handlers:

```
restart nginx only when config changes
```

This is called idempotent automation.

---

Quick mental model

Think of handlers like event listeners.

```
Task changes something
        ↓
Event triggered
        ↓
Handler runs
```

---

Real DevOps example

Deploy new nginx config.

```
template module updates config
           ↓
notify handler
           ↓
restart nginx
```

But if config same:

```
no restart
```

Which avoids service downtime.

---

Very simple real example

Template:

```
Hello {{ name }}
```

Variable:

```
name: Srujan
```

Final file:

```
Hello Srujan
```

If later you change:

```
name: DevOps
```

File changes → handler triggers.
