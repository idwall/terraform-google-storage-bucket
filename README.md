# Google Storage Bucket


This terraform module provisions one or more Google Cloud Storage buckets with ACLs. There is also the option of creating an additional bucket to store audit and access logs if you provide `logging = true` to the module parameters.

## Usage Example

```hcl
module "my_bucket" {
  source             = "git@github.com:dansible/terraform-google-storage-bucket.git?ref=v1.1.0"

  # Required Parameters:
  names              = ["${var.bucket_names}"]

  # Optional Parameters:
  location           = "${var.region}"
  project            = "${var.project}"
  storage_class      = "REGIONAL"
  default_acl        = "projectPrivate"
  force_destroy      = "true"
  logging            = true
  versioning         = true

  labels = {
    "provisioner" = "terraform"
  }

  lifecycle_rules = [{
    action = [{
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }]

    condition = [{
      age                   = 60
      created_before        = "2018-08-20"
      is_live               = false
      matches_storage_class = ["REGIONAL"]
      num_newer_versions    = 10
    }]
  }]

  role = storage.objectCreator

  members = [
    "serviceAccount:service@service.com",
    "user:user@user.com"
  ]
}
```


You can then reuse the bucket as a remote data source:

```hcl
data "terraform_remote_state" "gcs_bucket" {
  backend = "gcs"

  config {
    bucket = "${module.my_bucket.bucket_name}" # Must be referenced through module output
  }
}
```

## Inputs

| Name             | Description                                                                                                                             |  Type  |     Default     | Required |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------- | :----: | :-------------: | :------: |
| force\_destroy   | When deleting a bucket, this boolean option will delete all contained objects.                                                          | string |    `"false"`    |    no    |
| labels           | A set of key/value label pairs to assign to the bucket.                                                                                 |  map   |     `<map>`     |    no    |
| lifecycle\_rules | The bucket's Lifecycle Rules configuration. See README for examples                                                                     |  list  |    `<list>`     |    no    |
| location         | The GCS location. If it is not provided, the region configured in the gcloud client is used.                                            | string |      `""`       |    no    |
| logging          | When set to true, enable the bucket's Access and Storage Logs configuration and create a storage_bucket for them.                       | string |    `"false"`    |    no    |
| members          | List of members added to the created buckets.                                                                                           |  list  |    `<list>`     |    no    |
| names            | The name of the bucket                                                                                                                  |  list  |       n/a       |   yes    |
| project          | The ID of the google project to which the resource belongs. If it is not provided, the project configured in the gcloud client is used. | string |      `""`       |    no    |
| role             | Default buket role for the bucket member.                                                                                               | string | `"storage.get"` |    no    |
| storage\_class   | The Storage Class of the new bucket. Supported values are: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE.                                | string |  `"REGIONAL"`   |    no    |
| versioning       | While set to true, versioning is fully enabled for this bucket.                                                                         | string |    `"false"`    |    no    |

## Outputs

| Name              | Description                                                   |
| ----------------- | ------------------------------------------------------------- |
| bucket\_names     | The name of bucket.                                           |
| log\_bucket\_name | The name of the access log bucket.                            |
| self\_link        | The URI of the created resource.                              |
| url               | The base URL of the bucket, in the format gs://<bucket-name>. |

## Links

- https://www.terraform.io/docs/providers/google/r/storage_bucket.html
- https://www.terraform.io/docs/providers/google/r/storage_bucket_acl.html
- https://github.com/nephosolutions/terraform-google-gcs-bucket.git
- https://github.com/SweetOps/terraform-google-storage-bucket

