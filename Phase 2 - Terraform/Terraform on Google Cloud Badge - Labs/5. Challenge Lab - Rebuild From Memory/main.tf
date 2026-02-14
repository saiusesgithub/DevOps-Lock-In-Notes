terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # ✅ After Task-3 (remote backend), replace this block with the GCS backend block shown below,
  # then run: terraform init -migrate-state
  # backend "gcs" {
  #   bucket = "BUCKET_NAME"         # <- created by storage module
  #   prefix = "terraform/state"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "instances" {
  source     = "./modules/instances"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  # used for 3rd instance in task-4 (and removed in task-5)
  instance_3_name = var.instance_3_name
  create_instance_3 = var.create_instance_3

  # connect to VPC module (task-6)
  network    = module.vpc.network_name
  subnet_1   = module.vpc.subnets_names[0]
  subnet_2   = module.vpc.subnets_names[1]
}

# ---- Task 3: storage bucket for backend
module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  bucket_name = var.backend_bucket_name
}

# ---- Task 6: VPC module from registry (version 10.0.0)
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "10.0.0"

  project_id   = var.project_id
  network_name = var.vpc_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = var.region
    }
  ]
}

# ---- Task 7: firewall
resource "google_compute_firewall" "tf_firewall" {
  name    = "tf-firewall"
  network = module.vpc.network_name

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

