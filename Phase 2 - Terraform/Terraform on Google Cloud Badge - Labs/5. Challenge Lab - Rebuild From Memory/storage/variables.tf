variable "project_id" { type = string }
variable "region"     { type = string }
variable "zone"       { type = string }

variable "bucket_name" {
  type        = string
  description = "Remote backend bucket name (Bucket Name given by lab)"
}
