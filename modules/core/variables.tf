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
variable "core_security_group_id" {
  description = "ID of the Core Security Group"
  type        = string
}
variable "ssm_instance_profile" {
  description = "The IAM instance profile required for SSM"
  type        = any
}
variable "nlb_core_target_groups_arn" {
  description = "The ARNs of the NLB Core Target Groups"
  type        = map(string)
}
variable "app_subnet_ids_array" {
  description = "An array with all the app subnets ids"
  type        = list(string)
}
variable "management_security_group_id" {
  description = "ID of the Management Security Group"
  type        = string
}
variable "gen_fsx_security_group_id" {
  description = "ID of the General FSX Security Group"
  type        = string
}
variable "core_fsx_security_group_id" {
  description = "ID of the Core FSX Security Group"
  type        = string
}
variable "common" {
  description = "Common prefix"
  type        = string
}
variable "directory_id" {
  description = "Directory ID"
  type        = string
  default = null
}
variable "fsx_subnet_id" {
  description = "FSX Subnet ID as a string to mount the AD"
  type        = string
}
variable "env_domain" {
  description = "The domain of this environment"
  type        = string
}

variable "jenkins_sgp" {
  description = "The security group to allow jenkins CICD connections"
  type = string
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