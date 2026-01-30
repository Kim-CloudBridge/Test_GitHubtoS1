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

# Get data of tier 3 shared databases
data "terraform_remote_state" "tier3_db_account" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/tier3/shared-db/terraform.tfstate"
    region = "eu-west-2"
  }
}

# Get FSxN data
data "terraform_remote_state" "tier3_fsxn" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/tier3/shared-fsxn/terraform.tfstate"
    region = "eu-west-2"
  }
}