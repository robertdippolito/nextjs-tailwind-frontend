variable "name" {
  description = "Friendly name for the CloudFront distribution and related resources."
  type        = string
}

variable "comment" {
  description = "Optional comment to describe the CloudFront distribution."
  type        = string
  default     = ""
}

variable "enabled" {
  description = "Whether the CloudFront distribution is enabled."
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "Default object served when no object is specified (e.g., index.html)."
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Price class for the CloudFront distribution."
  type        = string
  default     = "PriceClass_100"
}

variable "aliases" {
  description = "Custom domain names (CNAMEs) for the CloudFront distribution."
  type        = list(string)
  default     = []
}

variable "default_cache_behavior_min_ttl" {
  description = "Minimum amount of time (in seconds) that objects stay in the cache."
  type        = number
  default     = 0
}

variable "default_cache_behavior_default_ttl" {
  description = "Default amount of time (in seconds) that objects stay in the cache."
  type        = number
  default     = 3600
}

variable "default_cache_behavior_max_ttl" {
  description = "Maximum amount of time (in seconds) that objects stay in the cache."
  type        = number
  default     = 86400
}

variable "s3_bucket_id" {
  description = "ID (name) of the S3 bucket to use as the CloudFront origin."
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to use as the CloudFront origin."
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket (regional) to use as the CloudFront origin."
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS. Leave null to use the default CloudFront certificate."
  type        = string
  default     = null
}

variable "ssl_support_method" {
  description = "Method used to serve HTTPS when a custom certificate is attached."
  type        = string
  default     = "sni-only"
}

variable "minimum_protocol_version" {
  description = "Minimum TLS protocol version for viewers when using a custom certificate."
  type        = string
  default     = "TLSv1.2_2021"
}

variable "tags" {
  description = "Map of tags to assign to the CloudFront distribution."
  type        = map(string)
  default     = {}
}
