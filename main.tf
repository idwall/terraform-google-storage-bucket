# Versioning
terraform {
  required_version = ">= 0.11.13"

  required_providers {
    google = ">= 2.3.0"
  }
}

# Pull information from current gcloud client config
data "google_client_config" "current" {}

# Set the log bucket name

# Storage Bucket
resource "google_storage_bucket" "bucket" {
  count         = "${length(var.names)}"
  name          = "${var.names[count.index]}"
  location      = "${var.location != "" ? var.location : data.google_client_config.current.region}"
  project       = "${var.project != "" ? var.project : data.google_client_config.current.project}"
  storage_class = "${var.storage_class}"
  force_destroy = "${var.force_destroy}"
  labels        = "${var.labels}"

  # TODO Should be set to "${var.prevent_destroy}" once https://github.com/hashicorp/terraform/issues/3116 is fixed.
  lifecycle {
    prevent_destroy = true
  }

  lifecycle_rule = "${var.lifecycle_rules}"

  logging {
    log_bucket = "${var.names[count.index]}_logs"
  }

  versioning {
    enabled = "${var.versioning}"
  }
}

# Logging for Storage Bucket
resource "google_storage_bucket" "logging" {
  count         = "${var.logging ? length(google_storage_bucket.bucket.*.name) : 0}"
  name          = "${google_storage_bucket.bucket.*.name[count.index]}_logs"
  location      = "${var.location != "" ? var.location : data.google_client_config.current.region}"
  project       = "${var.project != "" ? var.project : data.google_client_config.current.project}"
  storage_class = "${var.storage_class}"
  force_destroy = "${var.force_destroy}"
  labels        = "${var.labels}"

  # TODO Should be set to "${var.prevent_destroy}" once https://github.com/hashicorp/terraform/issues/3116 is fixed.
  lifecycle {
    prevent_destroy = true
  }

  lifecycle_rule {
    "action" {
      type = "Delete"
    }

    "condition" {
      age = 3600
    }
  }
}

# Bucket ACL
resource "google_storage_bucket_iam_binding" "binding" {
  count  = "${length(var.members) > 0 ? 1 : 0}"
  bucket = "${google_storage_bucket.bucket.*.name[count.index]}"
  role   = "roles/${var.role}"

  members = [
    "${var.members}",
  ]
}
