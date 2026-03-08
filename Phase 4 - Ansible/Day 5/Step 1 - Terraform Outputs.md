# DevOps Lock-In Phase 4

## Infrastructure Automation Integration

## Day 5 — Step 1

### Terraform Outputs

Originally Planned: March 10

Actual Execution: March 8 2026

Day 5 is being executed earlier due to faster progress in the lock-in schedule.

---

# Goal

Understand how Terraform exposes information about the infrastructure it creates.

By the end of this step I should understand:

* what Terraform outputs are
* why outputs are needed
* how other tools (like Ansible) use Terraform outputs
* how to extract infrastructure data such as EC2 public IP

---

# 1. The Problem

When Terraform creates infrastructure, important information is generated.

Example:

```
EC2 Instance ID
EC2 Public IP
Security Group ID
Subnet ID
```

Terraform knows this information internally.

But other tools (like Ansible) need access to it.

Example problem:

```
Terraform creates EC2
Ansible needs EC2 IP
```

Without outputs, we would have to manually check AWS and copy the IP.

---

# 2. Solution — Terraform Outputs

Terraform outputs allow infrastructure data to be exposed after deployment.

Example:

```bash
terraform apply
```

Terraform creates resources and then prints useful information.

Example output:

```
public_ip = 18.203.45.21
```

This makes it easy for other tools or scripts to use the data.

---

# 3. Example Output Block

Terraform outputs are defined inside Terraform code.

Example:

```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

Explanation:

| Component                  | Meaning                       |
| -------------------------- | ----------------------------- |
| output                     | Terraform output block        |
| public_ip                  | name of output                |
| value                      | value to expose               |
| aws_instance.web.public_ip | attribute of created resource |

---

# 4. Running Terraform with Outputs

After adding the output block, running:

```bash
terraform apply
```

Produces output like:

```
Apply complete!

Outputs:

public_ip = "18.203.45.21"
```

This information can now be used by other systems.

---

# 5. Viewing Outputs Later

Outputs can be retrieved anytime using:

```bash
terraform output
```

Example:

```bash
terraform output public_ip
```

Result:

```
18.203.45.21
```

This is extremely useful for automation workflows.

---

# 6. Why Outputs Matter for DevOps

Outputs allow tools to communicate with each other.

Example workflow:

```
Terraform
   ↓
Creates EC2
   ↓
Outputs EC2 Public IP
   ↓
Ansible reads IP
   ↓
SSH connection established
   ↓
Server configuration begins
```

Without outputs:

```
Manual copy paste from AWS console
```

With outputs:

```
Fully automated infrastructure workflow
```

---

# 7. Real DevOps Example

Production workflows often use outputs to expose:

```
load balancer DNS
EC2 public IP
database endpoint
VPC ID
subnet IDs
```

These outputs allow other tools or pipelines to interact with the infrastructure.

Example Infrastructure Pipeline

```
Terraform
    ↓
Creates AWS infrastructure
    ↓
Outputs infrastructure data
    ↓
Ansible
    ↓
Configures servers
    ↓
Docker
    ↓
Runs application
```

Outputs act as the bridge between Terraform and configuration tools.

---

# End-of-Step Success Criteria

Step 1 is successful if I understand:

✔ what Terraform outputs are

✔ how Terraform exposes infrastructure data

✔ how other tools use Terraform outputs

✔ how outputs enable automation workflows

---

# Key Takeaway

Terraform outputs expose infrastructure information so that other tools can use it.

Example:

```
Terraform → creates EC2
Terraform → outputs public IP
Ansible → connects to that IP
```

This allows infrastructure automation tools to work together.
