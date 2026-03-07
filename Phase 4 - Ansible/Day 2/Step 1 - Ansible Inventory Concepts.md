# DevOps Lock-In Phase 4

## Configuration Management — Ansible

#### Date : 07/03/2026

## Day 2 — Step 1

### Inventory (Defining Managed Servers)

---

# Goal

Understand how Ansible knows **which servers to manage**.

By the end of this step I should understand:

* what an inventory file is
* why inventory exists
* host groups
* host variables
* static vs dynamic inventory
* how Ansible identifies servers

---

# 1. What is an Inventory?

An **inventory** is a file that tells Ansible **which servers it should manage**.

Without an inventory, Ansible does not know:

* where servers are
* how to connect to them
* what credentials to use

The inventory acts as a **map of infrastructure**.

---

# Example Mental Model

Think of inventory as a **server directory**.

Example infrastructure:
```
Web Server → EC2 instance
Database Server → RDS or VM
Worker Server → EC2 instance
```
Ansible must know about these machines before it can automate anything.

Inventory provides that information.

---

# 2. Static Inventory

The simplest type of inventory is a **static inventory file**.

It is a plain text file listing servers.

Example:
```
inventory
```
Contents:
```
[web]
server1
server2
```
Explanation:
```
[web] → group name
server1 → hostname
server2 → hostname
```
Now you can run commands like:
```
ansible web -m ping
```
Meaning:

Run the ping module on all servers in the **web group**.

---

# 3. Host Groups

Groups allow you to organize servers by role.

Example infrastructure:
```
Web servers
Database servers
Worker nodes
```
Inventory example:
```
[web]
web1
web2

[db]
db1

[workers]
worker1
worker2
```
Now automation can target groups.

Example:

Run command only on web servers:
```
ansible web -m ping
```
Run command only on database server:
```
ansible db -m ping
```
Run command on all servers:
```
ansible all -m ping
```
---

# 4. Host Variables

Each server may require connection details.

Example:

* IP address
* SSH user
* private key

Inventory allows specifying variables per host.

Example:
```
[web]
portfolio_server ansible_host=EC2_IP
```
Explanation:
```
portfolio_server → logical name
ansible_host → actual IP address
```
This allows you to refer to the server using a friendly name.

---

# 5. SSH Connection Variables

For EC2 instances we must define connection details.

Common variables:
```
ansible_host
ansible_user
ansible_ssh_private_key_file
```
Example:
```
[web]
portfolio_server ansible_host=3.25.10.11 ansible_user=ubuntu ansible_ssh_private_key_file=key.pem
```
Meaning:
```
server name → portfolio_server
IP → 3.25.10.11
SSH user → ubuntu
private key → key.pem
```
Now Ansible knows exactly **how to connect**.

---

# 6. How Ansible Uses Inventory

When you run:
```
ansible web -i inventory -m ping
```
Execution flow:
```
Read inventory file
↓
Find servers in web group
↓
Establish SSH connection
↓
Execute module
↓
Return result
```
Inventory is the **starting point for all Ansible automation**.

---

# 7. Static vs Dynamic Inventory

There are two main types of inventory.

---

## Static Inventory

Servers defined manually.

Example:
```
inventory file
```
Used when:

small environments
learning
simple setups

---

## Dynamic Inventory

Servers discovered automatically.

Example sources:
```
AWS
GCP
Azure
Kubernetes
```
Example idea:

Ansible automatically fetches:
```
EC2 instances
tags
IP addresses
```
Dynamic inventory is common in **large cloud environments**.

For now we use **static inventory**.

---

# 8. Why Inventory is Important

Inventory enables:

* server grouping
* environment separation
* scalable automation
* infrastructure mapping

Without inventory, Ansible cannot target machines.

---

# 9. Real DevOps Example

Example infrastructure:

3 web servers
1 database server
2 worker servers

Inventory:
```
[web]
web1
web2
web3

[database]
db1

[workers]
worker1
worker2
```
Automation becomes simple:

Deploy app:
```
ansible web -m command -a "deploy.sh"
```
Restart database:
```
ansible database -m service -a "name=postgres state=restarted"
```
Inventory makes **large-scale automation manageable**.

---

# Key Takeaway

Inventory defines **which servers Ansible manages and how to connect to them**.

It acts as the **source of truth for infrastructure targets**.

Every Ansible operation begins by reading the inventory.

---

# Next Step

Day 2 — Step 2

Configure **SSH authentication and test connectivity with EC2**.

First real command against a remote server:
```bash
ansible web -i inventory -m ping
```
This will prove Ansible can **control a real machine**.
