# ecs.tf
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

# Cluster======================= 
resource "aws_ecs_cluster" "ecs_main" {
  name = "Cluster-${var.env}-${var.app}"
  
}

# Task definition======================= 
resource "aws_ecs_task_definition" "task_def" {
  family = "task-${var.app}-${var.env}"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.cpu_fargate
  memory = var.memory_fargate
  container_definitions = jsonencode([
    {
      name = "telebot-${var.app}-${var.env}"
      image = "${var.ecr_repository_url}:${var.image_version}"
      cpu = var.cpu_fargate
      memory = var.memory_fargate
      networkMode = "awsvpc"
      
      portMappings = [
        {
        containerPort = var.app_port
        hostPort = var.app_port
        }
      ]
    }
  ])
}

# Service======================= 
resource "aws_ecs_service" "service" {
  name = "Service-${var.app}-${var.env}"
  cluster = aws_ecs_cluster.ecs_main.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count = 1
  launch_type = "FARGATE"
  
  
  network_configuration {
    security_groups  = [aws_security_group.sg_alb.id]
    subnets          = var.private_subnet_ids
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.tg_alb.arn
    container_name = "telebot-${var.app}-${var.env}"
    container_port = var.app_port
  }
}

