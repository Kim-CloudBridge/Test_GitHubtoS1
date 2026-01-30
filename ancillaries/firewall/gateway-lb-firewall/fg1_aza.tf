// FGTVM instance

resource "aws_network_interface" "eth0" { #fg1025
  description = "fgtvm-port1"
  subnet_id   = aws_subnet.fw_spb_01[0].id
  security_groups = flatten([
    [aws_security_group.public_allow.id],
    [for sg in aws_security_group.management_ingress : sg.id]
  ])
  tags = merge({
    Name = "FG1-pub-1a"
    },
    local.tags
  )
}

resource "aws_network_interface" "eth1" { #fg1026
  description       = "fgtvm-port2"
  subnet_id         = aws_subnet.fw_spv_02[0].id
  source_dest_check = false
  security_groups = [
    aws_security_group.allow_all.id
  ]
  tags = merge({
    Name = "FG1-pvt-1a"
    },
    local.tags
  )
}

data "aws_network_interface" "eth1" {
  id = aws_network_interface.eth1.id
}

//
data "aws_network_interface" "vpcendpointip_aza" {
  depends_on = [aws_vpc_endpoint.gwlb_endpoint_fg1]
  # id         = tolist(data.aws_vpc_endpoint.gwlbe.network_interface_ids)[0]

  filter {
    name   = "vpc-id"
    values = ["${aws_vpc.firewall_vpc.id}"]
  }
  filter {
    name   = "status"
    values = ["in-use"]
  }
  filter {
    name   = "description"
    values = ["*ELB*"]
  }
  filter {
    name   = "availability-zone"
    values = ["${local.azs[0]}"]
  }
}


data "aws_vpc_endpoint" "gwlbe" {
  vpc_id       = aws_vpc.gateway_vpc.id
  service_name = aws_vpc_endpoint_service.fg1_gwlb_service.service_name
  filter {
    name = "tag:Name"
    values = [
      format("%sa-%s-vpce-0%d",
        local.nomenclature_1,
        local.gateway_nomenclature,
        1
      )
    ]
  }
}

resource "aws_instance" "fgtvm" { #fg1027
  //it will use region, architect, and licence type to decide which ami to use for deployment
  ami               = local.ami
  instance_type     = var.size
  availability_zone = local.azs[0]
  key_name          = aws_key_pair.key.key_name
  user_data_base64 = base64encode(
    chomp(
      templatefile("${path.module}/userdata_configs/fgt1vm.conf.tftpl", {
        type         = "${var.licence_type}"
        licence_file = var.licence_type == "byol" ? jsondecode(data.aws_secretsmanager_secret_version.lic_token_01_version[0].secret_string)["LICENSE-TOKEN"] : ""
        adminsport   = "${var.adminsport}"
        cidr         = "${local.firewall_private_subnets[1][1]}"
        gateway      = cidrhost(local.firewall_private_subnets[1][0], 1)
        endpointip   = "${data.aws_network_interface.vpcendpointip_aza.private_ip}"
        hostname = format("%s%s-%s-ec2",
          local.nomenclature_1,
          substr(element(local.azs, 0), -1, -1),
          local.firewall_nomenclature
        )
        }
      )
    )
  )

  root_block_device {
    volume_type = "standard"
    volume_size = "8"
    tags = merge({
      Name = format("%s%s-%s-ec2",
        local.nomenclature_1,
        substr(element(local.azs, 0), -1, -1),
        local.firewall_nomenclature
      )
      },
      local.tags
    )
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "standard"
    tags = merge({
      Name = format("%s%s-%s-ec2",
        local.nomenclature_1,
        substr(element(local.azs, 0), -1, -1),
        local.firewall_nomenclature
      )
      },
      local.tags
    )
  }

  network_interface {
    network_interface_id = aws_network_interface.eth0.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.eth1.id
    device_index         = 1
  }

  tags = merge({
    Name = format("%s%s-%s-ec2",
      local.nomenclature_1,
      substr(element(local.azs, 0), -1, -1),
      local.firewall_nomenclature
    )
    },
    local.tags
  )
}