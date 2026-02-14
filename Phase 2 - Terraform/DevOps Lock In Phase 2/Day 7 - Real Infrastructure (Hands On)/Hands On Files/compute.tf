data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "ec2_instance" {
  key_name      = "devops terraform day7"
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.main.id

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "${local.base_name}-ec2"
  }

  lifecycle {
    prevent_destroy = true
  }

}

