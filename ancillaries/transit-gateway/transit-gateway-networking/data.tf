## Networking

data "terraform_remote_state" "transit_gateway" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network/terraform.tfstate"
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

data "terraform_remote_state" "east_west_firewall" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network-active-passive-firewall/terraform.tfstate"
    region = "eu-west-2"
  }
}
data "terraform_remote_state" "direct_connect" {
  backend = "s3"
  config = {
    bucket         = "hms-01x-0000ss-tfn-states-bucket"
    key            = "terraform/eu-west-2/network/direct-connect.tfstate"
    region         = "eu-west-2"
  }
}
data "aws_ec2_transit_gateway_dx_gateway_attachment" "network" {
  transit_gateway_id = local.transit_gateway_id
  dx_gateway_id      = data.terraform_remote_state.direct_connect.outputs.dx_gateway_id
}

### Utilities
data "terraform_remote_state" "mad" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key = "terraform/eu-west-2/self-hosted-ad/terraform.tfstate"
    # key    = "terraform/eu-west-2/managed-ad/terraform.tfstate"
    region = "eu-west-2"
  }
}
data "terraform_remote_state" "cicd" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/cicd/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "shared_test_dmz" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/hms-shared-services/shared-test-domain-dmz/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "shared_test_ws" {
  backend = "s3"
  config = {
    bucket         = "hms-01x-0000ss-tfn-states-bucket"
    key            = "terraform/eu-west-2/hms-shared-services/shared-test-domain-ws/terraform.tfstate"
    region         = "eu-west-2"
  }
}

data "terraform_remote_state" "shared_test_db" {
  backend = "s3"
  config = {
    bucket         = "hms-01x-0000ss-tfn-states-bucket"
    key            = "terraform/eu-west-2/hms-shared-services/shared-test-domain-db-vpc/terraform.tfstate"
    region         = "eu-west-2"
  }
}