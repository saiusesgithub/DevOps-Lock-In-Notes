# 🔒 DevOps Lock-In — Phase 2 (Terraform)

# 📅 Day 7 Reflection — Real AWS Infrastructure (From Scratch)

# 🗓 Date: February 13, 2026

---

# 🎯 Objective of Day 7

Build complete AWS infrastructure from a blank directory without templates and validate it by SSHing into EC2 — then destroy everything while understanding graph order.

---

# 🪜 Exact Steps Executed Today

## 1️⃣ Environment Setup

* Created fresh directory (no reuse of old files)
* Wrote:

  * terraform block with required_providers
  * aws provider using var.region
  * variables.tf and terraform.tfvars
* Ran `terraform init`
* Observed provider installation and lock file creation

### Key Learning

* `.terraform.lock.hcl` ensures deterministic provider versions
* Terraform backend initialized locally

---

## 2️⃣ VPC Creation

* Created `aws_vpc.main`
* Added CIDR block
* Added Name + environment tags
* Ran `terraform plan` → saw single resource creation
* Applied successfully

### Key Learning

* AWS automatically creates default route table, default SG, default NACL
* Tags update is in-place (not ForceNew)
* Manual deletion in console triggers drift detection

---

## 3️⃣ Subnet Creation

* Created `aws_subnet.main`
* Referenced VPC via `vpc_id = aws_vpc.main.id`
* Added availability_zone
* Enabled `map_public_ip_on_launch = true`
* Observed implicit dependency

### Key Learning

* Subnet exists inside ONE AZ
* Dependency graph is built via attribute references
* Plan output order ≠ execution order

---

## 4️⃣ Internet Gateway

* Created `aws_internet_gateway.gw`
* Attached to VPC

### Key Learning

* IGW alone does NOT give internet
* IGW belongs to VPC, not subnet
* Networking requires multiple aligned components

---

## 5️⃣ Route Table + Route + Association

* Created `aws_route_table.rt`
* Added route `0.0.0.0/0 → IGW`
* Created `aws_route_table_association.a`
* Associated route table with subnet

### Key Learning

* Default route table exists but does not include internet route
* Internet requires:

  1. IGW attached
  2. Route to IGW
  3. Association to subnet
* Association creates real traffic path

---

## 6️⃣ Security Group

* Created `aws_security_group.web_sg`
* Allowed inbound:

  * SSH (22)
  * HTTP (80)
* Allowed all outbound

### Key Learning

* Security Groups are stateful
* SG attaches to ENI (via EC2)
* Public subnet does NOT guarantee access — SG controls traffic

---

## 7️⃣ EC2 Instance

* Created `aws_instance.ec2_instance`
* Used manual AMI lookup
* Attached:

  * subnet_id
  * vpc_security_group_ids
* Initially forgot key pair
* Added `key_name` → saw ForceNew behavior
* Applied and successfully SSHed

### Key Learning

* key_name is ForceNew attribute
* EC2 depends on subnet + SG
* Route table is indirect dependency
* Full network chain validated through SSH

---

## 8️⃣ Destroy

* Ran `terraform destroy`
* Observed reverse graph order

### Destruction Order Observed

* EC2 destroyed first
* Then route table association
* Then route table
* Then internet gateway
* Then subnet
* Then VPC

### Key Learning

* Terraform walks DAG in reverse for destruction
* Resource identity is based on `resource_type.resource_name`
* Renaming resource blocks triggers destroy/create

---

# 🧠 Conceptual Strengths Gained

* Understood implicit dependency via attribute reference
* Understood ForceNew vs in-place update
* Understood drift detection
* Understood infrastructure layering
* Understood that Terraform manages graph, not architecture validity

---

# ⚠️ Honest Weakness Identified

Cloud fundamentals (AWS networking concepts) felt rusty during:

* AZ vs Region distinction
* Route table behavior
* Default route table logic
* Internet path reasoning
* Key pair mechanism

Terraform syntax felt manageable.
Cloud architecture intuition needs strengthening.

---

# 🎯 Strategic Insight

Terraform mastery without cloud fundamentals = fragile confidence.

Cloud intuition should precede advanced Terraform patterns.

---

# 📌 Conclusion of Day 7

Terraform is no longer fuzzy.

Cloud networking fundamentals need reinforcement.

Day 7 achieved mechanical infrastructure build.
Next focus should balance:

* AWS architecture understanding
* Terraform graph fluency

Lock-In progress: Significant.
Cloud depth: Needs reinforcement.
