terraform {
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "devops-lockin-demo-vpc"
  }
}

resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "devops-lockin-demo-subnet"
  }
}

resource "aws_security_group" "demo_sg" {
  name   = "devops-lockin-demo-sg"
  vpc_id = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-lockin-demo-sg"
  }
}

resource "aws_s3_bucket" "parallel_one" {
  bucket = "lockin-parallel-one-123"
}

# resource "aws_s3_bucket" "parallel_two" {
#   bucket = "lockin-parallel-two-456"
# }

resource "aws_s3_bucket" "parallel_two" {
  bucket = "lockin-parallel-two-456"

  depends_on = [aws_s3_bucket.parallel_one]
}

resource "null_resource" "a" {
  # depends_on = [null_resource.b]
}

resource "null_resource" "b" {
  depends_on = [null_resource.a]
}