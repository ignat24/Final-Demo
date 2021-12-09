# Repository for telebot
resource "aws_ecr_repository" "ecr_repository_bot" {
  name = "${var.app}-${var.env}"
}

# Repository for web-page
resource "aws_ecr_repository" "ecr_repository_page" {
  name = "${var.app}-${var.env}-page"
}