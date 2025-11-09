output "distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "Domain name assigned to the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "origin_access_control_id" {
  description = "ID of the CloudFront origin access control."
  value       = aws_cloudfront_origin_access_control.this.id
}

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID associated with the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}
