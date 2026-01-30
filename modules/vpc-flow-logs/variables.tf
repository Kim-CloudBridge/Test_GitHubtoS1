variable "name" {
  type        = string
  default     = ""
  description = "Name of Flow Logs"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC for which you want to create a Flow Log"
}

variable "s3_destination_arn" {
  type        = string
  description = "ARN of the S3 Bucket Log Destination"
  default     = ""
}

variable "traffic_type" {
  type        = string
  description = "Traffic Type to Log"
  default     = "ALL"

  validation {
    condition     = can(regex("ALL|ACCEPT|REJECT", var.traffic_type))
    error_message = "Values should only between: ALL, ACCEPT or REJECT"
  }
}

variable "create_local_flow_logs_store" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(any)
  default = {}
}