variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "route_table_ids" {
  description = "The route table ids to allow endpoint usage."
  type        = list(string)
}

variable "tags" {
  description = "Tags for the vpc endpoint"
  type        = any
}