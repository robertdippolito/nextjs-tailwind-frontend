terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

locals {
  alias_record_names = toset(concat([var.domain_name], var.additional_alias_names))

  validation_records = {
    for domain in var.validation_domains :
    domain => lookup(var.domain_validation_records, domain, null)
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for domain, record in local.validation_records : domain => record
    if record != null
  }

  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = var.validation_record_ttl
  zone_id = var.hosted_zone_id
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  provider                = aws.us_east_1
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

resource "aws_route53_record" "alias_a" {
  for_each = local.alias_record_names

  zone_id = var.hosted_zone_id
  name    = each.value
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = var.distribution_domain_name
    zone_id                = var.distribution_hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_acm_certificate_validation.this]
}

resource "aws_route53_record" "alias_aaaa" {
  for_each = local.alias_record_names

  zone_id = var.hosted_zone_id
  name    = each.value
  type    = "AAAA"
  allow_overwrite = true

  alias {
    name                   = var.distribution_domain_name
    zone_id                = var.distribution_hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_acm_certificate_validation.this]
}
