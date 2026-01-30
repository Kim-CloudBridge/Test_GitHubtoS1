provider "aws" {
  region = var.region
  #   profile = "lendscape-shared-services"
  assume_role {
    role_arn = "arn:aws:iam::129360778929:role/TerraformAdministratorServiceRoleCF" # Network Account
    # session_name = "LendscapeSharedServicesSession"
  }
  default_tags {
    tags = {
      Terraform            = "true"
      Created_For_Customer = "Lendscape"
    }
  }
}