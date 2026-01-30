data "aws_subnet" "fsx_subnet" {
  count = length(var.fsx_subnet_id)
  id    = var.fsx_subnet_id[count.index]
}