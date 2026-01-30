variable "app_vpc" {}
variable "dmz_vpc" {}
variable "security_groups" {}
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