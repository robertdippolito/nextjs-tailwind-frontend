terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.subject_alternative_names

  options {
    certificate_transparency_logging_preference = var.enable_certificate_transparency_logging ? "ENABLED" : "DISABLED"
  }

  tags = merge(
    {
      Name = var.domain_name
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}
