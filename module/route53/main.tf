data "aws_route53_zone" "selected" {
  name         = "hosted_zone_name" # Replace 'hosted_zone_name' with your hosted zone name
  private_zone = var.route53.private_zone
}

resource "aws_route53_record" "aws_route53_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "record_name" # Replace 'record_name' with your desired record name
  type    = "A"
  alias {
    name                   = var.domain_name
    zone_id                = var.hosted_zone_id
    evaluate_target_health = false
  }
}
resource "aws_acm_certificate" "acm_certificate" {
  domain_name       = "your_domain_name" # Replace 'your_domain_name' with your domain name
  validation_method = var.route53.validation_method
  lifecycle {
    create_before_destroy = true
  }
}
# Route53 resources to perform DNS auto validation
resource "aws_route53_record" "record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = dvo.domain_name == "example.org" ? data.aws_route53_zone.selected.zone_id : data.aws_route53_zone.selected.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.route53.ttl
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "example" {

  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]

}