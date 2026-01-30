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

  tags = merge({
    Name = local.ssm_role_name
  }, local.tags)
}

# Get Secrets from Secret Manager
resource "aws_iam_policy" "secrets_manager_get_secret_policy" {
  name        = local.secrets_manager_policy_name
  description = "Policy granting access to all secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "kms_grant_policy" {
  name        = local.kms_grant_policy_name
  description = "Policy granting access to use the shared private AMI"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ]
        Effect   = "Allow",
        Resource = [
          "arn:aws:kms:eu-west-2:967702029755:key/5f63e9c2-0c83-4aa4-8cc7-b15a96423513",
          "arn:aws:kms:eu-west-2:214889837512:key/3c0f43e4-ec43-42c7-97a4-4f70afbce80c",
          "arn:aws:kms:eu-west-2:665790084258:key/70e38a0e-7418-4719-9b8b-a59a3011d67c"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_read_policy" {
  name        = local.ec2_read_policy_name
  description = "Policy granting access to get EC2 details"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:DescribeAddresses",
          "ec2:DescribeInstances",
          "ec2:DescribeSubnets"
        ]
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "fsx_read_policy" {
  name        = local.fsx_read_policy_name
  description = "Policy granting access to get FSx details"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "fsx:DescribeFileSystems",
          "fsx:DescribeStorageVirtualMachines",
          "fsx:DescribeVolumes"
        ]
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Allow to assume role policy
resource "aws_iam_policy" "assume_role_policy" {
  count      = local.assume_role_arn_exists ? 1 : 0
  name        = local.assume_role_policy_name
  description = "Policy granting access to assume role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect   = "Allow",
        Resource = "${var.assume_role_arn}"
      }
    ]
  })
}

# Assume role target
resource "aws_iam_role" "assume_role" {
  count = var.allow_assume_role_here ? 1 : 0
  name  = local.cicd_assume_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          AWS = [for account_id in var.allowed_account_ids : "arn:aws:iam::${account_id}:root"]
        }
      }
    ]
  })

  tags = merge({
    Name = local.cicd_assume_role_name
  }, local.tags)
}

# Attachments
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # AWS Managed Policy for SSM
}
resource "aws_iam_role_policy_attachment" "cloudwatchagent_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy" # AWS Managed Policy for CloudWatch Agent
}
resource "aws_iam_role_policy_attachment" "ssm_directory_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess" # AWS Managed Policy for SSM Directory Service
}
resource "aws_iam_role_policy_attachment" "ssm_automation_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole" # AWS Managed Policy for SSM Automation
}
resource "aws_iam_role_policy_attachment" "secrets_manager_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.secrets_manager_get_secret_policy.arn
}
resource "aws_iam_role_policy_attachment" "kms_grant_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.kms_grant_policy.arn
}
resource "aws_iam_role_policy_attachment" "ec2_read_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ec2_read_policy.arn
}
resource "aws_iam_role_policy_attachment" "fsx_read_attach" {
  count      = var.require_fsx_policy ? 1 : 0
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.fsx_read_policy.arn
}
resource "aws_iam_role_policy_attachment" "assume_role_attach" {
  count      = local.assume_role_arn_exists ? 1 : 0
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.assume_role_policy[0].arn
}
resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # AWS Managed Policy for CloudWatch Agent
}
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = local.ssm_instance_profile_name
  role = aws_iam_role.ssm_role.name
}
# Policies attached to Assume role
resource "aws_iam_role_policy_attachment" "fsx_read_attach_assume_role" {
  count      = var.allow_assume_role_here ? 1 : 0
  role       = aws_iam_role.assume_role[0].name
  policy_arn = aws_iam_policy.fsx_read_policy.arn
}
resource "aws_iam_role_policy_attachment" "secrets_manager_attach_assume_role" {
  count      = var.allow_assume_role_here ? 1 : 0
  role       = aws_iam_role.assume_role[0].name
  policy_arn = aws_iam_policy.secrets_manager_get_secret_policy.arn
}
resource "aws_iam_role_policy_attachment" "kms_grant_attach_assume_role" {
  count      = var.allow_assume_role_here ? 1 : 0
  role       = aws_iam_role.assume_role[0].name
  policy_arn = aws_iam_policy.kms_grant_policy.arn
}
