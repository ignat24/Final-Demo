# alb.tf

# Application load balancer
resource "aws_alb" "alb" {
  name = "ALB-${var.env}-${var.app}"
  subnets = var.public_subnet_ids
  security_groups = [aws_security_group.sg_alb.id]

  tags = {
    "Name" = "ALB-${var.env}-${var.app}"
  }
}


# Application load balancer target group for page
resource "aws_alb_target_group" "tg_alb_page" {
  port = var.app_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  

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
    "Name" = "ALB-TG-Page-${var.env}-${var.app}"
  }
}

# Application load balancer target group for telebot
resource "aws_alb_target_group" "tg_alb_bot" {
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
    "Name" = "ALB-TG-bot-${var.env}-${var.app}"
  }
}


# Application load balancer listener
resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port = var.listener_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tg_alb_page.arn
    type = "forward"
  }
}


resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port = var.listener_port_telegram
  protocol = "HTTPS"
  # Certificate I created manualy and use it here
  certificate_arn = "arn:aws:acm:eu-central-1:873827770697:certificate/e31ce023-57d2-4675-bc88-299c8b7349f3"

  default_action {
    target_group_arn = aws_alb_target_group.tg_alb_bot.arn
    type = "forward"
  }
}
