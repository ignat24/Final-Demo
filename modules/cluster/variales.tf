data "aws_availability_zones" "avaliable" {}

data "aws_ami" "linux2_ecs" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

variable "app" {
  default = "default_app_name"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_id" {
  
}
variable "public_subnet_ids" {
  type = set(string)
}

variable "private_subnet_ids" {
  type = set(string)
}
variable "env" {
  default = "default"
}

variable "az_count" {
  default = 1
}

variable "aws_region" {
  
}

variable "aws_dnc" {
  type = bool
  default = true
}

variable "aws_dnc_hostname" {
  type = bool
  default = true
}


variable "cidr_block_route" {
    default = "0.0.0.0/0"
}

variable "app_port" {
  default = 80
}

variable "listener_port" {
  default = 80
}

variable "cpu_fargate" {
  default = 256
}

variable "memory_fargate" {
  default = 512
}


variable "ecr_repository_url" {
  
}

variable "image_version" {
  default = "latest"
}