variable "hosted_zone_id" {
  description = "ID of the existing Route 53 hosted zone."
  type        = string
}

variable "domain_name" {
  description = "Primary domain name for DNS records."
  type        = string
}

variable "additional_alias_names" {
  description = "Additional domain names to alias to the CloudFront distribution."
  type        = list(string)
  default     = []
}

variable "domain_validation_options" {
  description = "Domain validation options from ACM used to create DNS validation records."
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}

variable "validation_domains" {
  description = "Domains that require ACM validation records."
  type        = list(string)
}

variable "domain_validation_records" {
  description = "Map of domain names to their ACM validation record details."
  type = map(object({
    name  = string
    type  = string
    value = string
  }))
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate to validate."
  type        = string
}

variable "distribution_domain_name" {
  description = "Domain name of the CloudFront distribution."
  type        = string
}

variable "distribution_hosted_zone_id" {
  description = "Route 53 hosted zone ID for the CloudFront distribution."
  type        = string
  default     = "Z2FDTNDATAQYW2"
}

variable "validation_record_ttl" {
  description = "TTL for validation CNAME records."
  type        = number
  default     = 60
}
