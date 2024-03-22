provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
module "s3" {
  source        = "../module/s3"
  cloudfront_id = module.cloudfront.cloudfront_id
  oai_id        = module.cloudfront.oai_id
  s3            = var.s3
}
module "route53" {
  source         = "../module/route53"
  domain_name    = module.cloudfront.domain_name
  hosted_zone_id = module.cloudfront.hosted_zone_id
  route53        = var.route53
}
module "cloudfront" {
  source            = "../module/cloudfront"
  bucket_id         = module.s3.bucket_id
  acmcertificate_id = module.route53.acmcertificate_id
  cloudfront        = var.cloudfront
}