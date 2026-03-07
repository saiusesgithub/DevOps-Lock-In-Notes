# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 4 — Step 2

### Converting Playbooks into Roles

Originally Planned: March 9

Actual Execution: March 7

Day 4 is being completed earlier due to additional available time after completing Day 3.

---

# Goal

Convert the existing playbooks into roles to achieve modular infrastructure automation.

By the end of this step I should be able to:

* create Ansible roles
* move tasks into role directories
* organize automation into logical components
* call roles from playbooks

This transforms the project from **simple playbooks → modular automation system**.

---

# 1. Current Project Structure

Right now the project likely looks like this:

```
inventory
setup.yml
deploy.yml
```

Tasks are written directly inside playbooks.

Example:

```
install docker
start docker
deploy nginx container
```

This works but does not scale well.

---

# 2. Target Professional Structure

After converting to roles the project will look like:

```
ansible/

inventory
ansible.cfg

playbooks/
deploy.yml

roles/

docker/
tasks/
main.yml

deploy/
tasks/
main.yml
```

Each role contains the automation logic.

The playbook only orchestrates roles.

---

# 3. Create Roles Directory

Create the roles directory.

```bash
mkdir roles
```

Then create role folders.

```bash
mkdir -p roles/docker/tasks
mkdir -p roles/deploy/tasks
```

Project now looks like:

```
roles/

docker/
tasks/

deploy/
tasks/
```

---

# 4. Move Docker Tasks into Docker Role

Create:

```
roles/docker/tasks/main.yml
```

Move Docker setup tasks here.

Example:

```yaml
- name: Update apt packages
  apt:
    update_cache: yes

- name: Install Docker
  apt:
    name: docker.io
    state: present

- name: Start Docker service
  service:
    name: docker
    state: started
```

This role now handles Docker installation and configuration.

---

## 5. Create Deployment Role

Create:

```
roles/deploy/tasks/main.yml
```

Add container deployment logic.

Example:

```yaml
- name: Run application container
  docker_container:
    name: "{{ container_name }}"
    image: "{{ image_name }}"
    state: started
    ports:
      - "{{ host_port }}:{{ container_port }}"
```

This role handles application deployment.

---

## 6. Simplify the Playbook

Now the playbook only orchestrates roles.

Create:

```
playbooks/deploy.yml
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

  roles:
    - docker
    - deploy
```

Execution order:

```
Role: docker
Role: deploy
```

---

## 7. Execution Flow

When running:

```bash
ansible-playbook -i inventory playbooks/deploy.yml
```

Ansible performs:

```
Read playbook
   ↓
Load docker role
   ↓
Execute docker tasks
   ↓
Load deploy role
   ↓
Execute deploy tasks
```

---

## 8. Why This Structure Is Better

Benefits of roles:

### Separation of Responsibilities

```
docker role → install Docker
deploy role → deploy application
```

### Reusability

The same Docker role can be used in other projects.

### Maintainability

Changes to Docker installation only require editing:

```
roles/docker/tasks/main.yml
```

### Scalability

Infrastructure automation becomes easier to expand.

Example future roles:

```
nginx
monitoring
logging
security
database
```

---

## 9. Example Real DevOps Project

Production repositories often look like this:

```
ansible/

inventory
ansible.cfg

playbooks/
site.yml

roles/

docker
nginx
postgres
redis
monitoring
security
```

Roles allow infrastructure automation to scale across large environments.

---

## Architecture After Step 2

```
Laptop
   ↓
Ansible Playbook
   ↓
Roles
   ↓
SSH
   ↓
EC2 Server
   ↓
Docker Container Running Application
```

---

## End-of-Step Success Criteria

Step 2 is successful if:
```
✔ Roles directories exist
✔ Tasks moved into role main.yml files
✔ Playbook calls roles instead of tasks
✔ Playbook runs successfully
```


---

# Fix for Role Discovery Issue (Final Working Method)

## Problem

While running the playbook:

```
ansible-playbook playbooks/deploy.yml
```

Ansible produced the error:

```
ERROR! the role 'docker' was not found
```

Even though the `roles` directory existed.

---

## Root Cause

The project originally had this structure:

```
Hands On Files
│
├── inventory
├── ansible.cfg
│
├── playbooks
│   └── deploy.yml
│
└── roles
    ├── docker
    └── deploy
```

Ansible could not find the roles because:

1. `ansible.cfg` was being **ignored** due to the project being located inside a **world-writable Windows directory (`/mnt/c/...`)**.
2. Because the configuration file was ignored, Ansible did not load the `roles_path` setting.
3. Therefore Ansible searched only its default role locations and could not locate the `roles` directory.

---

## Final Solution Used

To simplify the setup and avoid configuration issues, the `roles` directory was moved **inside the `playbooks` directory**.

New project structure:

```
Hands On Files
│
├── inventory
├── ansible-practice-ec2-key.pem
│
└── playbooks
    │
    ├── deploy.yml
    │
    └── roles
        │
        ├── docker
        │   └── tasks
        │       └── main.yml
        │
        └── deploy
            └── tasks
                └── main.yml
```

---

## Why This Works

When Ansible runs a playbook inside the `playbooks` directory, it automatically searches for roles in:

```
playbooks/roles/
```

Because the roles were placed in this default search location, Ansible can now discover them without needing an `ansible.cfg` configuration.

---

## Command Used

The playbook is executed from the **Hands On Files directory**.

```
ansible-playbook -i inventory playbooks/deploy.yml
```

Execution flow:

```
Laptop
   ↓
Ansible Playbook
   ↓
playbooks/roles/
   ↓
docker role → installs Docker
deploy role → deploys container
   ↓
EC2 server configured automatically
```

---

## Key Lesson

If Ansible reports:

```
ERROR! the role '<role_name>' was not found
```

Check:

1. The role directory structure
2. The Ansible role search path
3. Whether roles are placed in the default location:

```
playbooks/roles/
```

Using the default role discovery path simplifies local project setups and avoids configuration issues.
