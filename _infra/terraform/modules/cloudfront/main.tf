resource "aws_cloudfront_origin_access_control" "this" {
  name                              = var.name
  description                       = var.comment
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  price_class         = var.price_class
  aliases             = var.aliases

  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_id                = "s3-origin-${var.name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = "s3-origin-${var.name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = var.default_cache_behavior_min_ttl
    default_ttl = var.default_cache_behavior_default_ttl
    max_ttl     = var.default_cache_behavior_max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.certificate_arn == null
    acm_certificate_arn            = var.certificate_arn
    ssl_support_method             = var.certificate_arn == null ? null : var.ssl_support_method
    minimum_protocol_version       = var.certificate_arn == null ? null : var.minimum_protocol_version
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

data "aws_iam_policy_document" "oac_access" {
  statement {
    sid = "AllowCloudFrontAccess"

    actions   = ["s3:GetObject"]
    resources = ["${var.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.oac_access.json
}
