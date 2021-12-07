# alb.tf


# Application load balancer======
resource "aws_alb" "alb" {
  name = "ALB-${var.env}-${var.app}"
  subnets = var.public_subnet_ids
  security_groups = [aws_security_group.sg_alb.id]

  tags = {
    "Name" = "ALB-${var.env}-${var.app}"
  }
}


# Application load balancer target group========
resource "aws_alb_target_group" "tg_alb" {
  port = var.app_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

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


# Application load balancer listener
resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port = var.listener_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tg_alb.arn
    type = "forward"
  }
}

resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = "arn:aws:acm:eu-central-1:873827770697:certificate/b1d5a09c-f5ca-482e-a26d-6470f84dde1c"

  default_action {
    target_group_arn = aws_alb_target_group.tg_alb.arn
    type = "forward"
  }
}
