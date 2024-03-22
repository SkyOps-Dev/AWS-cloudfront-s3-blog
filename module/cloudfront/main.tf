resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.cloudfront.comment
}
locals {
  s3_origin_id = var.cloudfront.website
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.bucket_id
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = var.cloudfront.status
  is_ipv6_enabled     = var.cloudfront.status
  comment             = var.cloudfront.website
  default_root_object = var.cloudfront.suffix
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = var.cloudfront.status
      cookies {
        forward = var.cloudfront.forward
      }
    }

    viewer_protocol_policy = var.cloudfront.viewer_protocol_policy
    min_ttl                = var.cloudfront.min_ttl
    default_ttl            = var.cloudfront.default_ttl
    max_ttl                = var.cloudfront.max_ttl
  }
  price_class = var.cloudfront.price_class
  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront.forward
    }
  }
  viewer_certificate {
    ssl_support_method             = var.cloudfront.ssl_support_method
    acm_certificate_arn            = var.acmcertificate_id
    cloudfront_default_certificate = var.cloudfront.cloudfront_default_certificate
  }
}
