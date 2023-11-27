resource "aws_acm_certificate" "cert" {
  provider                  = aws.acm_provider
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


data "aws_route53_zone" "zone" {
  provider     = aws.acm_provider
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.acm_provider
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
      # zone_id = dvo.domain_name == "zone" ? data.aws_route53_zone.example_org.zone_id : data.aws_route53_zone.cert.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm_provider
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}



# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.zone.id
#   name    = "www.${var.domain_name}"
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.cdn_static_site.domain_name
#     zone_id                = aws_cloudfront_distribution.cdn_static_site.hosted_zone_id
#     evaluate_target_health = false
#   }
# }




# resource "aws_route53_record" "www" {
#   zone_id = "Z09214101IU8I71TAQICS"
#   name    = "www.${var.domain_name}"
#   type    = "A"
#   alias {
#     name                   = aws_cloudfront_distribution.cdn_static_site.domain_name
#     zone_id                = aws_cloudfront_distribution.cdn_static_site.hosted_zone_id
#     evaluate_target_health = false
#   }
# }
#   output "debug" {
#   value = aws_route53_record.www
# }

# resource "aws_route53_record" "apex" {
#   zone_id = "Z09214101IU8I71TAQICS"
#   name    = var.domain_name
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.cdn_static_site.domain_name
#     zone_id                = aws_cloudfront_distribution.cdn_static_site.hosted_zone_id
#     evaluate_target_health = false
#   }
# }
