variable "product" {
  type = string
}

variable "region_alias" {
  type = string
}

variable "environment_id" {
  type    = string
  default = "n"
}

variable "client_id" {
  type = string
}

variable "region" {
  type = string
}

#Use /22 (1022 hosts) CIDR for VPC
variable "shared_svcs_vpc_cidr" {
  type = string
}

#Use /26 (62 hosts) only for subnets
variable "shared_private_subnets" {
  type = list(any)

  default = [
    "10.210.124.128/26",
    "10.210.124.192/26"
  ]
}

variable "shared_public_subnets" {
  type = list(any)

  default = [
    "10.210.124.0/26",
    "10.210.124.64/26"
  ]
}

variable "common_tags" {
  type    = map(any)
  default = {}
}

variable "env_domain" {
  description = "The domain of this environment"
  type        = string
  default     = "MGMT"
}

## New vars
variable "ami_id" {
  type        = string
  description = "AMI to use for the self-hosted AD"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to use for the self-hosted AD"
}