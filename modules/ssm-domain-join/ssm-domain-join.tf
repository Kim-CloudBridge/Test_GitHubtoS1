data "aws_directory_service_directory" "my_domain_controller" {
  directory_id = var.directory_id
}

resource "aws_ssm_document" "ad-join-domain" {
  name          = "ad-join-domain"
  document_type = "Command"
  content = jsonencode(
    {
      "schemaVersion" = "2.2"
      "description"   = "aws:domainJoin"
      "mainSteps" = [
        {
          "action" = "aws:domainJoin",
          "name"   = "domainJoin",
          "inputs" = {
            "directoryId" : data.aws_directory_service_directory.my_domain_controller.id,
            "directoryName" : data.aws_directory_service_directory.my_domain_controller.name
            "dnsIpAddresses" : sort(data.aws_directory_service_directory.my_domain_controller.dns_ip_addresses)
          }
        }
      ]
    }
  )
}