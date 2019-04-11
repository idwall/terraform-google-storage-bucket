variable "names" {
  type        = "list"
  description = "The name of the bucket"
}

variable "project" {
  description = "The ID of the google project to which the resource belongs. If it is not provided, the project configured in the gcloud client is used."
  default     = ""
}

variable "location" {
  description = "The GCS location. If it is not provided, the region configured in the gcloud client is used."
  default     = ""
}

variable "storage_class" {
  description = "The Storage Class of the new bucket. Supported values are: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE."
  default     = "REGIONAL"
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects."
  default     = "false"
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the bucket."
  type        = "map"

  default = {
    "provisioner" = "terraform"
  }
}

variable "versioning" {
  description = "While set to true, versioning is fully enabled for this bucket."
  default     = false
}

variable "lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration. See README for examples"
  type        = "list"
  default     = []
}

variable "logging" {
  description = "When set to true, enable the bucket's Access and Storage Logs configuration and create a storage_bucket for them."
  default     = false
}

# ACLs
variable "members" {
  description = "List of members added to the created buckets."
  type        = "list"
  default     = []
}

variable "role" {
  description = "Default buket role for the bucket member."
  type        = "string"
  default     = "storage.get"
}
