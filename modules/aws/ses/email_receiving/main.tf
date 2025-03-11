data "aws_region" "current" {}

data "aws_route53_zone" "domain" {
  name = var.route53_hosted_zone_name != null ? var.route53_hosted_zone_name : var.domain_name
}

data "aws_ses_domain_identity" "identity" {
  domain = var.domain_name
}

resource "aws_route53_record" "ses_receiving_record" {
  zone_id         = data.aws_route53_zone.domain.zone_id
  name            = var.subdomain_name != null ? "${var.subdomain_name}.${data.aws_ses_domain_identity.identity.domain}" : data.aws_ses_domain_identity.identity.domain
  type            = "MX"
  ttl             = "600"
  records         = ["10 inbound-smtp.${data.aws_region.current.name}.amazonaws.com"]
  allow_overwrite = true
}
