output "ecr_repository_url" {
  value = aws_ecr_repository.ecr_repository_bot.repository_url
}

output "ecr_repository_url_page" {
  value = aws_ecr_repository.ecr_repository_page.repository_url
}