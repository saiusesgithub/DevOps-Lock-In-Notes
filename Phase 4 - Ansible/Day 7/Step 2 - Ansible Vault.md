# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 7 — Step 2

### Topic: Ansible Vault (Secrets Management)

**Date:** March 10

**Estimated Time:** ~45 minutes

---

# Goal

Understand how Ansible Vault works and how it protects sensitive data inside automation repositories.

After this step I should understand:

* why secrets cannot be stored in plain text
* what Ansible Vault is
* how to encrypt files
* how to use encrypted variables in playbooks
* how to run playbooks that contain encrypted data

---

# Problem: Storing Secrets in Automation

Infrastructure automation often requires sensitive information.

## Examples

* database passwords
* API tokens
* SSH credentials
* private keys
* cloud access tokens

### Example of insecure playbook

```yaml
vars:
  db_password: mysecretpassword
```

If this file is committed to GitHub:

Anyone with repository access can see the password.

This is a major security risk.

---

# Solution: Ansible Vault

Ansible Vault allows encryption of sensitive files.

Encrypted files appear like this:

```
$ANSIBLE_VAULT;1.1;AES256
393832373465393264663865383239...
```

Only users with the vault password can decrypt them.

---

# Vault Encryption

Ansible uses strong encryption:

* AES256

This protects secrets inside infrastructure repositories.

---

# Creating an Encrypted File

## Command

```bash
ansible-vault create secrets.yml
```

You will be prompted for a password.

### Example content

```yaml
db_user: admin
db_password: supersecret
```

Save and exit.

The file is automatically encrypted.

---

# Viewing an Encrypted File

## Command

```bash
ansible-vault view secrets.yml
```

You must enter the vault password to see the contents.

---

# Editing an Encrypted File

## Command

```bash
ansible-vault edit secrets.yml
```

Ansible decrypts the file temporarily, lets you edit it, then encrypts it again.

---

# Using Vault Variables in Playbooks

Example encrypted file:

`secrets.yml`

## Example variables

```yaml
db_user: admin
db_password: supersecret
```

## Playbook example

```yaml
- hosts: web
  vars_files:
    - secrets.yml

  tasks:

    - name: Print database user
      debug:
        var: db_user
```

Ansible loads the encrypted variables during execution.

---

# Running Playbooks with Vault

When executing a playbook with encrypted variables:

```bash
ansible-playbook deploy.yml --ask-vault-pass
```

Ansible prompts for the vault password.

Once entered, it decrypts the secrets for the run.

---

# Alternative: Vault Password File

Instead of typing the password every time, a password file can be used.

Example:

```
vault_pass.txt
```

## Command

```bash
ansible-playbook deploy.yml --vault-password-file vault_pass.txt
```

This is often used in CI/CD systems.

---

# Hands-On Task

## 1️⃣ Create encrypted file

```bash
ansible-vault create secrets.yml
```

## 2️⃣ Add example content

```yaml
api_key: 123456789
db_password: mypassword
```

## 3️⃣ Create test playbook

```yaml
- hosts: web
  vars_files:
    - secrets.yml

  tasks:

    - name: Print API key
      debug:
        var: api_key
```

## 4️⃣ Run playbook

```bash
ansible-playbook -i inventory vault-test.yml --ask-vault-pass
```

Observe that Ansible decrypts the variables during execution.

---

# Mental Model

Think of Ansible Vault as:

**Encrypted storage for secrets inside automation projects**

Instead of writing:

```
password = plain text
```

We store:

```
password = encrypted file
```

Only authorized users with the vault password can decrypt it.

---

# Why Vault Matters in DevOps

Infrastructure repositories often contain:

* database credentials
* API keys
* cloud tokens

These must never be stored in plain text.

Ansible Vault ensures secrets remain protected even when repositories are shared.

---

# Key Takeaways

Ansible Vault allows:

* encryption of sensitive variables
* secure secret storage
* safe infrastructure repositories
* controlled access to secrets
