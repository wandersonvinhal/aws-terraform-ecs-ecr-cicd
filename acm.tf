resource "aws_acm_certificate" "cert" {
  domain_name       = "__R53_DOMAIN_NAME__"
  validation_method = "DNS"

  tags = {
    Name = "example-cert"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = { for d in aws_acm_certificate.cert.domain_validation_options : d.domain_name => d }

  zone_id = data.aws_route53_zone.existing_zone.id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60
  records = [each.value.resource_record_value]
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
