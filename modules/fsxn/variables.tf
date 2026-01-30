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
      fsx_storage_type        = string
      fsx_storage_capacity    = number
      fsx_throughput_capacity = number
      fsx_deployment_type     = string
    })
    mdb_config = object({
      number_of_secondary_ips = number
      instance_type           = map(string)
      ami                     = map(string)
      fsx_storage_type        = string
      fsx_storage_capacity    = number
      fsx_throughput_capacity = number
      fsx_deployment_type     = string
    })
    rdb_config = object({
      number_of_secondary_ips = number
      instance_type           = map(string)
      ami                     = map(string)
      fsx_storage_type        = string
      fsx_storage_capacity    = number
      fsx_throughput_capacity = number
      fsx_deployment_type     = string
    })
    workhours         = string
    out_of_workhours  = string
    delayed_workhours = string
  })
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
variable "gen_fsx_security_group_id" {
  description = "ID of the General FSX Security Group"
  type        = string
}
variable "fsx_security_group_id" {
  description = "ID of the FSXN Security Group"
  type        = string
}
variable "common" {
  description = "Common prefix"
  type        = string
}
variable "fsx_subnet_id" {
  description = "FSX Subnet ID as a string to mount the AD"
  type        = list(string)
}
variable "fsx_preferred_subnet_id" {
  description = "FSX Subnet ID as a string to mount the AD"
  type        = string
}
variable "env_domain" {
  description = "The domain of this environment"
  type        = string
}
variable "fsx_route_table_ids" {
  description = "List of Route Table ID as strings where FSxN endpoints will be created"
  type        = list(string)
}
variable "ad_config" {
  description = "AD Configuration to supply to FSxN SVM"
  type = object({
    directory_id                           = string
    service_account_password               = string
    service_account_user                   = string
    file_system_administrators_group       = string
    organizational_unit_distinguished_name = string
  })
}

variable "environment_fsxn_config" {
  description = "the fsxn configuration"
  type = object({
    fsx_deployment_type = string
    storage_type        = string
    storage_capacity    = string
    throughput_capacity = string
    # endpoint_ip_range   = string
    disk_iops_configuration = object(
      {
        iops = string
        mode = string
    })
    ontap_volume_type = string
    volume_sizes = object({
      rdb = number
      mdb = number
      core = number
    })
  })
}

variable "map_tags" {
  description = "Tagging value for MAP Credits"
  type = map(any)
  default = {}
}