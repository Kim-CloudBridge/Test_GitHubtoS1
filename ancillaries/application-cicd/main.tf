# This module imports global variables that are utilized across multiple other modules.
module "global_vars" {
  source = "../../tf-global"
}

module "security_group" {
  source = "../../modules/mgmt-security-group"
  vpc_id = aws_vpc.main.id
  global_vars = module.global_vars
  management_security_group_ingress_rules = local.management_security_group_ingress_rules
  management_security_group_egress_rules  = local.management_security_group_egress_rules
  env_domain = local.env_domain
  client_id = local.client_id
  tier = local.tier
  common      = local.common_prefix_general_service
  client_env = local.env_domain
  network_account_cidr  = local.network_account_cidr
  application_name = local.application_name
}

module "s3_bucket"{
  source = "../../modules/s3"

  bucket_name = local.artifacts_bucket_name
  global_vars = module.global_vars
  client_id   = local.client_id
  

}

module "s3_policy" {
    source = "../../modules/s3-bucket-policy"
    bucket = module.s3_bucket
    policy_type = "cross_account"
    external_accounts = local.s3_external_account_access
    
}

#Get-S3Object -BucketName hms-01x-0000n-artifacts-s3-01