data "aws_route53_zone" "existing_zone" {
  name         = "__R53_DOMAIN_NAME__"
  private_zone = false
}
