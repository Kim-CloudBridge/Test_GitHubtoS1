variable "dmz_vpc" {
  type = map(any)
}

variable "alb_security_group_ingress_rules" {
  description = "ALB Extension Ingress Rules"
  type        = list(any)
}
variable "alb_security_group_egress_rules" {
  description = "ALB Extension Egress Rules"
  type        = list(any)
}
variable "nginx_security_group_ingress_rules" {
  description = "Nginx Extension Ingress Rules"
  type        = list(any)
}
variable "nginx_security_group_egress_rules" {
  description = "Nginx Extension Egress Rules"
  type        = list(any)
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