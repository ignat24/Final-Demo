# Application load balancer======
resource "aws_alb" "alb" {
  name = "ALB-${var.env}-${var.app}"
  subnets = aws_subnet.public_subnets.*.id
  security_groups = [aws_security_group.sg_webserver.id]

  tags = {
    "Name" = "ALB-${var.env}-${var.app}"
  }
}
# resource "aws_route53_zone" "primary" {
#     name = "ignatdom.website"

#     # vpc {
#     #   vpc_id = aws_vpc.main_vpc.id
#     # }
# }

data "aws_route53_zone" "selected" {
  name = "ignatdom.website"
  private_zone = false
}

resource "aws_route53_record" "lb" {
    zone_id = data.aws_route53_zone.selected.zone_id
    # zone_id = aws_route53_zone.primary.zone_id
    name = "lb.ignatdom.website"
    type = "A"

    alias {
        name = aws_alb.alb.dns_name
        zone_id = aws_alb.alb.zone_id
        evaluate_target_health = true
    }
}

# resource "aws_route53_record" "certificate" {
  
# }

resource "aws_acm_certificate" "certificate" {
    domain_name = "ignatdom.website"
    validation_method = "DNS"
    # subject_alternative_names = ["lb.ignatdom.website"]

    lifecycle {
         create_before_destroy = true
    }
}

# Application load balancer target group========
resource "aws_alb_target_group" "tg_alb" {
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main_vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "5"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    "Name" = "ALB-TG-${var.env}-${var.app}"
  }
}

resource "aws_alb_target_group_attachment" "target_attachment" {
  count = var.az_count
  target_group_arn = aws_alb_target_group.tg_alb.arn
  target_id = aws_instance.webserver[count.index].id
  port = 80
}


# Application load balancer listener http
resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tg_alb.arn
    type = "forward"
  }
}

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = "arn:aws:acm:eu-central-1:873827770697:certificate/b1d5a09c-f5ca-482e-a26d-6470f84dde1c"

  default_action {
    target_group_arn = aws_alb_target_group.tg_alb.arn
    type = "forward"
  }
}