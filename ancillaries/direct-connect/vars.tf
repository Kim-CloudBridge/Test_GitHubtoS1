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
  default = "direct-connect"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "common_tags" {
  type    = map(any)
  default = {}
}

variable "organization" {
  type    = map(any)
  default = {}
}