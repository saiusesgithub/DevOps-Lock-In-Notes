# DevOps Lock-In Phase 4

## Configuration Management — Ansible

### Day 7 — Extra Step

### Topic: Dynamic Inventory + CI/CD Integration

**Date:** March 10

**Estimated Time:** ~60–75 minutes

---

# Goal

Understand how Ansible works in real cloud environments where servers are created dynamically, and how Ansible integrates with CI/CD pipelines.

After this step I should understand:

* what dynamic inventory is
* why static inventory fails in cloud environments
* how Terraform and Ansible can exchange infrastructure data
* how CI/CD systems run Ansible automatically

---

# Problem With Static Inventory

In earlier steps we used a static inventory file:

```ini
[web]
server ansible_host=18.60.212.249
```

This works only when servers remain unchanged.

However in cloud infrastructure:

* Terraform creates EC2
* Terraform destroys EC2
* New IP address appears

If the IP changes, the inventory file becomes invalid.

Manual updates are not practical.

---

# Dynamic Infrastructure

Modern infrastructure is **ephemeral**.

Servers may be created or destroyed automatically.

Example workflow:

```
terraform apply
      ↓
New EC2 instance
      ↓
New public IP
```

Ansible must automatically discover these hosts.

This is called **Dynamic Inventory**.

---

# Dynamic Inventory Concept

Instead of storing IP addresses manually:

```
inventory file
```

Ansible queries a source to discover hosts.

Possible sources:

* AWS API
* Terraform outputs
* Cloud providers
* Service registries

Dynamic inventory automatically generates host lists.

---

# Method 1 — Terraform Output to Ansible

This is the method you practiced earlier.

Terraform exposes infrastructure information using outputs.

Example:

```hcl
output "ec2_public_ip" {
  value = aws_eip.public_ip.public_ip
}
```

Retrieve value:

```bash
terraform output -raw ec2_public_ip
```

This IP can then be written into the Ansible inventory.

Example automation:

```
terraform apply
      ↓
generate inventory file
      ↓
ansible-playbook deploy.yml
```

---

# Method 2 — Terraform Writes Inventory Automatically

A more advanced method uses Terraform to generate the inventory file.

Example Terraform resource:

```hcl
resource "local_file" "ansible_inventory" {
  content = <<EOF
[web]
server ansible_host=${aws_eip.public_ip.public_ip} ansible_user=ubuntu
EOF

  filename = "../ansible/inventory"
}
```

After `terraform apply`:

* inventory file generated automatically
* Ansible can immediately use it

---

# Method 3 — Cloud Dynamic Inventory Plugins

Ansible also supports cloud plugins.

Example:

**aws_ec2 inventory plugin**

Instead of listing IPs manually, Ansible queries AWS.

Example configuration:

```yaml
plugin: aws_ec2
regions:
  - us-east-1
filters:
  tag:Name: Portfolio
```

Ansible automatically finds EC2 instances with matching tags.

This is common in large infrastructures.

---

# Using Ansible Inside CI/CD

In modern DevOps workflows, automation is triggered by CI/CD systems.

Example pipeline:

```
Developer pushes code
      ↓
CI builds Docker image
      ↓
Image pushed to DockerHub
      ↓
Ansible deploys new version
```

Your pipeline already follows this pattern.

---

# Example CI/CD Flow

GitHub Actions pipeline:

```
Push to main branch
      ↓
Build application
      ↓
Build Docker image
      ↓
Push image to DockerHub
      ↓
Run Ansible deployment
```

Ansible connects to the server and deploys the container.

---

# Example GitHub Actions Step

Example step running Ansible:

```yaml
- name: Run Ansible
  env:
    ANSIBLE_HOST_KEY_CHECKING: False
  run: |
    ansible-playbook -i ansible/inventory ansible/playbooks/deploy.yml
```

The pipeline provides:

* SSH key
* server access
* deployment automation

---

# Why CI/CD + Ansible Matters

This integration allows:

* automatic deployments
* consistent server configuration
* repeatable infrastructure updates

Every code change triggers automated deployment.

---

# Full Architecture Example

Your current system already resembles a real DevOps architecture.

```
GitHub Push
     ↓
GitHub Actions
     ↓
Docker build
     ↓
DockerHub push
     ↓
Terraform infrastructure
     ↓
Ansible configuration
     ↓
Application deployment
```

This pipeline automates both infrastructure and application deployment.

---

# Mental Model

Dynamic infrastructure + automation pipeline:

* Infrastructure provisioning → Terraform
* Server configuration → Ansible
* Application packaging → Docker
* Automation trigger → CI/CD

Each tool has a clear responsibility.

---

# Key Takeaways

Dynamic inventory allows:

* automatic discovery of cloud infrastructure
* integration with Terraform
* automation without manual IP management

CI/CD integration allows:

* automated deployments
* repeatable infrastructure operations
* reliable application delivery

---

## Honest note about your progress

At this point your stack looks like:

* Terraform → Infrastructure
* Ansible → Server configuration
* Docker → Application runtime
* GitHub Actions → CI/CD
* AWS → Cloud platform

This is **exactly the DevOps stack many junior DevOps engineers use in real environments**.
