# Create a Web ACL
resource "aws_wafv2_web_acl" "basic_waf" {
  name        = local.waf_name
  description = "WAF initial implementation"
  scope       = var.waf_scope

  default_action {
    allow {}
  }
  # Add more rules as needed
  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.waf_name}-AWSManagedRules"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.waf_name
    sampled_requests_enabled   = true
  }

  tags = merge({
    Name = local.waf_name
  }, local.tags)

  lifecycle {
    ignore_changes = [
      rule,
      visibility_config
    ]
  }
}

# Associate the Web ACL with the ALB
resource "aws_wafv2_web_acl_association" "alb_waf_association" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.basic_waf.arn
}

# Logging
resource "aws_cloudwatch_log_group" "waf_logs" {
  count             = var.enable_cloudwatch_logging ? 1 : 0
  name              = "aws-waf-logs-${local.waf_name}"
  retention_in_days = 90

  tags = merge({
    WebACL = local.waf_name
  }, local.tags)
}

resource "aws_wafv2_web_acl_logging_configuration" "web_acl_logging" {
  count                   = var.enable_cloudwatch_logging ? 1 : 0
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs[0].arn]
  resource_arn            = aws_wafv2_web_acl.basic_waf.arn
}

resource "aws_cloudwatch_log_resource_policy" "cw_logs_policy" {
  count           = var.enable_cloudwatch_logging ? 1 : 0
  policy_document = data.aws_iam_policy_document.policy[0].json
  policy_name     = "${local.waf_name}-cwlogs-pol"
}

data "aws_iam_policy_document" "policy" {
  count   = var.enable_cloudwatch_logging ? 1 : 0
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.waf_logs[0].arn}:*"]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# Alarming
resource "aws_cloudwatch_metric_alarm" "counted_requests_rate" {
  alarm_name                = "${local.waf_name}-count-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  threshold                 = 1
  alarm_description         = "Counted Request rate detected"
  insufficient_data_actions = []

  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Counted Requests Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "AllowedRequests"
      namespace   = "AWS/WAFV2"
      period      = 120
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        WebACL = local.waf_name
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "CountedRequests"
      namespace   = "AWS/WAFV2"
      period      = 120
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        WebACL = local.waf_name
        Rule   = "ALL"
      }
    }
  }

  treat_missing_data = "notBreaching"

  actions_enabled = var.enable_cloudwatch_alarm_notifications
  alarm_actions = var.enable_cloudwatch_alarm_notifications ? [
    aws_sns_topic.waf_alarm_topic[0].arn
  ] : []
}

resource "aws_sns_topic" "waf_alarm_topic" {
  count = var.enable_cloudwatch_alarm_notifications ? 1 : 0
  name  = "${local.waf_name}-alarm-sns"
}

resource "aws_sns_topic_subscription" "waf_alarm_topic_subscribe" {
  count     = var.enable_cloudwatch_alarm_notifications ? 1 : 0
  endpoint  = var.alarm_email_recipient
  protocol  = "email"
  topic_arn = aws_sns_topic.waf_alarm_topic[0].arn
}