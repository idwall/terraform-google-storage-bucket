# Google Storage Bucket


This Terraform module provisions a Google Cloud Storage bucket with the option of creating an additional bucket to store audit and access logs.

## Usage Example

```hcl
module "google_storage_bucket" {
  source          = "git@github.com:dansible/terraform-google-storage-bucket.git?ref=v1.0.0"
  location        = "${var.region}"
  project         = "${var.project}"
  bucket_name     = "${var.bucket_name}"
  storage_class   = "REGIONAL"
  force_destroy   = "false"
  labels          = { "managed-by" = "terraform" }
  lifecycle_rules = [{
    action = [{
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }]
    condition = [{
      age = 60
      created_before = "2017-06-13"
      is_live = false
      matches_storage_class = ["REGIONAL"]
      num_newer_versions = 10
    }]
  }]
  logging_enabled    = true
  versioning_enabled = true
}
```


## Links

- https://www.terraform.io/docs/providers/google/r/storage_bucket.html
- https://github.com/nephosolutions/terraform-google-gcs-bucket.git
- https://github.com/SweetOps/terraform-google-storage-bucket
