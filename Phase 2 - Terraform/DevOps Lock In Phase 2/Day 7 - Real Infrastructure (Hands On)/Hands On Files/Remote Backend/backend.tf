terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-2"
}

resource "aws_s3_bucket" "terraform-remote-state-bucket" {
  bucket = "terraform-remote-state-bucket-saisrujan"

  tags = {
    Name = "terraform-remote-state-bucket"
  }
}

resource "aws_s3_bucket_versioning" "terraform-remote-state-bucket-versioning" {
  bucket = aws_s3_bucket.terraform-remote-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform-remote-state-lock-table" {
  name           = "terraform-remote-state-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-remote-state-lock-table"
  }
}
