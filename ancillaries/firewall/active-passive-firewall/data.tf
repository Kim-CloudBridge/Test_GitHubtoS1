#Gathers and output the current idenity account id
data "aws_caller_identity" "current" {}
output "account_id" {
  description = "The AWS Account ID number of the account that owns or contains the calling entity."
  value       = data.aws_caller_identity.current.account_id
}

#Reference to a resource(s) within a remote state file for the transit gateway informaton
data "terraform_remote_state" "transit_gateway" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network/terraform.tfstate"
    region = "eu-west-2"
  }
}

#Reference to a resource(s) within a remote state file to select an appropiate AMI to build the FortiGates
data "aws_ssm_parameter" "fortigate_ami" { #This reference gathers the relevant AMI dependant on which region and license model is specified
  name = "hsm-01x-0000n-fortigate-amis"
}

#Reference to a resource(s) within a remote state file for VPC flow log integration
data "terraform_remote_state" "central_vpc_flow_logs" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/central-vpc-fl/terraform.tfstate"
    region = "eu-west-2"
  }
}