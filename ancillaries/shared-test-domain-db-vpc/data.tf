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

# data "terraform_remote_state" "north_south_firewall" {
#   backend = "s3"
#   config = {
#     bucket = "hms-01x-0000ss-tfn-states-bucket"
#     key    = "terraform/eu-west-2/network/north-south-firewall/terraform.tfstate"
#     region = "eu-west-2"
#   }
# }

data "terraform_remote_state" "central_vpc_flow_logs" {
  backend = "s3"

  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/central-vpc-fl/terraform.tfstate"
    region = "eu-west-2"
  }
}

#data "aws_secretsmanager_secret" "ad_admin_service_account" {
#  name = "aws/directory-services/d-9c67761a3c/seamless-domain-join"
#}
#
#data "aws_secretsmanager_secret_version" "ad_admin_service_account" {
#  secret_id = data.aws_secretsmanager_secret.ad_admin_service_account.id
#}

data "terraform_remote_state" "self_hosted_ad" {
  backend = "s3"

  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/self-hosted-ad/terraform.tfstate"
    region = "eu-west-2"
  }
}