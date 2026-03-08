# DevOps Lock-In Phase 4  
## Infrastructure Automation Integration

## Day 5 — Terraform + Ansible Integration

Originally Planned: March 10  
Actual Execution: March 8 2026

Day 5 is being started earlier due to faster progress during previous days of the lock-in.

Estimated Time: ~2–3 hours

---

# Goal

Combine Terraform and Ansible to create a **complete infrastructure automation workflow**.

By the end of this day I should understand:

- how Terraform and Ansible work together
- how infrastructure provisioning connects with configuration management
- how DevOps pipelines separate responsibilities between tools
- how real infrastructure automation flows operate

This step transitions from **learning tools individually → integrating the DevOps stack**.

---

# Target

By the end of Day 5 I will have a workflow where:

```
Terraform
    ↓
Creates EC2 instance
    ↓
Outputs instance IP
    ↓
Ansible
    ↓
Connects to server
    ↓
Installs Docker
    ↓
Deploys application container
```

Result:

```
Single workflow provisions infrastructure and deploys application.
```

---

# Focus

Today focuses on **tool orchestration**.

Understanding which tool does what:

| Tool | Responsibility |
|-----|------|
| Terraform | Infrastructure provisioning |
| Ansible | Server configuration |
| Docker | Application runtime |
| GitHub Actions | Automation pipeline |

---

# DevOps Workflow Architecture

```
Developer Laptop
        │
        │ terraform apply
        ▼
Terraform
        │
        │ Creates EC2
        ▼
AWS Infrastructure
        │
        │ Ansible SSH
        ▼
Ansible
        │
        │ Install Docker
        │ Deploy Container
        ▼
Running Application
```

This is the **core DevOps architecture pattern** used in many organizations.

---

# Plan

## Step 1 — Review Terraform Outputs

Understand how Terraform exposes information about created infrastructure.

Example:

```
EC2 Public IP
EC2 Instance ID
Security Group
```

Terraform outputs allow other tools (like Ansible) to know where to connect.

---

## Step 2 — Connect Terraform Output to Ansible

Ansible needs the server IP.

Instead of manually editing inventory, Terraform can provide it.

Example idea:

```
terraform output public_ip
```

Then Ansible uses that IP to connect.

---

## Step 3 — Automated Infrastructure + Configuration Flow

Execute workflow:

```
terraform apply
ansible-playbook deploy.yml
```

Result:

```
Infrastructure created
Server configured
Application deployed
```

---

# Expected Architecture After Day 5

```
Terraform → Infrastructure

        │

Ansible → Server Configuration

        │

Docker → Application Runtime
```

All layers of infrastructure automation become connected.

---

# End-of-Day Success Criteria

Day 5 is successful if:

✔ Terraform provisions EC2  
✔ Ansible connects automatically  
✔ Docker installs via Ansible  
✔ Application container deploys successfully  

---

# DevOps Stack Status

Current stack:

```
Linux
Docker
Terraform
GitHub Actions
AWS
Ansible
```

Automation layers:

```
Terraform → infrastructure provisioning
Ansible → configuration management
Docker → application runtime
GitHub Actions → CI/CD pipeline
```

This stack forms the foundation of **modern DevOps environments**.

---

# Next Phase

Day 6 will introduce **automation orchestration**, where this workflow can be triggered automatically from a pipeline.

Example:

```
GitHub push
     ↓
GitHub Actions
     ↓
Terraform apply
     ↓
Ansible deploy
```

Which results in **fully automated infrastructure deployment**.