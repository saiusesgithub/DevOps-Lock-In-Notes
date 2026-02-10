terraform {}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "demo_bucket" {
    bucket = var.bucket_name
    
}

locals {
  bucket_name = "${var.environment}-${var.app_name}-bucket"
  common_tags = {
    environment = var.environment
    app         = var.app_name
  }
}