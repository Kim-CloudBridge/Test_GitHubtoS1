#UpdateMe
variable "hms_product_id" {
  type    = string
  default = "hms"
}

variable "hms_region_id" {
  type    = string
  default = "01"
}

variable "hms_client_id" {
  type    = string
  default = "0000"
}

variable "hms_environment_id" {
  type    = string
  default = "n"
}

variable "hms_deployment" {
  type    = string
  default = "fg2" #Reference to the group of resources e.g. fg2 is the second set of firewalls 
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "firewall_cidr_block" { #VPC top level CIDR 
  type    = string
  default = "10.210.122.0/24"
}

variable "firewall_private_subnets" { #List all private subnets following architectural design templates
  type = list(any)

  default = [
    "10.210.122.0/28",
    "10.210.122.16/28",
    "10.210.122.32/28",
    "10.210.122.48/28",
  ]
}

variable "firewall_public_subnets" { #List all public subnets following architectural design templates
  type = list(any)

  default = [
    "10.210.122.64/28",
    "10.210.122.80/28",
    "10.210.122.128/26",
    "10.210.122.192/26",
  ]
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear."
  type        = string
  default     = null
}

variable "traffic_type" {
  type        = string
  description = "The type of traffic to capture. Valid values: `ACCEPT`, `REJECT`, `ALL`"
  default     = "ALL"
  nullable    = false
}

##############################################################################################################
# Fortigate Vars
##############################################################################################################

// license file for the active fgt
variable "license" { #Change to your own byol license file, license.lic
  type    = string
  default = "license.txt"
}

// license file for the passive fgt
variable "license2" { #Change to your own byol license file, license2.lic
  type    = string
  default = "license2.txt"
}

// License Type to create FortiGate-VM
variable "license_type" { #Provide the license type for FortiGate-VM Instances, either byol or payg
  default = "byol"
}

// instance architect
variable "arch" { #Either arm or x86
  default = "x86"
}

// instance type needs to match the architect
// c5.xlarge is x86_64
// c6g.xlarge is arm
// For detail, refer to https://aws.amazon.com/ec2/instance-types/
variable "instance_type" {
  description = "Provide the instance type for the FortiGate instances"
  default     = "t3.small" #Chosen for cost considerations during the POC
}

variable "password" { #password for FortiGate HA configuration
  default = "fortinet"
}

variable "env_domain" {
  description = "The domain of this environment"
  type        = string
  default     = "MGMT"
}