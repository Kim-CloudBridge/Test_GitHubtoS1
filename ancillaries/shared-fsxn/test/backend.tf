terraform {
  backend "s3" {
    bucket         = "hms-01x-0000ss-tfn-states-bucket"
    key            = "terraform/eu-west-2/tier3/shared-fsxn/terraform.tfstate"
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