# variable "product" {
#   type = string
# }

# variable "region_alias" {
#   type = string
# }

# variable "environment_id" {
#   type    = string
#   default = "n"
# }

# variable "client_id" {
#   type = string
# }

# variable "region" {
#   type = string
# }

# #Use /26 (62 hosts) only for subnets

# variable "shared_private_subnets" {
#   type = list(any)

#   default = [
#     "10.210.124.128/26",
#     "10.210.124.192/26"
#   ]
# }

# variable "shared_public_subnets" {
#   type = list(any)

#   default = [
#     "10.210.124.0/26",
#     "10.210.124.64/26"
#   ]
# }

# variable "common_tags" {
#   type    = map(any)
#   default = {}
# }

# variable "env_domain" {
#   description = "The domain of this environment"
#   type        = string
#   default     = "MGMT"
# }

