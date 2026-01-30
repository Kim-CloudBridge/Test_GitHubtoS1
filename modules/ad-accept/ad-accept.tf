## To be executed in AWS accounts to join AD

resource "aws_directory_service_shared_directory_accepter" "accepter" {

  shared_directory_id = local.managed_ad_id
}