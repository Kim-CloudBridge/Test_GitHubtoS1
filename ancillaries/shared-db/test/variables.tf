#Environment configs
variable "region" {
  description = "Region where to deploy MDB"
  type        = string
}
variable "client_id" {
  description = "The ID for the client."
  type        = string
}
variable "env_suffix" {
  description = "The environment specific to the client (e.g., prod - p, test - t, etc...)."
  type        = string
}
variable "tier" {
  description = "Type of tier (tier1, tier2, tier3)"
  type        = string
}
variable "env_domain" {
  description = "The domain of this environment"
  type        = string
}
variable "assume_role_account_ids" {
  description = "List of account IDs to allow assume role to shared services account"
  type = list(number)
  default = null
}
## MDB config
# variable "mdb_instance_type" {
#   description = "Instance type of MDB"
#   type        = string
# }
variable "mdb_ami" {
  description = "AMI ID to use for MDB"
  type        = string
}
variable "mdb_instances_count" {
  description = "Number of MDB instances to provision"
  type        = number
  default     = 1
}
variable "mdb_number_of_secondary_ips" {
  description = "How many secondary IPs needed for MDB"
  type        = number
}
## RDB config
# variable "rdb_instance_type" {
#   description = "Instance type of RDB"
#   type        = string
# }
variable "rdb_ami" {
  description = "AMI ID to use for RDB"
  type        = string
}
variable "rdb_instances_count" {
  description = "Number of RDB instances to provision"
  type        = number
  default     = 1
}
variable "rdb_number_of_secondary_ips" {
  description = "How many secondary IPs needed for RDB"
  type        = number
}
variable "ew_fw_cidr" {
  description = "The E/W firewall CIDR to allow in SG rules"
  type        = string
  default     = null
}