resource "aws_instance" "jenkins_master_node" {
  subnet_id              = local.cicd_vpc_subnets[0]
  ami                    = var.ami_id
  instance_type          = var.jenkins_instance_type
  iam_instance_profile   = aws_iam_instance_profile.jenkins_instance_profile.name
  vpc_security_group_ids = [local.mgmt_sec_grp_id, module.security_group.mgmt_sec_grp_id]

  tags = merge(
    {
      "Name" = local.jenkins_instance_name,
      "Hostname" = local.jenkins_hostname,
      AutoManage = true
    },
    local.tags,
  )
  user_data            = templatefile("./jenkins-config/userdata.tpl", { hostname = local.jenkins_hostname, domain_name =  local.ad_dns_name, secret_id = var.ad_admin_secrets_id})
}

# resource "aws_instance" "jenkins_master_node_test" {
#   subnet_id              = local.cicd_vpc_subnets[0]
#   ami                    = var.ami_id
#   instance_type          = "t2.micro"
#   iam_instance_profile   = aws_iam_instance_profile.jenkins_instance_profile.name
#   vpc_security_group_ids = [local.mgmt_sec_grp_id, module.security_group.mgmt_sec_grp_id]

#   tags = merge(
#     {
#       "Name" = "Test-instance",
#       "Hostname" = local.jenkins_hostname,
#       AutoManage = true,
#     },
#     local.tags,
#   )

#   # user_data = file("jenkins-config/install-jenkins.sh")
#   user_data            = templatefile("./jenkins-config/userdata-copy.tpl", { hostname = local.jenkins_hostname, domain_name =  local.ad_dns_name})
# }



# SSH Access using SSM
resource "aws_iam_role" "ssm_role" {
  name = local.ssm_role_name
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

  tags =  local.tags
}

## Jenkins security groups
module "security_group" {
  source                                  = "../../../modules/mgmt-security-group"
  vpc_id                                  = local.cicd_vpc
  global_vars                             = module.global_vars
  management_security_group_ingress_rules = local.jenkins_security_group_ingress_rules
  management_security_group_egress_rules  = local.jenkins_security_group_egress_rules
  env_domain                              = local.env_domain
  client_id                               = local.client_id
  tier                                    = local.tier
  common                                  = local.common_prefix
  client_env                              = local.env_domain
  network_account_cidr                    = local.network_account_cidr
  application_name                        = local.application_name
}