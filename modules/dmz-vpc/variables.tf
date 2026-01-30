variable "client_id" {
  description = "The ID for the client."
  type        = string
}
variable "client_env" {
  description = "The environment specific to the client (e.g., 0000p, 0000t, etc...)."
  type        = string
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
variable "create_igw" {
  description = "Whether to create an internet gateway for the VPC."
  type        = bool
}
variable "enable_nat_gateway" {
  description = "Whether to enable the NAT gateway in the VPC."
  type        = bool
}
variable "global_vars" {}
variable "network_acls_dmz" {
  description = "List of network access control lists for the DMZ."
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
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Array with the IPs of the name servers"
  type        = list(string)
  default     = [ "AmazonProvidedDNS" ]
}

variable "env_domain" {
  description = "The domain of this environment"
  type        = string
}

variable "tier" {
  description = "Type of tier (tier1, tier2, tier3)"
  type        = string
}