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
# #FSX configs
variable "fsx_storage_type" {
  description = "Storage type of FSx (SSD or HDD)"
  type        = string
  default     = "SSD"
}
variable "fsx_storage_capacity" {
  description = "How many GBs needed for FSX"
  type        = number
  default     = 1024
}
variable "fsx_throughput_capacity" {
  description = "How many throughput capacity needed for FSX"
  type        = number
  default     = 256
}
variable "fsx_deployment_type" {
  description = "Deployment type of the FSX"
  type        = string
  default     = "SINGLE_AZ_1"
}
variable "fsx_disk_iops" {
  description = "Disk IOPS for the FSx"
  type        = number
  default     = 10000
}
## AD Configuration
variable "ad_dns_ip" {
  description = "DNS IP address of the Active directory"
  type        = list(string)
}
variable "ad_domain_name" {
  description = "Domain name of the Active directory"
  type        = string
}
variable "gen_fsx_security_group_id" {
  description = "ID of the General FSX Security Group"
  type        = string
  default     = null
}
## disk configs
variable "core_storage_allocation" {
  description = "Size in megabytes storage size allocation for LS-Core"
  type        = number
}
variable "mdb_storage_allocation" {
  description = "Size in megabytes storage size allocation for MDB"
  type        = number
}
variable "rdb_storage_allocation" {
  description = "Size in megabytes storage size allocation for RDB"
  type        = number
}