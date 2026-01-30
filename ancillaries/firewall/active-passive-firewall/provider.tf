terraform {
  backend "s3" {
    profile        = "lendscape-shared-services"
    bucket         = "hms-01x-0000ss-tfn-states-bucket"
    key            = "terraform/eu-west-2/network-active-passive-firewall/terraform.tfstate" #UpdateMe #A state file should be unique use a unique key e.g. ../../update-me/terraform.tfstate 
    region         = "eu-west-2"
    dynamodb_table = "hms-01x-0000ss-tfn-state-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }

}

provider "aws" {
  region = var.region
  #profile = "lendscape-shared-services"
  assume_role {
    role_arn     = "arn:aws:iam::129360778929:role/TerraformAdministratorServiceRoleCF" #UpdateMe #Ensure the correct numeric account ID is used where you require yout resources to be deployed 
    session_name = "LendscapeSharedServicesSession"
  }
  default_tags {
    tags = {
      Terraform            = "true"
      Created_For_Customer = "Lendscape"
    }
  }
}
