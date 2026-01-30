module "global_vars" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//tf-global?ref=main"
}

#########################
# Self-Hosted AD on EC2
########################
resource "aws_instance" "ad_instance" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = count.index % 2 == 0 ? aws_subnet.shared_spv_01[0].id : aws_subnet.shared_spv_01[1].id
  iam_instance_profile   = aws_iam_role.selfhosted_ad_instance_role.name
  vpc_security_group_ids = [aws_security_group.self_hosted_ec2_sgp.id]
  # user_data              = templatefile("./self-hosted-ad-config/userdata.tpl", { hostname = format("ad-instance-%d", count.index + 1) })
  tags = merge(
    {
      "Name" = format("%sx-%s-self-hosted-ad-%02d",
        local.nomenclature_1,
        local.nomenclature_2,
        count.index + 1
      )
    },
    local.tags,
  )
}

resource "aws_security_group" "self_hosted_ec2_sgp" {
  name        = format("%sx-%s-self-hosted-ad-sg", local.nomenclature_1, local.nomenclature_2)
  description = "AD security group for self hosted AD"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    {
      "Name" = format("%s-%s-self-hosted-ad-sg",
        local.nomenclature_1,
        local.nomenclature_2
      )
    },
    local.tags,
  )
}

resource "aws_security_group_rule" "self_hosted_ad_dynamic_ingress" {
  for_each          = { for rule in local.self_hosted_security_group_ingress_rules : "${rule.type}-${rule.protocol}-${rule.from_port}-${rule.to_port}-${rule.description}" => rule if rule.type == "ingress" }
  type              = "ingress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.self_hosted_ec2_sgp.id
  description       = each.value["description"]
}

resource "aws_security_group_rule" "self_hosted_ad_dynamic_egress" {
  for_each          = { for rule in local.self_hosted_security_group_egress_rules : "${rule.type}-${rule.protocol}-${rule.from_port}-${rule.to_port}-${rule.description}" => rule if rule.type == "egress" }
  type              = "egress"
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.self_hosted_ec2_sgp.id
  description       = each.value["description"]
}

########################
# Connection for Conditional Forwarding to On-premise
########################
resource "aws_security_group_rule" "onpremise_dns_host" {
  count = length(local.dns_protocols)

  security_group_id = aws_security_group.self_hosted_ec2_sgp.id
  cidr_blocks       = module.global_vars.global.site_networks.eu-dns
  protocol          = local.dns_protocols[count.index]
  from_port         = 53
  to_port           = 53
  type              = "egress"
}

########################
# IAM Role config
########################

resource "aws_iam_role" "selfhosted_ad_instance_role" {
  name = format("%sx-%s-self-hosted-instance-role",
    local.nomenclature_1,
    local.nomenclature_2
  )
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "selfhosted_ad_instance_profile" {
  name = format("%sx-%s-self-hosted-instance-role",
    local.nomenclature_1,
    local.nomenclature_2
  )
  role = aws_iam_role.selfhosted_ad_instance_role.name
}

resource "aws_iam_role_policy_attachment" "ad_instance_policy_attachment" {
  role       = aws_iam_role.selfhosted_ad_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ad_instance_sqs_policy_attachment" {
  role       = aws_iam_role.selfhosted_ad_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "ad_instance_ssm_policy_attachment" {
  role       = aws_iam_role.selfhosted_ad_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_role_policy_attachment" "ad_instance_ssm_default_policy_attachment" {
  role       = aws_iam_role.selfhosted_ad_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}



########################
# SQS Queue for AD Unjoining
########################

resource "aws_sqs_queue" "ad_unjoin" {
  name = format("%sx-%s-ad-unjoin",
    local.nomenclature_1,
  local.nomenclature_2)
  delay_seconds              = 90
  max_message_size           = 256000
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 30
  tags = merge(
    {
      "Name" = format("%sx-%s-ad-unjoin",
        local.nomenclature_1,
        local.nomenclature_2
      )
    },
    local.tags,
  )
}

#Currently deployed on CI/CD account only, update principal once lambda and eventbridge are configured on other accounts
data "aws_iam_policy_document" "sqs_policy" {
  statement {
    actions = [
      "sqs:SendMessage"
    ]

    resources = [aws_sqs_queue.ad_unjoin.arn]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values = ["o-acv6pn13sm/r-l3ih/ou-l3ih-dh3v6zdv/*",
        "o-acv6pn13sm/r-l3ih/ou-l3ih-u3ukyftf/*"
      ]
    }
  }
}

resource "aws_sqs_queue_policy" "ad_unjoin_policy" {
  queue_url = aws_sqs_queue.ad_unjoin.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}

##################
# VPC Flow Logs
##################
module "vpc_fl" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//modules/vpc-flow-logs?ref=main"

  name = format("%s%s-%s-%s",
    local.nomenclature_1,
    "x",
    local.nomenclature_2,
    aws_vpc.main.id
  )
  vpc_id                       = aws_vpc.main.id
  s3_destination_arn           = data.terraform_remote_state.central_vpc_flow_logs.outputs.central_vpc_fl_bucket_arn
  create_local_flow_logs_store = true

  traffic_type = "ALL"

  tags = local.tags
}