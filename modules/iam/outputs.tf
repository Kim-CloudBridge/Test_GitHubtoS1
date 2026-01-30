output "ssm_instance_profile" {
  description = "The IAM instance profile required for SSM"
  value       = aws_iam_instance_profile.ssm_instance_profile
}

output "assume_role" {
  description = "The assume role properties"
  value       = var.allow_assume_role_here ? aws_iam_role.assume_role[0].arn : null
}
