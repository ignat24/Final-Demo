data "aws_availability_zones" "avaliable"{

}

variable "app" {
    default = "bot"
}

variable "env" {
    default = "dev"
}

variable "aws_region" {
    default = "eu-central-1"
}

variable "az_count" {
    default = 2
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}