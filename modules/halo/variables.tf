variable "global_vars" {
  description = "Global variables that are common across the infrastructure."
  type        = any
}
variable "environment" {
  description = "Environment specific configurations."
  type = any
  # type = object({
  #   region                = string
  #   install_egress_access = bool
  #   vpc = object({
  #     cidr           = string
  #     enabled_azs    = list(string)
  #     public_subnets = list(string)
  #     intra_subnets  = list(string)
  #   })
  #   app_vpc = object({
  #     cidr                             = string
  #     enabled_azs                      = list(string)
  #     private_subnets_for_applications = list(string)
  #     private_subnets_for_dbs          = list(string)
  #     intra_subnets                    = list(string)
  #   })
  #   network_account_cidr = string
  #   nginx_config = object({
  #     instance_type = map(string)
  #     ami           = map(string)
  #   })
  #   halo_config = object({
  #     instance_type = map(string)
  #     ami           = map(string)
  #   })
  #   aura_config = object({
  #     instance_type = map(string)
  #     ami           = map(string)
  #   })
  #   core_config = object({
  #     number_of_secondary_ips = number
  #     instance_type           = map(string)
  #     ami                     = map(string)
  #   })
  #   mdb_config = object({
  #     number_of_secondary_ips = number
  #     instance_type           = map(string)
  #     ami                     = map(string)
  #   })
  #   rdb_config = object({
  #     number_of_secondary_ips = number
  #     instance_type           = map(string)
  #     ami                     = map(string)
  #   })
  #   workhours         = string
  #   out_of_workhours  = string
  #   delayed_workhours = string
  # })
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
variable "halo_security_group_id" {
  description = "ID of the Halo Security Group"
  type        = string
}
variable "ssm_instance_profile" {
  description = "The IAM instance profile required for SSM"
  type        = any
}
variable "nlb_halo_target_group_arn" {
  description = "The ARN of the NLB Halo Target Groups"
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