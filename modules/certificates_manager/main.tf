resource "aws_acm_certificate" "my_cert" {
  domain_name       = var.application_domain_name
  validation_method = "DNS"
}


resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.my_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "null_resource" "wait_for_cert_validation" {
  provisioner "local-exec" {
    command = "sleep 300" # Wait for 5 minutes (adjust as needed)
  }

  depends_on = [aws_route53_record.cert_validation]
}
