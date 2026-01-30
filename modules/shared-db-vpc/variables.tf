variable "environment" {
  description = "Environment specific configurations."
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
variable "client_env" {
  description = "The environment specific to the client (e.g., 0000p, 0000t, etc...)."
  type        = string
}
variable "create_igw" {
  description = "Whether to create an internet gateway for the VPC."
  type        = bool
}
variable "enable_nat_gateway" {
  description = "Whether to enable the NAT gateway in the VPC."
  type        = bool
}
variable "network_app_acls" {
  description = "List of network access control lists for the application."
  type        = any
}
variable "common" {
  description = "Common prefix"
  type        = string
}
variable "transit_gateway_id" {
  description = "ID of the transit gateway to attach to the VPC."
  type        = string
}

variable "enable_dhcp_options" {
  description = "Boolean to indicate if we're going to use domain_name and domain_name_servers"
  type        = bool
}

variable "dhcp_options_domain_name" {
  description = "AD Domain Name"
  type        = string
}

variable "dhcp_options_domain_name_servers" {
  description = "Array with the IPs of the name servers"
  type        = list(string)
}

variable "env_domain" {
  description = "The domain of this environment"
  type        = string
}

variable "tier" {
  description = "Type of tier (tier1, tier2, tier3)"
  type        = string
}