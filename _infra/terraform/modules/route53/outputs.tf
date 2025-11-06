output "validation_record_fqdns" {
  description = "Fully qualified domain names of the ACM validation records."
  value       = [for record in aws_route53_record.validation : record.fqdn]
}

output "alias_record_fqdns" {
  description = "Fully qualified domain names of the alias records pointing to CloudFront."
  value       = [
    for record in aws_route53_record.alias_a :
    record.fqdn
  ]
}
