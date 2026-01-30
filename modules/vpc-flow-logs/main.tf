data "aws_region" "current" {}

locals {
  # For more details: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html#flow-logs-custom
  custom_log_format_v5 = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${vpc-id} $${subnet-id} $${instance-id} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-dstaddr} $${region} $${az-id} $${sublocation-type} $${sublocation-id} $${pkt-src-aws-service} $${pkt-dst-aws-service} $${flow-direction} $${traffic-path}"
}

resource "aws_flow_log" "s3_destination" {
  count = length(var.s3_destination_arn) > 0 ? 1 : 0

  log_destination      = var.s3_destination_arn # Optionally, a prefix can be added after the ARN.
  log_destination_type = "s3"
  traffic_type         = upper(var.traffic_type)
  vpc_id               = var.vpc_id
  log_format           = local.custom_log_format_v5 # If you want fields from VPC Flow Logs v3+, you will need to create a custom log format.
  tags = merge(var.tags, {
    Name = "${var.name}-s3"
    }
  )
}

resource "aws_iam_role" "local_flow_log_role" {
  count = var.create_local_flow_logs_store ? 1 : 0
  name  = "flow-logs-policy-${var.vpc_id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "logs_permissions" {
  count = var.create_local_flow_logs_store ? 1 : 0
  name  = "flow-logs-policy-${var.vpc_id}"
  role  = join("", aws_iam_role.local_flow_log_role.*.id)

  # This is required because of the policy being evaluated and "different" to the code one
  # because of the ${data.aws_region.current.name} expression.

  # If this policy requires to be modified, please comment this lifecycle struct, apply and then
  # comment it back again.
  lifecycle {
    ignore_changes = [policy]
  }
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:CreateLogDelivery",
        "logs:DeleteLogDelivery"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:${data.aws_region.current.name}:*:log-group:vpc-flow-logs*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "local_flow_logs" {
  count = var.create_local_flow_logs_store ? 1 : 0
  # checkov:skip=CKV_AWS_338:local retention is set to 30, centralized S3 bucket can retain for long-term
  name              = "vpc-flow-logs/${var.vpc_id}"
  retention_in_days = 30
}

resource "aws_flow_log" "local" {
  count = var.create_local_flow_logs_store ? 1 : 0

  iam_role_arn    = join("", aws_iam_role.local_flow_log_role.*.arn)
  log_destination = join("", aws_cloudwatch_log_group.local_flow_logs.*.arn)
  traffic_type    = upper(var.traffic_type)
  vpc_id          = var.vpc_id
  tags = merge(var.tags, {
    Name = "${var.name}-local"
    }
  )
}
