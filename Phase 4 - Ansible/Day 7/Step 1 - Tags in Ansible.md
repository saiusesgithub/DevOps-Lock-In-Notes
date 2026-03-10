# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 7 — Step 1

### Topic: Ansible Tags

**Date:** March 10

**Estimated Time:** ~35 minutes

---

# Goal

Understand how Ansible tags work and how they allow selective execution of playbook tasks.

After this step I should understand:

* what Ansible tags are
* how to assign tags to tasks
* how to run specific tagged tasks
* how tags help with debugging and partial automation

---

# Concept

In real infrastructure automation, playbooks often contain many tasks.

Example playbook:

* Install Docker
* Deploy container
* Configure nginx
* Restart services
* Update packages

Sometimes we do **not want to run the entire playbook**.

Example situations:

* Only install Docker
* Only restart nginx
* Only deploy container

Running the entire playbook every time can be slow and unnecessary.

Ansible solves this using **tags**.

---

# What Are Tags?

Tags are labels assigned to tasks.

Example:

```yaml
- name: Install Docker
  apt:
    name: docker.io
    state: present
  tags: docker
```

Now this task belongs to the `docker` tag group.

---

# Example Playbook With Tags

Example:

```yaml
- hosts: web
  become: true

  tasks:

    - name: Install Docker
      apt:
        name: docker.io
        state: present
      tags: docker

    - name: Deploy container
      docker_container:
        name: portfolio
        image: saiusesdocker/portfolio:latest
        state: started
      tags: deploy

    - name: Restart nginx
      service:
        name: nginx
        state: restarted
      tags: restart
```

Each task now has a tag.

---

# Running Specific Tags

Normally we run a playbook like this:

```bash
ansible-playbook deploy.yml
```

This runs all tasks.

To run only a specific tag:

```bash
ansible-playbook deploy.yml --tags docker
```

This executes only tasks labeled `docker`.

---

# Running Multiple Tags

Example:

```bash
ansible-playbook deploy.yml --tags "docker,deploy"
```

This runs:

* docker tasks
* deploy tasks

---

# Skipping Tags

Sometimes we want to skip tasks.

Example:

```bash
ansible-playbook deploy.yml --skip-tags restart
```

This runs all tasks except `restart` tasks.

---

# Why Tags Matter

Tags are extremely useful during development.

Example scenario:

You are testing only Docker installation.

Without tags:

* Run entire playbook

With tags:

* Run only docker tasks

This makes debugging much faster.

---

# Example Workflow

Development workflow using tags:

* Test docker setup
* Test deployment
* Test restart logic

Commands:

```bash
ansible-playbook deploy.yml --tags docker
ansible-playbook deploy.yml --tags deploy
ansible-playbook deploy.yml --tags restart
```

---

# Hands-On Task

Create a test playbook.

File:

`tags-test.yml`

Example:

```yaml
- hosts: web
  become: true

  tasks:

    - name: Install nginx
      apt:
        name: nginx
        state: present
      tags: install

    - name: Restart nginx
      service:
        name: nginx
        state: restarted
      tags: restart
```

Run only installation:

```bash
ansible-playbook -i inventory tags-test.yml --tags install
```

Run only restart:

```bash
ansible-playbook -i inventory tags-test.yml --tags restart
```

---

# Mental Model

Tags act like execution filters.

Instead of running everything:

* Task1
* Task2
* Task3
* Task4

Tags allow:

* Run only Task2
* Run only Task4

This is extremely helpful in large automation systems.

---

# Key Takeaways

Tags allow:

* selective execution of tasks
* faster testing and debugging
* modular playbook execution
* better automation control

Tags are heavily used in real DevOps playbooks.
