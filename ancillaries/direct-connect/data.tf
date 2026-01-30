data "aws_caller_identity" "current" {}

data "terraform_remote_state" "transit_gateway" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "aws_dx_connection" "primary" {
  name = module.globalvars.global.WAN_CONFIG[var.region].CONNS.primary.name
}

data "aws_dx_connection" "secondary" {
  name = module.globalvars.global.WAN_CONFIG[var.region].CONNS.secondary.name
}