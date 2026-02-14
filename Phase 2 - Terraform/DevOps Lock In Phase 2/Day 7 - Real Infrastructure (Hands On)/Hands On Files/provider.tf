terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # backend "s3" {
  #   bucket = "terraform-remote-state-bucket-saisrujan"
  #   key    = "terraform.tfstate"
  #   region = "ap-south-2"
  #   dynamodb_table = "terraform-remote-state-lock-table"
  #   encrypt = true
  # }
}

provider "aws" {
  region = var.region
}