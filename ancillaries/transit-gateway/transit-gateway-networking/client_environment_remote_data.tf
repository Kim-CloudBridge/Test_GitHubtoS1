data "terraform_remote_state" "client_0000" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/0000poc-test/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "client_0852_test" {
  backend = "s3"
  config = {
    bucket         = "hms-01x-0000ss-tfn-states-bucket"
    key            = "terraform/eu-west-2/client-0852-test/terraform.tfstate"
    region         = "eu-west-2"
  }
}

data "terraform_remote_state" "client_0000_test_shared_web_server" {
  backend = "s3"
  config = {
    bucket         = "hms-01x-0000ss-tfn-states-bucket"
    key            = "terraform/eu-west-2/hms-shared-services/shared-test-domain-ws/terraform.tfstate"
    region         = "eu-west-2"
  }
}