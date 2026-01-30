provider "aws" {
  region = var.region
  assume_role {
    role_arn     = "arn:aws:iam::214889837512:role/TerraformAdministratorServiceRoleCF" # HMS Shared services
    session_name = "LendscapeSharedServicesSession"
  }
  default_tags {
    tags = {
      Terraform            = "true"
      Created_For_Customer = "Lendscape"
    }
  }
}

