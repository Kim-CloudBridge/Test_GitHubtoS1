data "terraform_remote_state" "transit_gateway" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "central_vpc_flow_logs" {
  backend = "s3"

  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/central-vpc-fl/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "aws_ssm_parameter" "fortigate_ami" {
  name = "hsm-01x-0000n-fortigate-amis"
}

data "aws_secretsmanager_secret" "lic_token_01" {
  count = var.licence_type == "byol" ? 1 : 0
  name  = "hms-01x-0000n-forti-ns-token-01"
}

data "aws_secretsmanager_secret_version" "lic_token_01_version" {
  count     = var.licence_type == "byol" ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.lic_token_01[0].id
}

data "aws_secretsmanager_secret" "lic_token_02" {
  count = var.licence_type == "byol" ? 1 : 0
  name  = "hms-01x-0000n-forti-ns-token-02"
}

data "aws_secretsmanager_secret_version" "lic_token_02_version" {
  count     = var.licence_type == "byol" ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.lic_token_02[0].id
}