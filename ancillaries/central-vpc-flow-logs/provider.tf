provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::315235615216:role/TerraformAdministratorServiceRoleCF" # Network Account
  }
  default_tags {
    tags = {
      Terraform            = "true"
      Created_For_Customer = "Lendscape"
    }
  }
}