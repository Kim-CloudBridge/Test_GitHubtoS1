variable "global_vars" {
  description = "Global variables that are common across the infrastructure."
  type        = any
}

variable "client_id" {
  description = "The ID for the client."
  type        = string
}

variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

# variable "bucket_policy" {
#   description = "Bucket policy in json format"
#   type        = any
# }
# variable "common" {
#   description = "Common prefix"
#   type        = string
# }

# variable "client_env" {
#   description = "The environment specific to the client (e.g., 0000p, 0000t, etc...)."
#   type        = string
# }