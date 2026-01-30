output "s3_vpc_flow_log_arn" {
  value = length(var.s3_destination_arn) > 0 ? join("", aws_flow_log.s3_destination.*.arn) : null
}

output "local_flow_log_arn" {
  value = var.create_local_flow_logs_store ? join("", aws_flow_log.local.*.arn) : null
}

output "local_flow_log_iam_role" {
  value = var.create_local_flow_logs_store ? join("", aws_iam_role.local_flow_log_role.*.arn) : null
}