
# NOTE:
# - For Task-2 import: keep config minimal as lab says.
# - After Task-6: update network_interface to include subnetwork.
# - machine_type should be e2-standard-2 after Task-4 for all instances.

resource "google_compute_instance" "tf_instance_1" {
  name         = "tf-instance-1"
  machine_type = "e2-standard-2"
  zone         = var.zone

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      # ✅ set to the SAME image as the pre-created VM (from console)
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    # Task-2: can be default network if needed for import
    # Task-6: connect to VPC + subnet-01
    network    = var.network
    subnetwork = var.subnet_1

    access_config {}
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
}

resource "google_compute_instance" "tf_instance_2" {
  name         = "tf-instance-2"
  machine_type = "e2-standard-2"
  zone         = var.zone

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      # ✅ set to the SAME image as the pre-created VM (from console)
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    # Task-6: connect to VPC + subnet-02
    network    = var.network
    subnetwork = var.subnet_2

    access_config {}
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
}

# Task-4 create, Task-5 destroy by setting create_instance_3=false (or removing this resource)
resource "google_compute_instance" "tf_instance_3" {
  count        = var.create_instance_3 ? 1 : 0
  name         = var.instance_3_name
  machine_type = "e2-standard-2"
  zone         = var.zone

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet_1
    access_config {}
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
}
