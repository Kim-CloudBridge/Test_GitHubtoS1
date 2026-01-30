variable "alb_security_group_id" {
  type = string
}

variable "public_subnet_ids_array" {
  type = list(any)
}

variable "dmz_vpc" {
  type = map(any)
}

variable "client_id" {
  type = string
}

variable "tier" {
  type = string
}

variable "env_domain" {
  type = string
}

variable "common" {
  type = string
}

variable "client_env" {
  type = string
}

variable "global_vars" {
  type = any
}

variable "region" {
  type = string
}