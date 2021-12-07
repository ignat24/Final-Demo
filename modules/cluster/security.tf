# security.tf


# Security group fo ALB=========
resource "aws_security_group" "sg_alb" {
    name = "SG-ALB-${var.env}-${var.app}"
    vpc_id = var.vpc_id


    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = [var.cidr_block_route]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = [var.cidr_block_route]
    }

    tags = {
      "Name" = "SG-ALB-${var.env}-${var.app}"
    }
}

# Security group for ECS
resource "aws_security_group" "sg_ecs" {
  name = "SG-ECS-${var.env}-${var.app}"
  vpc_id = var.vpc_id

  ingress {
      protocol = "tcp"
      from_port = var.app_port
      to_port = var.app_port
      cidr_blocks = [var.cidr_block_route]
  }

  egress {
      protocol = "-1"
      from_port = 0
      to_port = 0
      cidr_blocks = [var.cidr_block_route]
  }
}