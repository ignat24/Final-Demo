# Main cluster
resource "aws_ecs_cluster" "ecs_main" {
  depends_on = [
    aws_autoscaling_group.autoscaling
  ]
  name = "Cluster-${var.env}-${var.app}"
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]
}


# Task definition for web page
resource "aws_ecs_task_definition" "task_def_page" {
  family = "task-page-${var.app}-${var.env}"
  container_definitions = jsonencode([
    {
      name = "page-${var.app}-${var.env}"
      image = "${var.ecr_repository_url_page}:${var.image_version}"
      cpu = var.cpu_fargate
      memory = var.memory_fargate
      essential = true
      
      portMappings = [
        {
        containerPort = var.app_port
        hostPort = var.app_port
        }
      ]
    }
  ])
}

# Task definition for telebot 
resource "aws_ecs_task_definition" "task_def_bot" {
  family = "task-bot-${var.app}-${var.env}"
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


# Service for web-page
resource "aws_ecs_service" "service_page" {
  capacity_provider_strategy {
  capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  weight = 1
  base = 0
}
  name = "Service-Page-${var.app}-${var.env}"
  cluster = aws_ecs_cluster.ecs_main.id
  task_definition = aws_ecs_task_definition.task_def_page.arn
  desired_count = 2
  deployment_minimum_healthy_percent = "90"
  
  load_balancer {
    target_group_arn = aws_alb_target_group.tg_alb_page.arn
    container_name = "page-${var.app}-${var.env}"
    container_port = var.app_port
  }
}


# Service for telebot
resource "aws_ecs_service" "service_bot" {
  name = "Service-Bot-${var.app}-${var.env}"
  cluster = aws_ecs_cluster.ecs_main.id
  task_definition = aws_ecs_task_definition.task_def_bot.arn
  desired_count = 1
  launch_type = "FARGATE"
  
  network_configuration {
    security_groups  = [aws_security_group.sg_alb.id]
    subnets          = var.private_subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tg_alb_bot.arn
    container_name = "telebot-${var.app}-${var.env}"
    container_port = var.app_port
  }
}


# Capacity provider for web-page
resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "CP-${var.env}-${var.app}"
  
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.autoscaling.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = var.az_count*2
      minimum_scaling_step_size = 2
      status                    = "ENABLED"
      target_capacity           = 100
      
    }
  }
}






