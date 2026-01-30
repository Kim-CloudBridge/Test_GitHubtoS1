data "aws_secretsmanager_secret" "ad_admin_service_account" {
  name = "ad_admin/service_account"
}

data "aws_secretsmanager_secret_version" "ad_admin_service_account" {
  secret_id = data.aws_secretsmanager_secret.ad_admin_service_account.id
}

## Data source to get the AD ID
data "terraform_remote_state" "managed_ad" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/managed-ad/terraform.tfstate"
    region = "eu-west-2"
  }
}

## Data source to get the TGW ID
data "terraform_remote_state" "transit_gateway" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network/terraform.tfstate"
    region = "eu-west-2"
  }
}

## Data source to get the E/W Firewall
data "terraform_remote_state" "ew_firewall" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network-active-passive-firewall/terraform.tfstate"
    region = "eu-west-2"
  }
}

## Data source to get the Shared Services VPC components
data "terraform_remote_state" "shared_svcs_networking" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/hms-shared-services/shared-test-domain-db-vpc/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "aws_subnet" "fsx_subnet" {
  count = length(local.shared_svcs_db_subnets)
  # id = element(local.shared_svcs_db_subnets[*], count.index)
  id = local.shared_svcs_db_subnets[count.index]
}