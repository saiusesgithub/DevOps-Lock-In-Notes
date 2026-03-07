# DevOps Lock-In Phase 4

## Configuration Management — Ansible

#### Date : 07/03/2026

## Day 2 — Step 2

### SSH Authentication + First EC2 Connection

---

# Goal

Configure SSH authentication so Ansible can connect to an EC2 instance and execute commands remotely.

By the end of this step I should be able to:

* access EC2 via SSH
* configure Ansible inventory with SSH credentials
* test connectivity using the Ansible ping module
* confirm Ansible can control the server

This is the **first real interaction between Ansible and AWS infrastructure**.

---

# 1. Prerequisites

Before connecting with Ansible, ensure the following exist.

### EC2 Instance

An EC2 instance should already be running.

Requirements:

* Ubuntu instance preferred
* Public IP address
* Security group allowing **SSH (port 22)**

Example:

```bash
Public IP: 3.25.10.11
```

---

### SSH Key Pair

You must have the **private key (.pem)** used when launching the EC2 instance.

Example:

```bash
portfolio-key.pem
```

This key allows secure SSH access.

---

# 2. Verify Direct SSH Access

Before using Ansible, confirm that SSH works.

Command:

```bash
ssh -i portfolio-key.pem ubuntu@EC2_IP
```

Example:

```bash
ssh -i portfolio-key.pem ubuntu@3.25.10.11
```

Expected result:

```bash
Connected to Ubuntu server
```

If this works, Ansible will also work because Ansible uses **SSH internally**.

---

# 3. Understanding Ansible SSH Variables

Ansible must know how to connect to the server.

These details are defined in the inventory.

Common connection variables:

```yaml
ansible_host
ansible_user
ansible_ssh_private_key_file
```

Explanation:

| Variable                     | Meaning                        |
| ---------------------------- | ------------------------------ |
| ansible_host                 | Server IP address              |
| ansible_user                 | SSH login user                 |
| ansible_ssh_private_key_file | Private key for authentication |

For Ubuntu EC2 instances:

```yaml
ansible_user: ubuntu
```

---

# 4. Create Inventory File

Create an inventory file.

Example:

```bash
inventory
```

Contents:

```ini
[web]
portfolio_server ansible_host=EC2_IP ansible_user=ubuntu ansible_ssh_private_key_file=portfolio-key.pem
```

Example with real IP:

```ini
[web]
portfolio_server ansible_host=3.25.10.11 ansible_user=ubuntu ansible_ssh_private_key_file=portfolio-key.pem
```

Explanation:

* `[web]` → server group
* `portfolio_server` → logical host name
* `ansible_host` → actual server IP
* `ansible_user` → SSH login user
* `ansible_ssh_private_key_file` → private key

Now Ansible knows:

* where the server is
* how to connect
* which credentials to use

---

# 5. First Ansible Connection Test

Now test connectivity using the **ping module**.

Command:

```bash
ansible web -i inventory -m ping
```

Explanation:

* `web` → target group
* `-i inventory` → inventory file
* `-m ping` → ping module

Expected output:

```bash
portfolio_server | SUCCESS => {
"changed": false,
"ping": "pong"
}
```

Meaning:

* Ansible connected successfully
* Python executed on server
* Module returned result

---

# 6. What Happens Internally

When the command runs:

```bash
ansible web -i inventory -m ping
```

Execution flow:

```
Control Machine
↓
Ansible reads inventory
↓
Establish SSH connection
↓
Send ping module
↓
Execute Python module on EC2
↓
Return result
```

This proves that Ansible can now **execute automation tasks on the server**.

---

# 7. Troubleshooting Common Issues

### Permission error

```bash
UNPROTECTED PRIVATE KEY FILE
```

Fix:

```bash
chmod 400 portfolio-key.pem
```

---

### Connection timeout

Possible causes:

* security group blocking port 22
* wrong IP
* instance not running

---

### Host key verification

If prompted:

```bash
Are you sure you want to continue connecting?
```

Type:

```bash
yes
```

---

# 8. Why This Step Matters

This step proves that the **automation control plane works**.

Architecture now looks like:

```
Your Laptop
↓
Ansible
↓
SSH
↓
EC2 Server
```

Now Ansible can:

* install software
* configure services
* deploy applications

---

# End-of-Step Success Criteria

Step 2 is successful if:

✔ SSH connection works

✔ Inventory file is configured correctly

✔ `ansible ping` command works

✔ Ansible successfully connects to EC2

This confirms that Ansible can **control the server**.

---

# Next Step

Day 2 — Step 3

Create the **first real playbook**.

Automation goal:

```
Update packages
Install Docker
Start Docker service
```

Command you will run:

```bash
ansible-playbook -i inventory setup.yml
```

This will install Docker **fully automatically**.

------

## Day 2 — Troubleshooting Notes

### SSH Authentication + EC2 Connection Issues

During the first EC2 connection with Ansible, several issues occurred.
These are common problems when configuring SSH-based automation.

# 1. Incorrect Inventory SSH Key Variable

## Problem

Ansible failed to authenticate with the EC2 instance.

Error:

```bash
Permission denied (publickey)
```

Initial inventory entry:

```ini
ansible_ssh_private_key=ansible-practice-ec2-key.pem
```

---

## Cause

The variable name was incorrect.

Ansible expects the variable:

```ini
ansible_ssh_private_key_file
```

Using an incorrect variable means Ansible **ignores the SSH key**, so authentication fails.

---

## Fix

Update the inventory entry.

Correct version:

```ini
[web]
ansible_practice_ec2 ansible_host=18.60.153.2 ansible_user=ubuntu ansible_ssh_private_key_file=ansible-practice-ec2-key.pem
```

---

# 2. SSH Private Key Permission Error

## Problem

Ansible produced this error:

```bash
WARNING: UNPROTECTED PRIVATE KEY FILE!
Permissions 0555 for 'ansible-practice-ec2-key.pem' are too open.
This private key will be ignored.
```

---

## Cause

SSH requires private keys to have **restricted permissions**.

Current permission:

```bash
555
```

Meaning:

```
owner → read + execute
group → read + execute
others → read + execute
```

This is insecure, so SSH refuses to use the key.

---

## Fix

Restrict permissions using:

```bash
chmod 400 ansible-practice-ec2-key.pem
```

Permission meaning:

```
owner → read
group → none
others → none
```

This satisfies SSH security requirements.

---

# 3. Windows Filesystem Permission Issue (WSL)

## Problem

Even after running:

```bash
chmod 400 ansible-practice-ec2-key.pem
```

the same error still appeared.

```bash
Permissions 555 are too open
```

---

## Cause

The key file was located in a **Windows-mounted directory**:

```bash
/mnt/c/Users/...
```

Windows filesystems **do not respect Linux chmod permissions**, so SSH still detects incorrect permissions.

---

## Fix

Move the key to the Linux filesystem.

Command:

```bash
cp ansible-practice-ec2-key.pem ~/
chmod 400 ~/ansible-practice-ec2-key.pem
```

Now the file exists inside:

```bash
/home/<user>/
```

where Linux permissions work correctly.

---

# 4. Inventory Still Referencing Windows Path

## Problem

Even after moving the key, the error persisted.

---

## Cause

The inventory file was still referencing the original key location.

Example:

```ini
ansible_ssh_private_key_file=ansible-practice-ec2-key.pem
```

Since the working directory was inside `/mnt/c`, Ansible still used the Windows file.

---

## Fix

Update the inventory to use the Linux path.

Correct entry:

```ini
[web]
ansible_practice_ec2 ansible_host=18.60.153.2 ansible_user=ubuntu ansible_ssh_private_key_file=~/ansible-practice-ec2-key.pem
```

Now Ansible uses the key stored in the Linux filesystem.

# Key Lessons Learned

1. Correct Ansible variable names are critical.
2. SSH private keys require strict file permissions.
3. Windows filesystems may break SSH permission checks in WSL.
4. Keys should be stored in the Linux filesystem when using WSL.
5. Inventory configuration directly controls how Ansible connects to servers.