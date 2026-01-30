#lambda_auto_manage
# Function itself
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_code/manage_instances.py"
  output_path = "${path.module}/lambda_code/manage_instances.zip"
}
resource "aws_lambda_function" "manage_instances" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "manage_instances"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "manage_instances.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("${path.module}/lambda_code/manage_instances.zip")
  timeout          = 120

  tags = local.tags
}

# Roles and policies to grant permissions to Lambda functions to be able to write logs
# and execute operations against ec2 instances (list them and start/stop them)
resource "aws_iam_role" "lambda_exec" {
  name = local.lambda_exec_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}
resource "aws_iam_policy" "lambda_exec" {
  name        = local.lambda_exec_policy_name
  description = "Allow lambda to manage EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["ec2:StartInstances", "ec2:StopInstances", "ec2:DescribeInstances"],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_exec.arn
}

# Event Rules with cron expressions and event targets
resource "aws_cloudwatch_event_rule" "start_instances" {
  name                = "start-instances"
  schedule_expression = var.environment.workhours
}
resource "aws_cloudwatch_event_rule" "stop_instances" {
  name                = "stop-instances"
  schedule_expression = var.environment.out_of_workhours
}
resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_instances.name
  target_id = "StartInstances"
  arn       = aws_lambda_function.manage_instances.arn

  retry_policy {
    maximum_retry_attempts       = 0
    maximum_event_age_in_seconds = 60
  }

  input = jsonencode({
    action = "start" # Attribute checked inside the Lambda function code
    tag    = "AutoManage"
    region = var.environment.region
  })
}
resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_instances.name
  target_id = "StopInstances"
  arn       = aws_lambda_function.manage_instances.arn

  retry_policy {
    maximum_retry_attempts       = 0
    maximum_event_age_in_seconds = 60
  }

  input = jsonencode({
    action = "stop" # Attribute checked inside the Lambda function code
    tag    = "AutoManage"
    region = var.environment.region
  })
}

resource "aws_cloudwatch_event_rule" "delayed_start_instances" {
  name                = "delayed-start-instances"
  schedule_expression = var.environment.delayed_workhours
}
resource "aws_cloudwatch_event_rule" "delayed_stop_instances" {
  name = "delayed-stop-instances"
  # Same as out_of_workhours as at the moment customer hasn't requested that WS stops ealier or later, but here
  # we're adding the possibility to have different delayed_out_of_work_hours
  schedule_expression = var.environment.out_of_workhours
}
resource "aws_cloudwatch_event_target" "delayed_start_target" {
  rule      = aws_cloudwatch_event_rule.delayed_start_instances.name
  target_id = "DelayedStartInstances"
  arn       = aws_lambda_function.manage_instances.arn

  retry_policy {
    maximum_retry_attempts       = 0
    maximum_event_age_in_seconds = 60
  }

  input = jsonencode({
    action = "start" # Attribute checked inside the Lambda function code
    tag    = "AutoManageDelayed"
    region = var.environment.region
  })
}
resource "aws_cloudwatch_event_target" "delayed_stop_target" {
  rule      = aws_cloudwatch_event_rule.delayed_stop_instances.name
  target_id = "DelayedStopInstances"
  arn       = aws_lambda_function.manage_instances.arn

  retry_policy {
    maximum_retry_attempts       = 0
    maximum_event_age_in_seconds = 60
  }

  input = jsonencode({
    action = "stop" # Attribute checked inside the Lambda function code
    tag    = "AutoManageDelayed"
    region = var.environment.region
  })
}

# Lambda Permissions to trigger lambdas from CloudWatch to start and stop
resource "aws_lambda_permission" "allow_cloudwatch_to_start" {
  statement_id  = "AllowExecutionFromCloudWatchStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.manage_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_instances.arn
}
resource "aws_lambda_permission" "allow_cloudwatch_to_stop" {
  statement_id  = "AllowExecutionFromCloudWatchStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.manage_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_instances.arn
}
resource "aws_lambda_permission" "allow_cloudwatch_to_delayed_start" {
  statement_id  = "AllowExecutionFromCloudWatchDelayedStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.manage_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.delayed_start_instances.arn
}
resource "aws_lambda_permission" "allow_cloudwatch_to_delayed_stop" {
  statement_id  = "AllowExecutionFromCloudWatchDelayedStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.manage_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.delayed_stop_instances.arn
}

