# Day 6 — Step 02: Implicit Dependencies (Hands-On)

**Date:** February 12, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Let Terraform infer the graph  
**Environment:** AWS provider + multiple related resources

---

## 🎯 Objective of This Step

Understand how Terraform automatically builds dependency edges
without using `depends_on`.

By the end of this step, I must:

* Create resources that depend on each other
* Predict execution order before running plan
* Explain exactly why Terraform chooses that order
* Confirm that file order does NOT matter

---

## 🧠 Core Rule of Implicit Dependencies

If a resource references another resource’s attribute,
Terraform creates a dependency edge automatically.

Example mental model:

```
resource A
resource B referencing A.id
```

Graph:

```
A → B
```

No `depends_on` needed.

---

## 🧱 Hands-On Setup

We will create a small chain:

1️⃣ VPC  
2️⃣ Subnet referencing VPC  
3️⃣ Security Group referencing VPC

---

## Step 02A — Add VPC

Add this to your configuration:

```hcl
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lockin-demo-vpc"
  }
}
```

### Predict Before Plan

Does this resource depend on anything?

Will it be created first?

Why?

---

## Step 02B — Add Subnet Referencing VPC

```hcl
resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "lockin-demo-subnet"
  }
}
```

### Predict Before Plan

Answer carefully:

What edge did Terraform just create?

What must be created first?

Why is file order irrelevant?

Graph should now be:

```
aws_vpc.demo_vpc → aws_subnet.demo_subnet
```

---

## Step 02C — Add Security Group Referencing VPC

```hcl
resource "aws_security_group" "demo_sg" {
  name   = "lockin-demo-sg"
  vpc_id = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lockin-demo-sg"
  }
}
```

### Predict Again Before Running Plan

Now ask:

Does subnet depend on security group?

Does security group depend on subnet?

What can Terraform create in parallel?

What must be created first?

Correct mental graph:

```
        → aws_subnet.demo_subnet
aws_vpc
        → aws_security_group.demo_sg
```

Meaning:

VPC first

Subnet & SG can run in parallel

---

## 🧪 Now Run

```bash
terraform plan
```

Observe:

* Creation order in output
* That Terraform did NOT require depends_on
* That file order did not matter

---

## 🧠 What Just Happened Internally

Terraform:

* Parsed entire config
* Built graph from references
* Topologically sorted graph
* Prepared execution plan

No instruction sequencing.  
No step numbers.

Graph-based reasoning.

---

## 🔥 Critical Realization

Terraform does not create:

* In file order
* In resource declaration order

It creates in:

Dependency order derived from references

This is why Terraform feels predictable.

---

## 🚫 What You Should NOT Do Here

Do NOT add:

```hcl
depends_on = [...]
```

If implicit references exist,  
depends_on is unnecessary noise.

---

## ✅ End Condition for Step 02

This step is complete only if I can:

* Draw the graph manually
* Predict creation order before plan
* Explain why subnet and SG can run in parallel
* Confirm that no explicit ordering was required
