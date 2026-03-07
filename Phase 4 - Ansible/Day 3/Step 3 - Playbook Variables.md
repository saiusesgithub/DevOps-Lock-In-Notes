# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 3 — Step 3

### Using Variables in Playbooks

Originally Planned: March 8

Actual Execution: March 7 2026

Day 3 is being completed earlier due to additional available time after completing Day 2.

---

# Goal

Introduce variables into Ansible playbooks to make automation reusable and configurable.

By the end of this step I should be able to:

* understand what variables are in Ansible
* define variables inside playbooks
* reference variables inside tasks
* make playbooks reusable for different applications

This moves automation from **hardcoded configuration → flexible configuration**.

---

# 1. The Problem with Hardcoded Values

The current playbook contains fixed values.

Example:

```yaml
- name: Run nginx container
  docker_container:
    name: nginx_container
    image: nginx
    state: started
    ports:
      - "80:80"
```

Hardcoded values:

```
nginx
nginx_container
80:80
```

This means the playbook can only deploy one specific application.

If we want to deploy another application, the playbook must be edited.

This is not scalable.

---

# 2. Solution: Variables

Variables allow values to be defined separately from tasks.

Example variables:

```
image_name
container_name
host_port
container_port
```

Instead of hardcoding values, tasks reference variables.

---

# 3. Define Variables in the Playbook

Variables are usually defined near the top of the playbook.

Example:

```yaml
- hosts: web
  become: true

  vars:
    container_name: nginx_container
    image_name: nginx
    host_port: 80
    container_port: 80
```

Explanation:

| Variable       | Meaning                  |
| -------------- | ------------------------ |
| container_name | name of Docker container |
| image_name     | Docker image             |
| host_port      | EC2 port                 |
| container_port | container port           |

---

# 4. Use Variables in Tasks

Variables are referenced using **Jinja2 syntax**.

Format:

```text
{{ variable_name }}
```

Example playbook:

```yaml
- hosts: web
  become: true

  vars:
    container_name: nginx_container
    image_name: nginx
    host_port: 80
    container_port: 80

  tasks:

    - name: Run application container
      docker_container:
        name: "{{ container_name }}"
        image: "{{ image_name }}"
        state: started
        ports:
          - "{{ host_port }}:{{ container_port }}"
```

---

# 5. What Changed

Before variables:

```yaml
image: nginx
ports:
  - "80:80"
```

After variables:

```yaml
image: "{{ image_name }}"
ports:
  - "{{ host_port }}:{{ container_port }}"
```

The playbook now reads values from variables instead of hardcoded values.

---

# 6. Benefits of Variables

Variables provide several advantages.

## Reusability

The same playbook can deploy different applications.

Example:

```
nginx
node application
python service
docker registry
```

## Flexibility

Only variables need to change.

Example:

```yaml
image_name: redis
container_port: 6379
host_port: 6379
```

No changes required in tasks.

## Maintainability

Configuration is separated from logic.

This makes automation easier to maintain.

---

# 7. Example Alternative Deployment

Using the same playbook, deploy Redis.

Change variables:

```yaml
vars:
  container_name: redis_container
  image_name: redis
  host_port: 6379
  container_port: 6379
```

The playbook now deploys Redis instead of Nginx.

No changes required in tasks.

---

# 8. Run the Playbook

Execute the playbook again:

```bash
ansible-playbook -i inventory deploy.yml
```

Because the container already exists, idempotency should ensure minimal changes.

Expected output:

```
ok=1 changed=0
```

---

# 9. Architecture After Step 3

Your automation now performs the following:

```
Laptop
   ↓
Ansible Playbook
   ↓
SSH
   ↓
EC2 Server
   ↓
Docker Container
   ↓
Running Application
```

Deployment happens with a single command:

```bash
ansible-playbook deploy.yml
```

---

# End-of-Step Success Criteria

Step 3 is successful if:
```
✔ Playbook runs successfully
✔ Container is running on EC2
✔ Application is accessible in browser
✔ Playbook uses variables instead of hardcoded values
```
---

# Day 3 Completion

At this stage Ansible can:

```
install software
configure services
deploy applications
```

Infrastructure automation now includes:

```
Terraform → infrastructure creation
Ansible → server configuration + deployment
Docker → application runtime
```

---

# Next Step

Day 4 will introduce professional Ansible structure, including:

```
roles
modular playbooks
production-grade directory layout
real-world Ansible repository structure
```

---

You just finished **the hardest conceptual part of Ansible**.

Right now your DevOps flow already looks like:

```
Terraform → create EC2
Ansible → configure server
Ansible → deploy container
Docker → run application
```

That is **already a real infrastructure automation pipeline**.
