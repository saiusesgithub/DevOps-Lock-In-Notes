variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "zone" {
  type        = string
  description = "GCP zone"
}

# Challenge-lab provided names
variable "backend_bucket_name" {
  type        = string
  description = "Bucket Name (given by lab) for remote backend bucket"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name (given by lab)"
}

# Third instance (Task-4 / Task-5)
variable "instance_3_name" {
  type        = string
  description = "Instance Name (given by lab)"
  default     = "instance-3"
}

variable "create_instance_3" {
  type        = bool
  description = "Set true for Task-4, set false for Task-5"
  default     = false
}
