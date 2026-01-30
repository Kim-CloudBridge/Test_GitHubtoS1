output "alb_target_group_arn" {
  description = "The ARN of the ALB Target Group"
  value       = aws_alb_target_group.alb_target_group.arn
}

output "nlb_aura_target_group_arn" {
  description = "The ARN of the NLB AURA Target Group"
  value       = aws_lb_target_group.aura_target_group.arn
}

output "nlb_halo_target_group_arn" {
  description = "The ARN of the NLB HALO Target Group"
  value       = aws_lb_target_group.halo_target_group.arn
}

output "nlb_core_target_groups_arn" {
  description = "The ARNs of the NLB CORE Target Group"
  value = {
    JMS       = aws_lb_target_group.core_jms_target_group.arn
    API       = aws_lb_target_group.core_api_target_group.arn
    HAZELCAST = aws_lb_target_group.core_hazelcast_target_group.arn
  }
}
