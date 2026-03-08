# DevOps Lock-In Phase 4  
## Infrastructure Automation Integration

## Day 5 — Step 3  
### Complete Infrastructure Automation Workflow

Originally Planned: March 10  

Actual Execution: March 8 2026

Day 5 is being executed earlier due to faster progress during the lock-in.

---

# Goal

Understand and execute a complete infrastructure automation workflow combining:

Terraform  
Ansible  
Docker  

By the end of this step I should understand how infrastructure provisioning and configuration management work together in a DevOps environment.

---

# 1. The DevOps Automation Problem

Infrastructure deployment usually involves multiple steps.

Example manual workflow:

```
Create EC2 instance
SSH into server
Install Docker
Pull application image
Run container
```

Problems with this approach:

```
Manual work
Error-prone
Slow deployments
Difficult to reproduce environments
```

DevOps solves this through automation.

---

# 2. Layered DevOps Automation Model

Each tool is responsible for a specific layer.

| Layer | Tool | Responsibility |
|------|------|------|
| Infrastructure | Terraform | Provision cloud resources |
| Configuration | Ansible | Configure servers |
| Application Runtime | Docker | Run application containers |
| Pipeline | GitHub Actions | Automate workflow |

This separation of responsibilities makes infrastructure easier to maintain.

---

# 3. Infrastructure Automation Workflow

The integrated workflow now looks like:

```
Developer Laptop
│
│ terraform apply
▼
Terraform
│
│ Creates EC2 instance
▼
AWS Infrastructure
│
│ Ansible SSH
▼
Ansible
│
│ Install Docker
│ Deploy container
▼
Running Application
```

Each tool performs a specific stage of the deployment.

---

# 4. Execution Workflow

The complete deployment now requires two commands.

Step 1 — Create infrastructure:

```
terraform apply
```

Terraform performs:

```
Create EC2
Create Security Group
Attach networking
Expose public IP
```

---

Step 2 — Configure infrastructure:

```
ansible-playbook -i inventory playbooks/deploy.yml
```

Ansible performs:

```
Connect to EC2
Install Docker
Start Docker service
Deploy application container
```

---

# 5. Result

After running both commands:

```
EC2 instance exists
Docker installed
Application container running
Website accessible
```

Infrastructure and application deployment become fully automated.

---

# 6. Why This Architecture Is Important

This architecture separates infrastructure responsibilities.

```
Terraform → Infrastructure provisioning
Ansible → Server configuration
Docker → Application runtime
```

Benefits:

```
Modular automation
Repeatable deployments
Scalable infrastructure
Reduced human error
```

This architecture is used widely in production DevOps environments.

---

# 7. Example Production Pipeline

Real-world pipelines often look like:

```
GitHub push
↓
GitHub Actions
↓
Terraform apply
↓
Ansible playbook
↓
Docker container deployment
```

This enables **fully automated deployments** triggered by code changes.

---

# 8. Final DevOps Stack

At this stage the working stack includes:

```
Linux
Docker
Terraform
Ansible
GitHub Actions
AWS
```

These tools form the foundation of modern DevOps workflows.

---

# End-of-Step Success Criteria

Step 3 is successful if I understand:

✔ how Terraform provisions infrastructure  
✔ how Ansible configures servers  
✔ how Docker runs applications  
✔ how these tools integrate into a single workflow  

---

# Phase 4 Completion

After completing Phase 4, the automation flow becomes:

```
terraform apply
ansible-playbook deploy.yml
```

Result:

```
EC2 created
Docker installed
Application deployed
Website live
```

This marks the completion of **Configuration Management with Ansible** in the DevOps Lock-In.