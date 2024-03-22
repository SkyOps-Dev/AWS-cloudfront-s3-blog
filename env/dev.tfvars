s3 = {
  bucket       = "joweboyswebsite8556"
  status       = "Disabled"
  suffix       = "index.html"
  access_block = "true"
}
cloudfront = {
  comment                        = "s3.joweboyswebsite8556.com"
  website                        = "joweboyswebsite8556"
  suffix                         = "index.html"
  status                         = true
  forward                        = "none"
  viewer_protocol_policy         = "redirect-to-https"
  min_ttl                        = 0
  default_ttl                    = 3600
  max_ttl                        = 86400
  price_class                    = "PriceClass_200"
  ssl_support_method             = "sni-only"
  cloudfront_default_certificate = false
}
route53 = {
  private_zone      = false
  validation_method = "DNS"
  ttl               = 60
}
