# Terraform configuration to create a Google Compute Engine VM

resource "google_compute_instance" "default" {
  project      = "PROJECT_ID"   # Replace with your actual Project ID
  zone         = "ZONE"         # Replace with your actual zone (e.g., us-west1-c)
  name         = "terraform"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral public IP
    }
  }
}
