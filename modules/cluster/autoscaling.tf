# # auto_scaling.tf

# # Launch configuration======================= 
# resource "aws_launch_configuration" "ec2_launch" {
#   instance_type = "t2.micro"
#   iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
#   image_id = data.aws_ami.linux2_ecs.id
#   security_groups = [aws_security_group.sg_ecs.id]
#   user_data = "#!/bin/bash\necho ECS_CLUSTER=Cluster-${var.env}-${var.app} > /etc/ecs/ecs.config"
  
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Autoscaling group======================= 
# resource "aws_autoscaling_group" "autoscaling" {
#   name = "AS-${var.app}-${var.env}"
#   launch_configuration = aws_launch_configuration.ec2_launch.name
#   target_group_arns = [aws_alb_target_group.tg_alb.arn]
#   vpc_zone_identifier = var.private_subnet_ids
  
#   health_check_grace_period = 20
#   health_check_type = "EC2"
  
#   protect_from_scale_in = false


#   min_size = var.az_count
#   max_size = var.az_count*3
  
#   lifecycle {
#     create_before_destroy = true
#      }

#   tag {
#     key                 = "AmazonECSManaged"
#     value               = "ecs"
#     propagate_at_launch = true
#   }
# }
