terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}

provider "google" {
  project = "PROJECT_ID"
  region  = "REGION"
}

resource "google_storage_bucket" "test-bucket-for-state" {
  name                          = "BUCKET_NAME"
  location                      = "US"
  uniform_bucket_level_access   = true
}
