variable "project_id" { type = string }
variable "region"     { type = string }
variable "zone"       { type = string }

# Provided by root after VPC module creation
variable "network"  { type = string } # VPC name
variable "subnet_1" { type = string } # subnet-01 name
variable "subnet_2" { type = string } # subnet-02 name

# Task-4 / Task-5
variable "instance_3_name" {
  type    = string
  default = "instance-3"
}

variable "create_instance_3" {
  type    = bool
  default = false
}
