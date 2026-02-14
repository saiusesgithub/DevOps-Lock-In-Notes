#############################################
# Terraform Configuration Block
#############################################

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

#############################################
# Provider Configuration
#############################################

provider "google" {
  project = "PROJECT_ID"   # Replace with your lab project ID
  region  = "REGION"       # e.g. us-central1
  zone    = "ZONE"         # e.g. us-central1-a
}

#############################################
# VPC Network
#############################################

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

#############################################
# Static IP Address
#############################################

resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

#############################################
# Compute Instance
#############################################

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"
  tags         = ["web", "dev"]

  ###########################################
  # Boot Disk (after destructive change)
  ###########################################

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  ###########################################
  # Network Interface (with static IP)
  ###########################################

  network_interface {
    network = google_compute_network.vpc_network.self_link

    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }

  ###########################################
  # Provisioner (local-exec)
  ###########################################

  provisioner "local-exec" {
    command = "echo ${google_compute_instance.vm_instance.name}: ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  }
}


# Special Commands - 

# # Save plan
# terraform plan -out static_ip
# terraform apply static_ip

# # Taint instance to rerun provisioner
# terraform taint google_compute_instance.vm_instance
# terraform apply