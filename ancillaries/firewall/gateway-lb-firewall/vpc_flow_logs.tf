module "gateway_vpc_fl" { #fg1009
  source = "../../../modules/vpc-flow-logs"

  name = format("%s%s-%s-%s",
    local.nomenclature_1,
    "x",
    local.gateway_nomenclature,
    aws_vpc.gateway_vpc.id
  )

  vpc_id                       = aws_vpc.gateway_vpc.id
  s3_destination_arn           = data.terraform_remote_state.central_vpc_flow_logs.outputs.central_vpc_fl_bucket_arn
  create_local_flow_logs_store = true

  traffic_type = "ALL"

  tags = local.tags
}

module "firewall_vpc_fl" { #fg1024
  source = "../../../modules/vpc-flow-logs"

  name = format("%s%s-%s-%s",
    local.nomenclature_1,
    "x",
    local.firewall_nomenclature,
    aws_vpc.firewall_vpc.id
  )

  vpc_id                       = aws_vpc.firewall_vpc.id
  s3_destination_arn           = data.terraform_remote_state.central_vpc_flow_logs.outputs.central_vpc_fl_bucket_arn
  create_local_flow_logs_store = true

  traffic_type = "ALL"

  tags = local.tags
}