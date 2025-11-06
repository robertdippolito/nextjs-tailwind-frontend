terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = var.backend_bucket
    key            = var.backend_bucket_key
    region         = var.aws_region
    dynamodb_table = var.dynamodb_table
    encrypt        = true
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

locals {
  cloudfront_aliases = distinct(concat([var.domain_name], var.subject_alternative_names))
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "robops-live-site-bucket"
}

module "acm" {
  source = "./modules/acm"

  providers = {
    aws = aws.us_east_1
  }

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
}

module "cloudfront" {
  source = "./modules/cloudfront"
  name   = "###"

  s3_bucket_id          = module.s3.bucket_id
  s3_bucket_arn         = module.s3.bucket_arn
  s3_bucket_domain_name = module.s3.bucket_regional_domain_name
  aliases               = local.cloudfront_aliases
  certificate_arn       = module.acm.certificate_arn
}

module "dns" {
  source = "./modules/route53"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  hosted_zone_id              = var.hosted_zone_id
  domain_name                 = var.domain_name
  additional_alias_names      = var.subject_alternative_names
  domain_validation_options   = module.acm.domain_validation_options
  certificate_arn             = module.acm.certificate_arn
  distribution_domain_name    = module.cloudfront.domain_name
  distribution_hosted_zone_id = module.cloudfront.hosted_zone_id
}
