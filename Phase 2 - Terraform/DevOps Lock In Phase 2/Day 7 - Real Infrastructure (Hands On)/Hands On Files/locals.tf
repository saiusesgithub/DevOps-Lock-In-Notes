locals {
  project     = "devops-lockin-practice"
  environment = var.environment
  base_name   = "${local.project}-${local.environment}"
}