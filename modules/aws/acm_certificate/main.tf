data "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone_name
}

resource "aws_acm_certificate" "domain_certificate" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.subject_alternative_names

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_validation" {
  count = length([for domain in concat([var.domain_name], var.subject_alternative_names) : domain if domain != "*.${var.domain_name}"])

  name    = tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[count.index].resource_record_name
  type    = tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[count.index].resource_record_type
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  records = [
    tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[count.index].resource_record_value
  ]
  allow_overwrite = var.allow_overwrite
  ttl             = 60
}

resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn         = aws_acm_certificate.domain_certificate.arn
  validation_record_fqdns = aws_route53_record.domain_validation[*].fqdn
}
