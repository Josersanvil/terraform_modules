data "aws_route53_zone" "domain" {
  name = var.domain_name
}

resource "aws_ses_domain_identity" "identity" {
  domain = var.domain_name
}

resource "aws_route53_record" "verification_record" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.identity.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.identity.verification_token]

  lifecycle {
    ignore_changes = [records]
  }
}

resource "aws_ses_domain_identity_verification" "josersanvil_domain_verification" {
  domain = aws_ses_domain_identity.identity.id

  depends_on = [aws_route53_record.verification_record]
}

# Verify with DKIM
resource "aws_ses_domain_dkim" "domain_dkim" {
  domain = aws_ses_domain_identity.identity.domain
}

# Publish DKIM records
resource "aws_route53_record" "domain_dkim_verification_record" {
  count           = 3
  zone_id         = data.aws_route53_zone.domain.zone_id
  name            = "${aws_ses_domain_dkim.domain_dkim.dkim_tokens[count.index]}._domainkey"
  type            = "CNAME"
  ttl             = "600"
  records         = ["${aws_ses_domain_dkim.domain_dkim.dkim_tokens[count.index]}.dkim.amazonses.com"]
  allow_overwrite = true
}
