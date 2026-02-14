terraform {
  backend "gcs" {
    bucket = "BUCKET_NAME"
    prefix = "terraform/state"
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
  force_destroy                 = true
}
