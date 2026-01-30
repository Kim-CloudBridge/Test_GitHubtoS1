variable "transit_gateway_id" {
  description = "Transit Gateway ID if none will be created by this module"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to this resource"
  type        = map(any)
  default     = {}
}

variable "transit_gateway_naming_prefix" {
  description = "Naming prefix to apply to name tags within this module"
  type        = string
  default     = ""
}

variable "transit_gateway_route_tables" {
  description = "List of transit gateway route tables to which will be used as basis for the count and names of resources to be created"
  type        = list(any)
  default     = []
}

