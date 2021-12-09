provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

resource "aws_ecr_repository" "ecr_repository_bot" {
  name = "${var.app}-${var.env}"
}

resource "aws_ecr_repository" "ecr_repository_page" {
  name = "${var.app}-${var.env}-page"
}