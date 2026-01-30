variable "management_security_group_ingress_rules" {
  description = "Management Extension Ingress Rules"
  type        = list(any)
}
variable "management_security_group_egress_rules" {
  description = "Management Extension Ingress Rules"
  type        = list(any)
}

variable "vpc_id" {
  description = "VPC ID to attach the security group"
  type        = any
}

variable "global_vars" {
  description = "Global variables that are common across the infrastructure."
  type        = any
}

variable "client_id" {
  description = "The ID for the client."
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

variable "common" {
  description = "Common prefix"
  type        = string
}

variable "client_env" {
  description = "The environment specific to the client (e.g., 0000p, 0000t, etc...)."
  type        = string
}

variable "network_account_cidr" {
  description = "CIDR range of the network account."
  type        = string
}

variable "application_name" {
  description = "Name of the application to attach SG."
  type        = string
}

