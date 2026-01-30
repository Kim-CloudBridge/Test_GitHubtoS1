#Environment configs
variable "region" {
  type        = string
  description = "Region to use"
  default     = "eu-west-2"
}
variable "client_id" {
  description = "The ID for the client."
  type        = string
}
variable "env_suffix" {
  description = "The environment specific to the client (e.g., prod - p, test - t, etc...)."
  type        = string
}

variable "ad_params_value" {
  type        = string
  description = "SSM Params value for the AD service account"
  sensitive   = true
}
variable "ou_arns_to_share" {
  type        = list(string)
  description = "The OU ARNs to share the SSM Params (e.g. arn:aws:organizations::ACCOUNTID:ou/o-*****/ou-****-******)"
}