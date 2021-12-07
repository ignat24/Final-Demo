output "load_balancer_dns" {
  value = aws_alb.alb.dns_name
}