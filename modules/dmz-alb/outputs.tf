output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.alb.arn
}

output "alb_target_group_arn" {
  description = "The ARN of the ALB Target Group"
  value       = aws_alb_target_group.alb_target_group.arn
}