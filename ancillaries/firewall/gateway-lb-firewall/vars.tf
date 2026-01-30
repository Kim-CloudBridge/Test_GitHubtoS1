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
  default = "fg1"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "firewall_cidr_block" {
  type    = string
  default = "10.210.120.0/24"
}

variable "gateway_cidr_block" {
  type    = string
  default = "10.210.121.0/24"
}

variable "gateway_private_subnets" {
  type = list(any)

  default = [
    "10.210.121.0/27",
    "10.210.121.32/27",
    "10.210.121.64/27",
    "10.210.121.96/27",
  ]
}

variable "firewall_private_subnets" {
  type = list(any)

  default = [
    "10.210.120.0/27",
    "10.210.120.32/27",
    "10.210.120.64/26",
    "10.210.120.128/26",
  ]
}

variable "firewall_public_subnets" {
  type = list(any)

  default = [
    "10.210.120.192/27",
    "10.210.120.224/27",
  ]
}

# FortiGate
// instance architect
// Either arm or x86
variable "arch" {
  default = "arm"
}

// instance type needs to match the architect
// c5.xlarge is x86_64
// c6g.xlarge is arm
// For detail, refer to https://aws.amazon.com/ec2/instance-types/
variable "management_ports" {
  type    = list(any)
  default = [22, 443, 8443]
}

variable "size" {
  default = "t2.micro"
}


// licence Type to create FortiGate-VM
// Provide the licence type for FortiGate-VM Instances, either byol or payg.
variable "licence_type" {
  type    = string
  default = "payg"
}


// AMIs for FGTVM-7.4.1
variable "fgtami" {
  type    = string
  default = "ami-id"
}

//  Existing SSH Key on the AWS 
variable "keyname" {
  default = "<AWS SSH KEY>"
}

//  Admin HTTPS access port
variable "adminsport" {
  default = "443"
}

variable "bootstrap-fgtvm" {
  // Change to your own path
  type    = string
  default = "fgtvm.conf"
}

variable "bootstrap-fgtvm2" {
  // Change to your own path
  type    = string
  default = "fgtvm2.conf"
}

// licence file for the fgt
variable "licence" {
  // Change to your own byol licence file, licence.lic
  type    = string
  default = "licence.lic"
}

// licence file for the fgt 2
variable "licence2" {
  // Change to your own byol licence file, licence.lic
  type    = string
  default = "licence2.lic"
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

variable "private_inbound_acl_rules" {
  type    = list(map(string))
  default = []
}

variable "private_outbound_acl_rules" {
  type    = list(map(string))
  default = []
}

variable "public_inbound_acl_rules" {
  type    = list(map(string))
  default = []
}

variable "public_outbound_acl_rules" {
  type    = list(map(string))
  default = []
}

variable "default_network_acl_ingress" {
  type = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "default_network_acl_egress" {
  type = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "env_domain" {
  description = "The domain of this environment"
  type        = string
  default     = "MGMT"
}