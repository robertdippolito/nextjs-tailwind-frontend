variable "aws_region" {
  description = "AWS region where primary resources (S3, Route 53) should be created."
  type        = string
  default = "us-east-1"
}

variable "domain_name" {
  description = "Primary domain name served by CloudFront and secured by ACM."
  type        = string
  default = "###"
}

variable "subject_alternative_names" {
  description = "Additional domain names for the ACM certificate and DNS aliases (e.g., www)."
  type        = list(string)
  default     = []
}

variable "hosted_zone_id" {
  description = "Existing Route 53 hosted zone ID where DNS records will be managed."
  type        = string
}
