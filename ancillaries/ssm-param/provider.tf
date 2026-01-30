provider "aws" {
  region = var.region
  assume_role {
    role_arn     = "arn:aws:iam::665790084258:role/TerraformAdministratorServiceRoleCF"
    session_name = "LendscapeSharedServicesSession"
  }
  default_tags {
    tags = {
      Terraform            = "true"
      Created_For_Customer = "Lendscape"
    }
  }
}

