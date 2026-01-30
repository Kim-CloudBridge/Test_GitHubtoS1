variable "bucket" {
  description = "S3 object created from the S3 module"
  type        = any
}

variable "policy_type" {
  description = "Type of policy to apply to the bucket"
  type        = string
  validation {
    condition = contains(["access_logs", "cross_account"], var.policy_type)
    error_message = "Valid value is one of the following: access_logs, cross_account."
  }
}

variable "external_accounts" {
  description = "List of External Account Ids you would like to allow the bucket. Required if policy type is cross_account"
  type        = list(string)
  default = []
}
