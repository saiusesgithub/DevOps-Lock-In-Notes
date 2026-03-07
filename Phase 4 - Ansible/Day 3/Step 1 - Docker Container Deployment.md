# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 3 — Step 1

### Deploy Docker Container with Ansible

Originally Planned: March 8

Actual Execution: March 7 2026

Day 3 is being completed earlier due to additional available time after finishing Day 2.

---

# Goal

Deploy a Docker container automatically using Ansible.

By the end of this step I should be able to:

* use Ansible to deploy applications
* automate Docker container creation
* expose a container port
* ensure a container is running

This step moves from **server configuration → application deployment**.

---

# 1. Manual Docker Deployment (Before Automation)

Normally, deploying an application with Docker would look like this:

```bash
docker pull nginx
docker run -d -p 80:80 nginx
```

Explanation:

```bash
docker pull nginx
```

Downloads the nginx image.

```bash
docker run -d -p 80:80 nginx
```

Runs a container:

* `-d` → detached mode
* `-p 80:80` → expose port 80
* `nginx` → container image

Instead of doing this manually, we automate it with Ansible.

---

# 2. Docker Automation with Ansible

Ansible provides modules for Docker operations.

The module we will use:

```text
docker_container
```

This module can:

* start containers
* stop containers
* remove containers
* expose ports
* manage container state

---

# 3. Create Deployment Playbook

Create a new file:

```bash
deploy.yml
```

Example playbook:

```yaml
---
- hosts: web
  become: true

  tasks:

    - name: Pull nginx image and run container
      docker_container:
        name: nginx_container
        image: nginx
        state: started
        ports:
          - "80:80"
```

---

# 4. Explanation of the Playbook

## hosts

```yaml
hosts: web
```

Targets the **web group** defined in the inventory.

---

## become

```yaml
become: true
```

Runs commands using **sudo privileges**.

Docker operations typically require root permissions.

---

## docker_container module

```yaml
docker_container:
```

This module manages Docker containers.

### container name

```yaml
name: nginx_container
```

Defines the container name.

### image

```yaml
image: nginx
```

The Docker image that will be used.

If the image is not present locally, Docker will automatically pull it.

### state

```yaml
state: started
```

Ensures that the container is running.

Possible values:

* `started`
* `stopped`
* `absent`

### ports

```yaml
ports:
  - "80:80"
```

Port mapping format:

```
HOST_PORT:CONTAINER_PORT
```

Example:

```
80:80
```

Meaning:

EC2 port 80 → container port 80

---

# 5. Run the Playbook

Execute the playbook:

```bash
ansible-playbook -i inventory deploy.yml
```

Execution flow:

```
Laptop
  ↓
Ansible reads playbook
  ↓
SSH connection to EC2
  ↓
Docker container created
  ↓
Port exposed
```

---

# 6. Expected Output

You should see tasks like:

```bash
TASK [Pull nginx image and run container]
changed: [ansible_practice_ec2]

PLAY RECAP
ansible_practice_ec2 : ok=1 changed=1 failed=0
```

---

# 7. Verify Deployment

Open a browser and visit:

```text
http://EC2_PUBLIC_IP
```

Example:

```text
http://18.60.153.2
```

You should see the **Nginx welcome page**.

---

# 8. Verify via SSH

Connect to EC2:

```bash
ssh -i ~/ansible-practice-ec2-key.pem ubuntu@18.60.153.2
```

Check containers:

```bash
docker ps
```

Expected result:

```text
CONTAINER ID   IMAGE   PORTS
nginx          80:80
```

---

# 9. What Just Happened

Before automation:

```
SSH → run docker commands manually
```

Now:

```bash
ansible-playbook deploy.yml
```

Ansible automatically:

* Pull image
* Create container
* Expose port
* Ensure container is running

This is true infrastructure automation.

---

# Architecture After Step 1

```
Control Machine
      ↓
   Ansible
      ↓
     SSH
      ↓
 EC2 Instance
      ↓
 Docker Container
      ↓
 Running Application
```

---

# End-of-Step Success Criteria

Step 1 is successful if:

✔ Playbook runs successfully

✔ Docker container is created

✔ Nginx container is running

✔ Port 80 is exposed

✔ Application is accessible via browser

---

# Next Step

Day 3 — Step 2

Understand **Idempotency**, one of the most important principles in configuration management.

You will:

* run the playbook multiple times
* observe Ansible behavior
* understand how automation remains safe and predictable

---

After this step, your **DevOps stack will feel much more real**, because your deployment command will literally be:

```bash
ansible-playbook deploy.yml
```

And your **server will launch an application automatically**.
