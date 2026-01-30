variable "dmz_vpc" {
  description = "DMZ VPC module"
  type        = any
}
variable "app_vpc" {
  description = "APP VPC module"
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
variable "common" {
  description = "Common prefix"
  type        = string
}
variable "global_vars" {
  description = "Global variables that are common across the infrastructure."
  type        = any
}
variable "environment" {
  description = "Environment specific configurations."
  type = object({
    region                = string
    install_egress_access = bool
    vpc = object({
      cidr           = string
      enabled_azs    = list(string)
      public_subnets = list(string)
      intra_subnets  = list(string)
    })
    app_vpc = object({
      cidr                             = string
      enabled_azs                      = list(string)
      private_subnets_for_applications = list(string)
      private_subnets_for_dbs          = list(string)
      intra_subnets                    = list(string)
    })
    network_account_cidr = string
    nginx_config = object({
      instance_type = map(string)
      ami           = map(string)
    })
    halo_config = object({
      instance_type = map(string)
      ami           = map(string)
    })
    aura_config = object({
      instance_type = map(string)
      ami           = map(string)
    })
    core_config = object({
      number_of_secondary_ips = number
      instance_type           = map(string)
      ami                     = map(string)
    })
    mdb_config = object({
      number_of_secondary_ips = number
      instance_type           = map(string)
      ami                     = map(string)
    })
    rdb_config = object({
      number_of_secondary_ips = number
      instance_type           = map(string)
      ami                     = map(string)
    })
    workhours         = string
    out_of_workhours  = string
    delayed_workhours = string
  })
}
variable "alb_security_group_ingress_rules" {
  description = "ALB Extension Ingress Rules"
  type        = list(any)
}
variable "alb_security_group_egress_rules" {
  description = "ALB Extension Egress Rules"
  type        = list(any)
}
variable "nginx_security_group_ingress_rules" {
  description = "Nginx Extension Ingress Rules"
  type        = list(any)
}
variable "nginx_security_group_egress_rules" {
  description = "Nginx Extension Egress Rules"
  type        = list(any)
}
variable "nlb_halo_security_group_ingress_rules" {
  description = "NLB Halo Extension Ingress Rules"
  type        = list(any)
}
variable "nlb_halo_security_group_egress_rules" {
  description = "NLB Halo Extension Egress Rules"
  type        = list(any)
}
variable "halo_security_group_ingress_rules" {
  description = "Halo Extension Ingress Rules"
  type        = list(any)
}
variable "halo_security_group_egress_rules" {
  description = "Halo Extension Egress Rules"
  type        = list(any)
}
variable "nlb_aura_security_group_ingress_rules" {
  description = "NLB Aura Extension Ingress Rules"
  type        = list(any)
}
variable "nlb_aura_security_group_egress_rules" {
  description = "NLB Halo Extension Egress Rules"
  type        = list(any)
}
variable "aura_security_group_ingress_rules" {
  description = "Aura Extension Ingress Rules"
  type        = list(any)
}
variable "aura_security_group_egress_rules" {
  description = "Aura Extension Egress Rules"
  type        = list(any)
}
variable "nlb_core_security_group_ingress_rules" {
  description = "NLB Core Extension Ingress Rules"
  type        = list(any)
}
variable "nlb_core_security_group_egress_rules" {
  description = "NLB Core Extension Egress Rules"
  type        = list(any)
}
variable "core_security_group_ingress_rules" {
  description = "Core Extension Ingress Rules"
  type        = list(any)
}
variable "core_security_group_egress_rules" {
  description = "Core Extension Egress Rules"
  type        = list(any)
}
variable "mdb_security_group_ingress_rules" {
  description = "MDB Extension Ingress Rules"
  type        = list(any)
}
variable "mdb_security_group_egress_rules" {
  description = "MDB Extension Egress Rules"
  type        = list(any)
}
variable "rdb_security_group_ingress_rules" {
  description = "RDB Extension Ingress Rules"
  type        = list(any)
}
variable "rdb_security_group_egress_rules" {
  description = "RDB Extension Egress Rules"
  type        = list(any)
}
variable "core_fsx_security_group_ingress_rules" {
  description = "Core's FSX Extension Ingress Rules"
  type        = list(any)
}
variable "core_fsx_security_group_egress_rules" {
  description = "Core's FSX Extension Egress Rules"
  type        = list(any)
}
variable "mdb_fsx_security_group_ingress_rules" {
  description = "MDB's FSX Extension Ingress Rules"
  type        = list(any)
}
variable "mdb_fsx_security_group_egress_rules" {
  description = "MDB's FSX Extension Egress Rules"
  type        = list(any)
}
variable "rdb_fsx_security_group_ingress_rules" {
  description = "RDB's FSX Extension Ingress Rules"
  type        = list(any)
}
variable "rdb_fsx_security_group_egress_rules" {
  description = "RDB's FSX Extension Egress Rules"
  type        = list(any)
}
variable "management_security_group_ingress_rules" {
  description = "Management Extension Ingress Rules"
  type        = list(any)
}
variable "management_security_group_egress_rules" {
  description = "Management Extension Ingress Rules"
  type        = list(any)
}
variable "ad_cidr" {
  description = "IP CIDRs of the AD directory"
  type        = list(any)
}
variable "ew_fw_cidr" {
  description = "IP CIDRs of the E/W firewall"
  type        = list(any)
}
variable "env_domain" {
  description = "The domain of this environment"
  type        = string
}
variable "tier" {
  description = "Type of tier (tier1, tier2, tier3)"
  type        = string
}
variable "enable_appstream" {
  description = "Flag to create AppStream security group and attach it to Core NLB"
  type        = bool
}

