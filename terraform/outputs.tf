output "alb_dns_name" {
  description = "The DNS name of the Load Balancer to access the website"
  value       = aws_lb.web_alb.dns_name
}
