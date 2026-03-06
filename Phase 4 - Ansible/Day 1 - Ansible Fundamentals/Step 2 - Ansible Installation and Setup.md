# DevOps Lock-In Phase 4

## Configuration Management — Ansible

## Day 1 — Step 2

#### Date : 06/03/2026

### Install Ansible + Verify Environment

---

# Goal

Install Ansible on the **control machine** and verify that the environment is ready to run Ansible commands.

By the end of this step:

* Ansible should be installed
* The version should be verified
* Python dependency should be confirmed
* The Ansible environment should be working

---

# 1. Understand the Requirements

Ansible requires very minimal setup on the control machine.

Main requirements:

• Python installed

• Package manager (apt / brew / pip)

• Network access for SSH

On managed servers, only two things are required:

• SSH access
• Python installed

This is why Ansible is considered **lightweight and agentless**.

---

# 2. Install Ansible

Since most DevOps environments use Linux servers, we install Ansible using **apt**.

First update package lists.

```bash
sudo apt update
```

Then install Ansible.

```bash
sudo apt install ansible -y
```

This installs:

* ansible
* ansible-core
* required Python libraries

---

# 3. Verify Installation

After installation, confirm that Ansible is available.

Run:

```bash
ansible --version
```

Expected output should look similar to:

```
ansible [core X.X.X]
config file = None
configured module search path = ...
ansible python module location = ...
python version = X.X.X
```

Important fields:

**ansible core version**

Shows which Ansible version is installed.

**python version**

Confirms the Python runtime used by Ansible.

---

# 4. Verify Python Environment

Ansible internally runs **Python modules on target servers**.

Check Python version:

```bash
python3 --version
```

Expected result:

```
Python 3.x.x
```

Python must be **3.8+ for most modern Ansible versions**.

---

# 5. Check Ansible Configuration

Run:

```bash
ansible-config dump | head
```

This command prints current configuration values.

You should see various Ansible settings such as:

```
DEFAULT_HOST_LIST
DEFAULT_MODULE_PATH
DEFAULT_TIMEOUT
```

This confirms Ansible is properly installed and configured.

---

# 6. Understand What Just Happened

When you installed Ansible:

* The Ansible CLI tools were installed
* Python libraries for automation were installed
* Default configuration was loaded

The control machine is now capable of:

• connecting to servers via SSH
• executing modules
• running playbooks

---

# 7. Quick Mental Model

At this stage:

```
Control Machine (your laptop)
        ↓
     Ansible
        ↓
       SSH
        ↓
 Managed Servers
```

You haven't connected to servers yet.

Right now you only verified the **control environment**.

---

# 8. End-of-Step Success Criteria

Step 2 is complete if:

✔ Ansible installs successfully

✔ `ansible --version` runs without error

✔ Python version is confirmed

✔ Ansible configuration can be printed





-------

ansible doesnt work with windows so always run it from linux or wsl (search for ubuntu in windows search and run in that terminal - that terminal is basically the ubuntu terminal)