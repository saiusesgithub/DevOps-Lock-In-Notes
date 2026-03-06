# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 1 — Step 3

#### Date : 06/03/2026

### Ad-hoc Commands (First Interaction with Ansible)

---

# Goal

Understand how Ansible executes **modules directly from the command line**.

By the end of this step you should understand:

* what an Ansible module is
* how ad-hoc commands work
* how Ansible executes tasks remotely
* how to run commands against hosts

This step introduces the **core execution model of Ansible**.

---

# 1. What Are Ad-hoc Commands?

Ad-hoc commands are **one-line Ansible commands used to perform quick tasks**.

They are mainly used for:

* testing connectivity
* running quick commands
* troubleshooting
* experimentation

Example idea:

Instead of writing a playbook you can run:
```bash
ansible all -m ping
```
Meaning:

Run the ping module on all hosts

Ad-hoc commands are useful for **small operations**, but for large automation we use **playbooks**.

---

# 2. Structure of an Ad-hoc Command

Basic structure:
```bash
ansible <host-pattern> -m <module> -a "<arguments>"
```
Explanation:

ansible → Ansible CLI command

host-pattern → which servers to target

-m → module flag

module → which module to run

-a → arguments passed to the module

Example:
```bash
ansible localhost -m ping
```
Meaning:

Run the ping module on localhost

---

# 3. The Ping Module

The **ping module** is commonly used to verify connectivity.

Important note:

This is **not a network ping**.

It checks whether:

* Ansible can connect
* Python works
* the Ansible module system works

Example:
```bash
ansible localhost -m ping
```
Expected result:

localhost | SUCCESS => {
"changed": false,
"ping": "pong"
}

Meaning:

Ansible successfully executed the module.

---

# 4. The Command Module

The **command module** runs commands on the target machine.

Example:
```bash
ansible localhost -m command -a "uptime"
```
Meaning:

Run the `uptime` command.

Example output:

localhost | CHANGED | rc=0 >>
15:30:01 up 2 days, 3:10, 2 users, load average: 0.10

---

# 5. The Shell Module

The **shell module** allows running shell commands.

Example:

ansible localhost -m shell -a "ls"

Difference from `command` module:

| Module  | Behavior                    |
| ------- | --------------------------- |
| command | runs commands directly      |
| shell   | runs commands through shell |

Example where shell is needed:

ansible localhost -m shell -a "echo hello > file.txt"

---

# 6. Package Management Modules

Ansible can install packages using modules.

Example for Ubuntu:

apt

Example idea:

install nginx
update packages

This will later appear in **playbooks**.

---

# 7. How Ansible Executes Modules

When you run a command like:
```bash
ansible localhost -m ping
```
Internally Ansible does the following:
```
Control Machine
↓
Ansible loads module
↓
Module sent via SSH
↓
Executed on target
↓
Result returned
```

Execution flow:
```
Ansible CLI
↓
Load module
↓
Connect via SSH
↓
Execute Python module
↓
Return result
```
This happens **every time a task runs**.

---

# 8. Why Modules Are Important

Modules are the **building blocks of Ansible automation**.

Examples of common modules:
```
ping
command
shell
apt
service
copy
file
git
docker_container
```

Each module performs a **specific operation**.

Later your playbooks will combine many modules.

---

# 9. Practical Commands to Try

Run these locally.

### Test connectivity
```bash
ansible localhost -m ping
```
---

### Check system uptime
```bash
ansible localhost -m command -a "uptime"
```

---

### List files
```bash
ansible localhost -m shell -a "ls"
```
---

### Check current user

ansible localhost -m command -a "whoami"

---

# 10. Key Learning

Ad-hoc commands teach the **core execution model** of Ansible.

You learned that:

* Ansible runs modules
* modules execute tasks
* results are returned to the control node

This is the same mechanism used by **playbooks**.

---

# Day 1 Final Understanding

At the end of Day 1 you should understand:

Configuration management
Ansible architecture
Control node vs managed nodes
Inventory concept
Modules
Tasks
Playbooks
Ad-hoc commands

