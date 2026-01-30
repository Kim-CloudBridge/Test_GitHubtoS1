terraform {
  backend "s3" {
    #profile        = "lendscape-shared-services"
    bucket         = "hms-01x-0000ss-tfn-states-bucket"
    key            = "terraform/eu-west-2/hms-shared-services/shared-test-domain-db-vpc/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "hms-01x-0000ss-tfn-state-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.18.0"
    }
  }

}

provider "aws" {
  region = local.region
  # profile = "lendscape-shared-services"
  assume_role {
    role_arn     = "arn:aws:iam::${module.global_vars.global.aws_landing_zone.hms_shared_services}:role/TerraformAdministratorServiceRoleCF"
    session_name = "LendscapeSharedServicesSession"
  }
  default_tags {
    tags = {
      Terraform            = "true"
      Created_For_Customer = "Lendscape"
    }
  }
}

data "aws_caller_identity" "current" {}
output "account_id" {
  description = "The AWS Account ID number of the account that owns or contains the calling entity."
  value       = data.aws_caller_identity.current.account_id
}