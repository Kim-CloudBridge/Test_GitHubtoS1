output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.alb.arn
}