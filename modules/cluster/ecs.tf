resource "aws_ecs_cluster" "ecs_main" {
  depends_on = [
    aws_autoscaling_group.autoscaling
  ]
  name = "Cluster-${var.env}-${var.app}"
  capacity_providers = [aws_ecs_capacity_provider.test.name]
}

# Task definition======================= 
resource "aws_ecs_task_definition" "task_def" {
  family = "telebot"
  container_definitions = jsonencode([
    {
      name = "telebot-${var.app}-${var.env}"
      image = "${var.ecr_repository_url}:${var.image_version}"
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

# Service======================= 
resource "aws_ecs_service" "service" {
  capacity_provider_strategy {
  capacity_provider = aws_ecs_capacity_provider.test.name
  weight = 1
  base = 0
}
  name = "Service-${var.app}-${var.env}"
  cluster = aws_ecs_cluster.ecs_main.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count = 1
  deployment_minimum_healthy_percent = "90"
  
  load_balancer {
    target_group_arn = aws_alb_target_group.tg_alb.arn
    container_name = "telebot-${var.app}-${var.env}"
    container_port = var.app_port
  }
}

# Capacity provider===============================
resource "aws_ecs_capacity_provider" "test" {
  name = "CP-${var.env}-${var.app}"
  
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.autoscaling.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = var.az_count*2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
      
    }
  }

}