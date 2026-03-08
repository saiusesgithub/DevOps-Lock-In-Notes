terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    local = {
      source = "hashicorp/local"
    }
  }
}

provider "aws" {
  region = "ap-south-2"
}


resource "aws_instance" "terraform_ansible_practice" {
  ami           = "ami-0fb67e6212e8ff822"
  instance_type = "t3.micro"
  key_name     = "terraform-ansible-practice"
  tags = {
    Name = "Terraform Ansible Practice"
  }
}

resource "local_file" "ansible_inventory" {

  filename = "../ansible/inventory"

  content = <<EOF
[web]
ec2_server ansible_host=${aws_instance.terraform_ansible_practice.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=terraform-ansible-practice.pem
EOF

}