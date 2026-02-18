# 🔒 DevOps Lock-In — Phase 2 (Terraform)

# 📅 Day 7 — Real AWS Infrastructure (From Scratch)

# 🗓 Date: February 13, 2026

# 🧠 Mode: Holiday Deep Lock-In

---

## 🎯 Goal

Be able to open a blank directory and build real AWS infrastructure without templates, without notes, and without hesitation.

Terraform must feel mechanical — not conceptual.

---

## 🎯 Focus: Syntax Ownership & AWS Fluency

Today is about:

* Writing syntax from memory
* Reading AWS provider documentation deeply
* Understanding required vs optional arguments
* Predicting Terraform’s dependency graph
* Predicting AWS API behavior
* Understanding state mutations
* Debugging calmly

This is no longer S3 practice.

This is real infrastructure ownership.

---

# 🪜 Execution Plan (Step-by-Step)

---

## 🔹 STEP 1 — Create Blank Environment

* Create a new directory:
  terraform-real-infra-day7

* Inside it, create:

  * main.tf
  * variables.tf
  * terraform.tfvars

Do NOT reuse any previous files.

Clean mental state.
Fresh build.

---

## 🔹 STEP 2 — Write Provider & Variables From Scratch

### In main.tf:

* Write terraform block

  * required_providers
  * AWS version constraint
* Write provider "aws" block

  * region must use variable (no hardcoding)

### In variables.tf:

Create variables for:

* region
* instance_type
* environment
* vpc_cidr
* subnet_cidr

### In terraform.tfvars:

Set actual values.

Before running anything, ask yourself:

* What will terraform init download?
* Where will provider plugins be stored?
* What metadata will be recorded?

Then run:
terraform init

---

## 🔹 STEP 3 — Create VPC

Read AWS provider docs for:
resource "aws_vpc"

Write:

* cidr_block
* enable_dns_support
* enable_dns_hostnames
* tags

Before terraform plan, predict:

* Is VPC dependent on anything?
* What AWS API calls will occur?
* What attributes will be stored in state?
* What computed values will appear?

Run:
terraform plan

Do NOT apply yet.

---

## 🔹 STEP 4 — Create Subnet

Read docs:
resource "aws_subnet"

Write:

* vpc_id (reference VPC)
* cidr_block
* availability_zone
* map_public_ip_on_launch

Before terraform plan, predict:

* Does subnet require explicit depends_on?
* Why is implicit dependency enough?
* What edge will Terraform add to graph?

Run:
terraform plan

---

## 🔹 STEP 5 — Create Internet Gateway

Read docs:
resource "aws_internet_gateway"

Attach it to VPC.

Before terraform plan, predict:

* Does subnet depend on IGW?
* Why or why not?
* What resources are independent vs chained?

Run:
terraform plan

---

## 🔹 STEP 6 — Create Route Table & Route

Create:
resource "aws_route_table"

Add route:
0.0.0.0/0 → internet gateway

Then create:
resource "aws_route_table_association"

Associate route table with subnet.

Before terraform plan, predict:

* Which resources now form a chain?
* What is the graph structure?
* Which resources can still be created in parallel?

Run:
terraform plan

---

## 🔹 STEP 7 — Create Security Group

Read docs:
resource "aws_security_group"

Add:

* Ingress 22 (SSH)
* Ingress 80 (HTTP)
* Egress all

Before terraform plan, predict:

* Why must security group reference VPC?
* Does EC2 depend on SG?
* Does SG depend on EC2?

Run:
terraform plan

---

## 🔹 STEP 8 — Create EC2 Instance

Read docs:
resource "aws_instance"

Write:

* ami (manually find for region)
* instance_type (variable)
* subnet_id
* vpc_security_group_ids
* associate_public_ip_address (if required)
* tags

Before terraform plan, predict:

* What implicit dependencies exist?
* What order will Terraform execute?
* Which resources will be parallel?
* Which are sequential?

Run:
terraform plan

Only when fully understood:
terraform apply

Watch execution order carefully.

---

## 🔹 STEP 9 — Validate Infrastructure

After apply:

* Open AWS Console
* Inspect:

  * VPC
  * Subnet
  * Route Table
  * Internet Gateway
  * Security Group
  * EC2 instance

Then SSH into instance.

If SSH fails, debug using:

* Security group rules
* Public IP presence
* Route table association
* Internet gateway attachment

No panic debugging.
Only structured debugging.

---

## 🔹 STEP 10 — Add Outputs

Add outputs for:

* EC2 public IP
* VPC ID
* Subnet ID

Run:
terraform plan
terraform apply

Observe state changes.

---

## 🔹 STEP 11 — Destroy Everything

Before destroy, predict:

* Destruction order
* Why VPC cannot be destroyed first
* What are leaf nodes

Then run:
terraform destroy

Observe reverse graph traversal.

---

# 🧪 Rebuild Test (Mandatory)

After destroy:

Create new directory.

Rebuild entire infrastructure from memory.

No docs open.

If you struggle:
Repeat.

---

# 🚨 Rules (Non-Negotiable)

* No copy-paste templates
* No GitHub reference
* No YouTube tutorials
* Use AWS provider documentation only
* Predict graph execution before every plan
* Predict state changes before every apply

---

# 🧠 End-of-Day Evaluation

By tonight, I must be able to explain:

* Implicit vs explicit dependency
* How Terraform builds DAG
* What gets stored in state
* Why EC2 can exist without internet
* Why internet does not guarantee connectivity
* Why destruction is reverse graph order

If Terraform still feels fuzzy,
Phase 2 does not move forward.
