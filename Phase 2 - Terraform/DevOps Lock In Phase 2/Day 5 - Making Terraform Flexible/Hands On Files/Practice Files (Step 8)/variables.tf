variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
  # default     = "terraform_test_bucket"
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

output "arn" {
  description = "The ARN of the created S3 bucket"
  value       = aws_s3_bucket.demo_bucket.arn
}