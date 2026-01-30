variable "global_vars" {
  description = "Global variables that are common across the infrastructure."
  type        = any
}
variable "environment" {
  description = "Environment specific configurations."
  type = any
}
variable "client_id" {
  description = "The ID for the client."
  type        = string
}
variable "client_env" {
  description = "The environment specific to the client (e.g., 0000p, 0000t, etc...)."
  type        = string
}
variable "tier" {
  description = "Type of tier (tier1, tier2, tier3)"
  type        = string
}
variable "aura_security_group_id" {
  description = "ID of the Aura Security Group"
  type        = string
}
variable "ssm_instance_profile" {
  description = "The IAM instance profile required for SSM"
  type        = any
}
variable "nlb_aura_target_group_arn" {
  description = "The ARN string of the NLB Aura Target Group"
  type        = string
}
variable "app_subnet_ids_array" {
  description = "An array with all the app subnets ids"
  type        = list(string)
}
variable "management_security_group_id" {
  description = "ID of the Management Security Group"
  type        = string
}
variable "common" {
  description = "Common prefix"
  type        = string
}
variable "env_domain" {
  description = "The domain of this environment"
  type        = string
}

#Tagging variables
variable "bia_risk" {
  description = "BIA rating of asset for Business Continuity or DR purposes"
  type        = string
}

variable "cia_risk" {
  description = "CIA rating of asset for Information Security purposes"
  type        = string
}

variable "data_classification" {
  description = "Data Rating as per Lendscape Policy"
  type        = string
}

variable "map_tags" {
  description = "Tagging value for MAP Credits"
  type = map(any)
  default = {}
}