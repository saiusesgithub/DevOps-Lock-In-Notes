# DevOps Lock-In Phase 4

## Infrastructure Automation Integration

## Day 5 — Step 2

### Using Terraform Output for Ansible Inventory

Originally Planned: March 10

Actual Execution: March 8 2026

Day 5 is being executed earlier due to faster progress during the lock-in.

---

# Goal

Use Terraform outputs to provide server connection information to Ansible.

By the end of this step I should understand:

* how Terraform outputs expose infrastructure information
* how Ansible inventory can use dynamic data
* how infrastructure provisioning connects to configuration automation

---

# 1. The Manual Approach

Earlier, the Ansible inventory looked like:

```bash
[web]
server ansible_host=18.60.153.2 ansible_user=ubuntu ansible_ssh_private_key_file=ansible-practice-ec2-key.pem
```

The EC2 IP was **manually copied from AWS**.

Problem:

```
Terraform creates new EC2
IP changes
inventory must be manually updated
```

This breaks automation.

---

# 2. The DevOps Approach

Instead of manually copying the IP, Terraform exposes it.

Example Terraform output:

```hcl
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}
```

Now Terraform knows the EC2 public IP.

Example output:

```
ec2_public_ip = 18.60.153.2
```

---

# 3. Extracting Terraform Output

Terraform outputs can be retrieved using:

```bash
terraform output
```

Example:

```bash
terraform output ec2_public_ip
```

Result:

```
18.60.153.2
```

This value can now be used by other tools.

---

# 4. Passing Terraform Output to Ansible

Ansible needs the server IP in the inventory.

Instead of manually editing inventory, we can dynamically fetch the IP.

Example command:

```bash
terraform output ec2_public_ip
```

Then use it inside automation scripts or pipelines.

Example idea:

```bash
EC2_IP=$(terraform output -raw ec2_public_ip)
```

Now the server IP becomes a variable.

---

# 5. Dynamic Inventory Idea

Instead of static inventory:

```bash
inventory
```

Automation could generate inventory dynamically:

```bash
[web]
server ansible_host=<terraform_output_ip>
```

This removes manual infrastructure updates.

---

# 6. DevOps Workflow After Integration

The automation flow becomes:

```
Terraform apply
        ↓
EC2 instance created
        ↓
Terraform outputs public IP
        ↓
Ansible reads IP
        ↓
SSH connection established
        ↓
Server configured automatically
```

This is the first step toward full infrastructure automation.

---

# 7. Why This Matters

Without Terraform outputs:

```
Manual infrastructure configuration
Manual inventory updates
High risk of human error
```

With Terraform outputs:

```
Infrastructure becomes self-describing
Automation tools can connect automatically
Fully automated deployment becomes possible
```

---

# Example Integrated Architecture

```
Developer Laptop
        ↓
Terraform
        ↓
Creates EC2
        ↓
Outputs EC2 Public IP
        ↓
Ansible
        ↓
Connects via SSH
        ↓
Installs Docker
        ↓
Deploys Application Container
```

Infrastructure provisioning and configuration management now work together.

---

# End-of-Step Success Criteria

Step 2 is successful if I understand:
```
✔ how Terraform outputs expose infrastructure data
✔ how Ansible can use that data
✔ how manual inventory updates can be eliminated
✔ how Terraform and Ansible integrate in automation workflows
```
---

# Key Takeaway

Terraform outputs allow infrastructure tools to communicate.

Example:

```
Terraform → creates EC2
Terraform → outputs public IP
Ansible → uses that IP to configure the server
```

Outputs act as the bridge between infrastructure provisioning and server configuration.
