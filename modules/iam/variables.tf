variable "client_id" {
  description = "The ID for the client."
  type        = string
}
variable "client_env" {
  description = "The environment specific to the client (e.g., 0000p, 0000t, etc...)."
  type        = string
}
variable "global_vars" {
  description = "Global variables that are common across the infrastructure."
  type        = any
}
variable "environment" {
  description = "Environment specific configurations."
  type        = any
  default     = null
}
variable "common" {
  description = "Common prefix"
  type        = string
}
variable "env_domain" {
  description = "The domain of this environment"
  type        = string
}
variable "tier" {
  description = "Type of tier (tier1, tier2, tier3)"
  type        = string
}
variable "require_fsx_policy" {
  description = "FSx permission required?"
  type        = bool
  default     = false
}
variable "allow_assume_role_here" {
  description = "Need to assume role to this account?"
  type        = bool
  default     = false
}
variable "allowed_account_ids" {
  description = "Account IDs to allow assume role "
  type        = list
  default     = null
}
variable "assume_role_arn" {
  description = "ARN of role to assume"
  type        = string
  default     = null
}