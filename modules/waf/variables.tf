variable "waf_scope" {
  description = "The scope to apply to WAF, possible values: REGIONAL / CLOUDFRONT"
  type        = string
}

variable "alb_arn" {
  description = "The ARN of the ALB"
  type        = string
}

variable "global_vars" {
  description = "Global variables that are common across the infrastructure."
  type        = any
}
variable "client_env" {
  description = "The environment specific to the client (e.g., 0000p, 0000t, etc...)."
  type        = string
}
variable "common" {
  description = "Common prefix"
  type        = string
}

variable "enable_cloudwatch_logging" {
  description = "To enable cloudwatch logging of AWS WAF WebACL"
  type        = bool
}

variable "enable_cloudwatch_alarm_notifications" {
  description = "To enable cloudwatch alarm actions via notifications when alarm monitoring WebACL changes to ALARM"
  type        = bool
}

variable "alarm_email_recipient" {
  description = "Email Recipient for Alarm Notifications"
  type        = string
}
variable "env_domain" {
  description = "The domain of this environment"
  type        = string
}
variable "tier" {
  description = "Type of tier (tier1, tier2, tier3)"
  type        = string
}
variable "client_id" {
  description = "The ID for the client."
  type        = string
}