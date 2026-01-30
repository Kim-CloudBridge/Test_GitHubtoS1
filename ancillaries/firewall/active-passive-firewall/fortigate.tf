##############################################################################################################
#
# AWS Transit Gateway
# FortiGate setup with Active/Passive in Multiple Availability Zones
#
##############################################################################################################

##############################################################################################################
# GENERAL
##############################################################################################################

# Security Groups

resource "aws_security_group" "fg2-data-sgp" { #fg2018
  name        = "fg2-data-sgp"
  description = "Data traffic"
  vpc_id      = aws_vpc.firewall_vpc.id

  ingress {
    description = "Allow All Traffic from Internal Network"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = concat(["10.210.0.0/16", "172.210.0.0/16"], module.globalvars.global.site_networks.emea, module.globalvars.global.site_networks.apac)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fg2-data-sgp",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_security_group" "fg2-mgmt-sgp" { #fg2023
  name        = "fg2-mgmt-sgp"
  description = "Allow SSH, HTTPS and ICMP traffic"
  vpc_id      = aws_vpc.firewall_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.210.0.0/16", "83.244.209.32/27"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.210.0.0/16", "83.244.209.32/27"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["3.11.6.235/32"]
    description = "Cloud Bridge"
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["10.210.0.0/16", "83.244.209.32/27"]
  }

  ingress {
    from_port   = -1 # the ICMP type number for 'Echo Reply'
    to_port     = -1 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["10.210.0.0/16", "83.244.209.32/27"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fg2-mgmt-sgp",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_security_group" "fg2-hasync-sgp" { #fg2028
  name        = "fg2-hasync-sgp"
  description = "High Avalibility Syncronisation"
  vpc_id      = aws_vpc.firewall_vpc.id
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fg2-hasync-sgp",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_security_group_rule" "hasync-self-in" { #fg2028
  type                     = "ingress"
  description              = "Internal Trust"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.fg2-hasync-sgp.id
  security_group_id        = aws_security_group.fg2-hasync-sgp.id
}

resource "aws_security_group_rule" "hasync-self-out" { #fg2028
  type                     = "egress"
  description              = "Internal Trust"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.fg2-hasync-sgp.id
  security_group_id        = aws_security_group.fg2-hasync-sgp.id
}

##############################################################################################################
# FORTIGATES VM
##############################################################################################################
# Create the IAM role/profile for the API Call
resource "aws_iam_instance_profile" "APICall_profile" { #fg2036
  name = "APICall_profile"
  role = aws_iam_role.APICallrole.name
}

resource "aws_iam_role" "APICallrole" { #fg2036
  name = "APICall_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "APICallpolicy" { #fg2036
  name        = "APICall_policy"
  path        = "/"
  description = "Policies for the FGT APICall Role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
      [
        {
          "Effect": "Allow",
          "Action": 
            [
              "ec2:Describe*",
              "ec2:AssociateAddress",
              "ec2:AssignPrivateIpAddresses",
              "ec2:UnassignPrivateIpAddresses",
              "ec2:ReplaceRoute"
            ],
            "Resource": "*"
        }
      ]
}
EOF
}

resource "aws_iam_policy_attachment" "APICall-attach" { #fg2036
  name       = "APICall-attachment"
  roles      = [aws_iam_role.APICallrole.name]
  policy_arn = aws_iam_policy.APICallpolicy.arn
}

# Create all the eni interfaces
resource "aws_network_interface" "eni-fgt1-data" { #fg2017
  subnet_id         = local.data_subnet_aza
  security_groups   = [aws_security_group.fg2-data-sgp.id]
  source_dest_check = false
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fgt1-enidata",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_network_interface" "eni-fgt2-data" { #fg2019
  subnet_id         = local.data_subnet_azb
  security_groups   = [aws_security_group.fg2-data-sgp.id]
  source_dest_check = false
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fgt2-enidata",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_network_interface" "eni-fgt1-hb" { #fg2027
  subnet_id         = local.hasync_subnet_aza
  security_groups   = [aws_security_group.fg2-hasync-sgp.id]
  private_ips       = [cidrhost(var.firewall_private_subnets[2], 10)]
  source_dest_check = false
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fgt1-enidhb",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_network_interface" "eni-fgt2-hb" { #fg2029
  subnet_id         = local.hasync_subnet_azb
  security_groups   = [aws_security_group.fg2-hasync-sgp.id]
  private_ips       = [cidrhost(var.firewall_private_subnets[3], 10)]
  source_dest_check = false
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fgt2-enidhb",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_network_interface" "eni-fgt1-mgmt" { #fg2022
  subnet_id         = local.mgmt_subnet_aza
  security_groups   = [aws_security_group.fg2-mgmt-sgp.id]
  source_dest_check = false
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fgt1-enimgnt",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_network_interface" "eni-fgt2-mgmt" { #fg2024
  subnet_id         = local.mgmt_subnet_azb
  security_groups   = [aws_security_group.fg2-mgmt-sgp.id]
  source_dest_check = false
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fgt2-enimgnt",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

# Create and attach the eip to the units
resource "aws_eip" "eip-mgmt1" { #fg2012
  depends_on        = [aws_instance.fgt1]
  domain            = "vpc"
  network_interface = aws_network_interface.eni-fgt1-mgmt.id
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fgt1-eipmgnt",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_eip" "eip-mgmt2" { #fg2014
  depends_on        = [aws_instance.fgt2]
  domain            = "vpc"
  network_interface = aws_network_interface.eni-fgt2-mgmt.id
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-fgt2-eipmgnt",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_eip" "eip-shared" { #fg2013
  depends_on        = [aws_instance.fgt1]
  domain            = "vpc"
  network_interface = aws_network_interface.eni-fgt1-data.id
  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-eip-cluster",
        local.nomenclature_1,
        "x",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

# Create the instances
resource "aws_instance" "fgt1" { #fg2010
  //it will use region, architect, and license type to decide which ami to use for deployment
  ami               = local.ami
  instance_type     = var.instance_type
  availability_zone = local.azs[0]
  key_name          = aws_key_pair.key.key_name
  user_data = templatefile("./fgt-userdata.tpl", {
    fgt_id               = "FGT-Active"
    type                 = "${var.license_type}"
    license_file         = "${var.license}"
    fgt_data_ip          = join("/", [element(tolist(aws_network_interface.eni-fgt1-data.private_ips), 0), cidrnetmask("${var.firewall_public_subnets[2]}")])
    fgt_heartbeat_ip     = join("/", [element(tolist(aws_network_interface.eni-fgt1-hb.private_ips), 0), cidrnetmask("${var.firewall_private_subnets[2]}")])
    fgt_mgmt_ip          = join("/", [element(tolist(aws_network_interface.eni-fgt1-mgmt.private_ips), 0), cidrnetmask("${var.firewall_public_subnets[0]}")])
    data_gw              = cidrhost(var.firewall_public_subnets[2], 1)
    password             = var.password
    mgmt_gw              = cidrhost(var.firewall_public_subnets[0], 1)
    fgt_priority         = "255"
    fgt-remote-heartbeat = element(tolist(aws_network_interface.eni-fgt2-hb.private_ips), 0)
  })
  iam_instance_profile = aws_iam_instance_profile.APICall_profile.name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.eni-fgt1-data.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.eni-fgt1-hb.id
  }
  network_interface {
    device_index         = 2
    network_interface_id = aws_network_interface.eni-fgt1-mgmt.id
  }

  root_block_device {
    tags = merge(
      var.tags,
      {
        "Name" = format("%s%s-%s-ec2",
          local.nomenclature_1,
          "a",
          local.firewall_nomenclature
        )
      },
      local.tags
    )
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-ec2",
        local.nomenclature_1,
        "a",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}

resource "aws_instance" "fgt2" { #fg2011
  //it will use region, architect, and license type to decide which ami to use for deployment
  ami               = local.ami
  instance_type     = var.instance_type
  availability_zone = local.azs[1]
  key_name          = aws_key_pair.key.key_name
  user_data = templatefile("./fgt-userdata.tpl", {
    fgt_id               = "FGT-Passive"
    type                 = "${var.license_type}"
    license_file         = "${var.license2}"
    fgt_data_ip          = join("/", [element(tolist(aws_network_interface.eni-fgt2-data.private_ips), 0), cidrnetmask("${var.firewall_public_subnets[3]}")])
    fgt_heartbeat_ip     = join("/", [element(tolist(aws_network_interface.eni-fgt2-hb.private_ips), 0), cidrnetmask("${var.firewall_private_subnets[3]}")])
    fgt_mgmt_ip          = join("/", [element(tolist(aws_network_interface.eni-fgt2-mgmt.private_ips), 0), cidrnetmask("${var.firewall_public_subnets[1]}")])
    data_gw              = cidrhost(var.firewall_public_subnets[3], 1)
    password             = var.password
    mgmt_gw              = cidrhost(var.firewall_public_subnets[1], 1)
    fgt_priority         = "100"
    fgt-remote-heartbeat = element(tolist(aws_network_interface.eni-fgt1-hb.private_ips), 0)

  })
  iam_instance_profile = aws_iam_instance_profile.APICall_profile.name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.eni-fgt2-data.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.eni-fgt2-hb.id
  }
  network_interface {
    device_index         = 2
    network_interface_id = aws_network_interface.eni-fgt2-mgmt.id
  }

  root_block_device {
    tags = merge(
      var.tags,
      {
        "Name" = format("%s%s-%s-ec2",
          local.nomenclature_1,
          "b",
          local.firewall_nomenclature
        )
      },
      local.tags
    )
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s%s-%s-ec2",
        local.nomenclature_1,
        "b",
        local.firewall_nomenclature
      )
    },
    local.tags
  )
}
