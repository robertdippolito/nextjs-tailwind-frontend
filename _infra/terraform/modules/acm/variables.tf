variable "domain_name" {
  description = "Primary domain name for the ACM certificate."
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names to include in the certificate."
  type        = list(string)
  default     = []
}

variable "enable_certificate_transparency_logging" {
  description = "Whether to enable certificate transparency logging."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to associate with the certificate."
  type        = map(string)
  default     = {}
}
