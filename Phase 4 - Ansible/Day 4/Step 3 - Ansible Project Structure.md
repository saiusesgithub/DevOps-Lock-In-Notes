# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 4 — Step 3

### Professional Ansible Project Structure

Originally Planned: March 9

Actual Execution: March 7

Day 4 is being completed earlier due to additional available time after completing Day 3.

---

# Goal

Organize the Ansible project into a **professional directory structure** similar to real DevOps repositories.

By the end of this step I should:

* create a clean Ansible project layout
* understand the purpose of each directory
* configure an `ansible.cfg` file
* separate playbooks, roles, and inventory properly

This converts the project from **learning structure → production-style infrastructure codebase**.

---

# 1. The Problem with Flat Project Structure

Currently the project may look like this:

```
inventory
setup.yml
deploy.yml
roles/
```

This works for small experiments but becomes messy as automation grows.

Problems:

```
too many files in root
difficult to manage playbooks
unclear separation of responsibilities
harder collaboration
```

Professional projects organize Ansible files into clear directories.

---

# 2. Target Professional Structure

The recommended structure:

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

Each component has a clear responsibility.

---

# 3. Directory Purpose

## inventory

Defines the infrastructure servers.

Example:

```
[web]
ansible_practice_ec2 ansible_host=18.60.153.2 ansible_user=ubuntu ansible_ssh_private_key_file=~/ansible-practice-ec2-key.pem
```

This file tells Ansible **which machines to manage**.

---

## playbooks/

Contains playbooks that orchestrate automation.

Example:

```
playbooks/deploy.yml
```

Playbooks call roles and define high-level automation.

---

## roles/

Contains modular automation logic.

Example roles:

```
docker
deploy
```

Each role contains tasks related to a specific service.

Example:

```
roles/docker/tasks/main.yml
```

Handles Docker installation.

---

## ansible.cfg

Defines Ansible configuration for the project.

This file allows default settings to be defined so commands become shorter.

---

# 4. Create ansible.cfg

Create file:

```
ansible.cfg
```

Example configuration:

```ini
[defaults]

inventory = inventory
host_key_checking = False
retry_files_enabled = False
```

Explanation:

| Setting             | Purpose                         |
| ------------------- | ------------------------------- |
| inventory           | default inventory file          |
| host_key_checking   | disable SSH confirmation prompt |
| retry_files_enabled | disable retry file creation     |

---

# 5. Benefits of ansible.cfg

Without configuration file:

```bash
ansible-playbook -i inventory playbooks/deploy.yml
```

With configuration file:

```bash
ansible-playbook playbooks/deploy.yml
```

The inventory file is automatically detected.

This simplifies execution.

---

# 6. Final Directory Layout

Your project should now resemble:

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

This layout is common in **professional infrastructure repositories**.

---

# 7. Execution After Structure

Now deployment command becomes:

```bash
ansible-playbook playbooks/deploy.yml
```

Execution flow:

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

Infrastructure and application deployment are now fully automated.

---

# 8. Why This Matters

This structure enables:

```
clean infrastructure code
modular automation
team collaboration
easy expansion
```

Large organizations manage infrastructure using similar repository layouts.

---

# End-of-Step Success Criteria

Step 3 is successful if:

✔ project directories are organized

✔ ansible.cfg exists

✔ playbooks call roles correctly

✔ automation runs successfully

✔ directory structure resembles production repositories

---

# Completion of Day 4

At this stage Ansible can:

```
install software
configure servers
deploy applications
organize automation into roles
structure infrastructure code professionally
```

---

# DevOps Automation Stack

Current stack:

```
Terraform → infrastructure provisioning
Ansible → server configuration
Docker → application runtime
GitHub Actions → pipeline automation
AWS → cloud platform
```

This is very close to a **complete DevOps workflow**.

---

# Next Phase

Day 5 will combine everything:

```
Terraform → create EC2
Ansible → configure server
Docker → deploy application
GitHub Actions → automate deployment pipeline
```

This will form a **complete infrastructure automation system**.


---
---
---

### Fix for Ansible Role Discovery Issue

While running the playbook:

```bash
ansible-playbook -i inventory playbooks/deploy.yml
```

Ansible produced:

```
ERROR! the role 'docker' was not found
```

This happened because Ansible could not locate the `roles` directory.

---

### Solution 1 — Move Roles into Default Search Location

Ansible automatically searches for roles in:

```
playbooks/roles/
```

So moving the roles folder solves the issue.

**Structure used:**

```
Hands On Files
│
├── inventory
│
└── playbooks
    ├── deploy.yml
    └── roles
        ├── docker
        │   └── tasks/main.yml
        └── deploy
            └── tasks/main.yml
```

Run command:

```bash
ansible-playbook -i inventory playbooks/deploy.yml
```

---

### Solution 2 — Use `ansible.cfg` to Define Role Path

Another approach is defining the roles path in the configuration file.

Example:

```
ansible.cfg
```

```ini
[defaults]
inventory = inventory
roles_path = ./roles
host_key_checking = False
retry_files_enabled = False
```

However, this may be ignored when running Ansible inside a **world-writable Windows directory (`/mnt/c/...`)** in WSL.

---

### Solution 3 — Move Project into WSL Filesystem

To ensure `ansible.cfg` works properly, move the project into the Linux filesystem:

```bash
mv /mnt/c/.../DevOps-Lock-In-Notes ~/devops-lock-in
cd ~/devops-lock-in
```

Then run:

```bash
ansible-playbook playbooks/deploy.yml
```

---

### Key Lesson

If Ansible cannot find roles:

1. Check the **role directory structure**
2. Use **default role discovery (`playbooks/roles/`)**
3. Or define **`roles_path` in `ansible.cfg`**
4. Avoid running Ansible from **world-writable Windows paths in WSL**
