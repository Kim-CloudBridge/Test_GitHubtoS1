variable "product" {
  type = string
}

variable "region_alias" {
  type = string
}

variable "environment_id" {
  type    = string
  default = "n"
}

variable "client_id" {
  type = string
}

variable "region" {
  type = string
}

variable "directory_name" {
  type = string
}

variable "account_ids" {
  type = list(any)
}

variable "managed_ad_password" {
  type      = string
  sensitive = true
}

variable "common_tags" {
  type    = map(any)
  default = {}
}

variable "env_domain" {
  description = "The domain of this environment"
  type        = string
  default     = "MGMT"
}