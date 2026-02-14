variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}