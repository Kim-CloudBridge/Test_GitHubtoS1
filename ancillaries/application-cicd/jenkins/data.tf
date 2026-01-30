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

data "terraform_remote_state" "cicd_components" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/cicd/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "north_south_firewall" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network/north-south-firewall/terraform.tfstate"
    region = "eu-west-2"
  }
}