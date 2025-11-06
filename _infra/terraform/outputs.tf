output "s3_bucket_id" {
  description = "ID of the S3 bucket for static assets."
  value       = module.s3.bucket_id
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution."
  value       = module.cloudfront.domain_name
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate securing the CloudFront distribution."
  value       = module.acm.certificate_arn
}

output "acm_validation_record_fqdns" {
  description = "Fully qualified validation record names created for ACM DNS validation."
  value       = module.dns.validation_record_fqdns
}

output "cloudfront_alias_record_fqdns" {
  description = "Fully qualified DNS aliases pointing to the CloudFront distribution."
  value       = module.dns.alias_record_fqdns
}
