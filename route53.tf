resource "aws_route53_record" "api_alb" {
  zone_id = "Z03652023DT22EUZ3ILDL"
  name    = "api.eatfit.site"
  type    = "A"

  alias {
    name                   = aws_lb.eatfit_alb.dns_name
    zone_id                = aws_lb.eatfit_alb.zone_id
    evaluate_target_health = true
  }
}
