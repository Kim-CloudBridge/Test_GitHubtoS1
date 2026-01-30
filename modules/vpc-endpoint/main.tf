resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.eu-west-2.s3"
  #policy = var.policy
  route_table_ids = var.route_table_ids
  tags = var.tags
}