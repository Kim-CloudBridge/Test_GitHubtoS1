data "aws_iam_policy_document" "ad_log_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    principals {
      identifiers = ["ds.amazonaws.com"]
      type        = "Service"
    }

    resources = ["${aws_cloudwatch_log_group.managed_ad_cwlogs.arn}:*"]

    effect = "Allow"
  }
}

module "global_vars" {
  source = "../../tf-global"
}

################
## Managed AD
################
resource "aws_directory_service_directory" "microsoft_ad" { #ad1001
  name     = var.directory_name                                                     ## Should get from variables
  password = jsonencode(data.aws_secretsmanager_secret_version.creds.secret_string) ## Should be pulled from Secrets manager
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = "vpc-04e66674656c04cc5"                                           ## Get from VPC template
    subnet_ids = ["subnet-07d209288bee92242", "subnet-0a86fe5ebbd25effc"] ## Get from VPC template
  }

  tags = merge(
    {
      "Name" = format("%sx-%s-managed-ad",
        local.nomenclature_1,
        local.nomenclature_2
      )
    },
    local.tags,
  )
}

resource "aws_directory_service_log_subscription" "cloudwatch_logging" {
  directory_id   = aws_directory_service_directory.microsoft_ad.id
  log_group_name = aws_cloudwatch_log_group.managed_ad_cwlogs.name
}

###############
# CW Logs
###############
resource "aws_cloudwatch_log_group" "managed_ad_cwlogs" {
  name              = "/aws/directoryservice/${aws_directory_service_directory.microsoft_ad.id}"
  retention_in_days = 30

  tags = merge(
    {
      "Name" = format("%sx-%s-managed-ad-cwlogs",
        local.nomenclature_1,
        local.nomenclature_2
      )
    },
    local.tags,
  )
}

resource "aws_cloudwatch_log_resource_policy" "ad_log_policy" {
  policy_document = data.aws_iam_policy_document.ad_log_policy.json
  policy_name     = "managed-ad-logging-policy"
}



###############
# AD sharing
###############
resource "aws_directory_service_shared_directory" "ad_sharing" {
  for_each     = toset(var.account_ids)
  directory_id = aws_directory_service_directory.microsoft_ad.id

  target {
    id = each.value
  }
}

########################
# Connection for Conditional Forwarding to On-premise
########################
resource "aws_security_group_rule" "onpremise_dns_host" {
  count = length(local.dns_protocols)

  security_group_id = aws_directory_service_directory.microsoft_ad.security_group_id
  cidr_blocks = module.globalvars.global.site_networks.eu-dns
  protocol = local.dns_protocols[count.index]
  from_port = 53
  to_port = 53
  type = "egress"
}