resource "aws_route53_zone" "main" {
  name = "test-zone.com"
}

resource "aws_route53_record" "main_application_record" {
  zone_id = aws_route53_zone.main.id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.elb_dns_name
    zone_id                = var.elb_zone_id
    evaluate_target_health = true
  }
}
