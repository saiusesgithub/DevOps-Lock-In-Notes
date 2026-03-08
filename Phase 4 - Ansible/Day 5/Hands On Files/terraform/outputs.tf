output "ec2_public_ip" {
  value = aws_instance.terraform_ansible_practice.public_ip
}