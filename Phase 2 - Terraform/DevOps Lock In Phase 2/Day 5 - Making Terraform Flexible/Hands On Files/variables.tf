variable "bucket_name" {
    type = string
    description = "The name of the S3 bucket to create"
    default = "test_terraform_bucket"
    validation {
      condition = length(var.bucket_name) > 3 && can(regex("^[a-z0-9.-]+$", var.bucket_name))
      error_message = "The bucket name must be at least 4 characters long and contain only lowercase letters, numbers, dots, and hyphens."
    }
}

variable "environment" {
  type = string
  description = "The environment for the deployment"
  default = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "enable_destroy" {
  type    = bool
  default = false
}

variable "app_name" {
  type    = string
  default = "test_app"
}

output "bucket_arn" {
  value = aws_s3_bucket.demo_bucket.arn
}

output "vpc_id" {
  value = aws_vpc.main.id
}