variable "name" {
  description = "The name of the bucket."
  type        = string
}

variable "project_id" {
  description = "The ID of the project to create the bucket in."
  type        = string
}

variable "location" {
  description = "The location of the bucket."
  type        = string
}

variable "storage_class" {
  type    = string
  default = null
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "versioning" {
  type    = bool
  default = true
}

variable "force_destroy" {
  type    = bool
  default = true
}

variable "retention_policy" {
  type = object({
    is_locked        = bool
    retention_period = number
  })
  default = null
}

variable "encryption" {
  type = object({
    default_kms_key_name = string
  })
  default = null
}

variable "lifecycle_rules" {
  type    = list(any)
  default = []
}
