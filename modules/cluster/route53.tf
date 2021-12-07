# route53

data "aws_route53_zone" "selected" {
  name = "ignatdom.website"
  private_zone = false
}

resource "aws_route53_record" "alb_record" {
    zone_id = data.aws_route53_zone.selected.id
    name = "lb.ignatdom.website"
    type = "A"

    alias {
      name = aws_alb.alb.dns_name
      zone_id = aws_alb.alb.zone_id
      evaluate_target_health = true
    }
  
}