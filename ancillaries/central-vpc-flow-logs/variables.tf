variable "hms_product_id" {
  type    = string
  default = "hms"
}

variable "hms_region_id" {
  type    = string
  default = "01"
}

variable "hms_client_id" {
  type    = string
  default = "0000"
}

variable "hms_environment_id" {
  type    = string
  default = "n"
}

variable "hms_deployment" {
  type    = string
  default = "fg1"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "allow_ssl_requests_only" {
  type        = bool
  description = "Additional IAM policy document that can optionally be merged with default created KMS policy"
  default     = true
  nullable    = false
}

variable "kms_key_arn" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}