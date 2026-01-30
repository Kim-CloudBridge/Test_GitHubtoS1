## Data source to get the TGW ID
data "terraform_remote_state" "transit_gateway" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "central_vpc_flow_logs" {
  backend = "s3"

  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/central-vpc-fl/terraform.tfstate"
    region = "eu-west-2"
  }
}

# @TODO: Shift data resource to self hosted AD tfstate if needed
## Data source to get the AD ID
# data "terraform_remote_state" "managed_ad" {
#   backend = "s3"
#   config = {
#     bucket = "hms-01x-0000ss-tfn-states-bucket"
#     key    = "terraform/eu-west-2/managed-ad/terraform.tfstate"
#     region = "eu-west-2"
#   }
# }

data "terraform_remote_state" "shared_test_domain_public_certs" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/hms-management-utilities/shared-test-domain-public-cert/terraform.tfstate"
    region = "eu-west-2"
  }
}