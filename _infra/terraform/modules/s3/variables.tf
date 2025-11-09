variable "bucket_name" {
  description = "Name of the S3 bucket to create."
  type        = string
}

variable "tags" {
  description = "Optional tags to apply to the bucket."
  type        = map(string)
  default     = {}
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket."
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Set to true to allow Terraform to delete the bucket even if it is not empty."
  type        = bool
  default     = false
}
