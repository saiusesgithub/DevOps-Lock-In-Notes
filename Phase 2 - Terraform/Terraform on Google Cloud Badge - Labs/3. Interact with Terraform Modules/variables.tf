variable "project_id" {
  description = "The ID of the project"
  type        = string
  default     = "PROJECT_ID"
}

variable "name" {
  description = "Bucket name (must be globally unique)"
  type        = string
  default     = "PROJECT_ID-unique"
}
