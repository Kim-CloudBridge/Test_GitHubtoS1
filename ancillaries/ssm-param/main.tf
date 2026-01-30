module "global_vars" {
  source = "git::ssh://git@ssh.bitbucket.lendscape.com:7999/hms2cloud/iac.git//tf-global?ref=main"
}

resource "aws_ssm_parameter" "ad_service_account" {
  name        = "ad-service-account"
  type        = "SecureString"
  description = "Service account credentials for active directory"
  value       = var.ad_params_value
  key_id      = aws_kms_key.ssm_params_kms.arn
}

resource "aws_kms_key" "ssm_params_kms" {
  description = "KMS key for shared SSM parameter stores"
  key_usage   = "ENCRYPT_DECRYPT"
}

resource "aws_kms_alias" "ssm_params_kms_alias" {
  name          = "alias/${local.kms_name}"
  target_key_id = aws_kms_key.ssm_params_kms.key_id
}

data "aws_iam_policy_document" "kms_key_policy" {

  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values = [
        "o-acv6pn13sm/r-l3ih/ou-l3ih-dh3v6zdv/*",
        "o-acv6pn13sm/r-l3ih/ou-l3ih-u3ukyftf/*"
      ]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values = [
        "o-acv6pn13sm/r-l3ih/ou-l3ih-dh3v6zdv/*",
        "o-acv6pn13sm/r-l3ih/ou-l3ih-u3ukyftf/*"
      ]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

resource "aws_kms_key_policy" "ssm_params_kms_policy" {
  key_id = aws_kms_key.ssm_params_kms.id
  policy = data.aws_iam_policy_document.kms_key_policy.json
}

resource "aws_ram_resource_share" "ssm_params_share" {
  name                      = "ad-service-account-ssm-params"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "ssm_params" {
  resource_arn       = aws_ssm_parameter.ad_service_account.arn
  resource_share_arn = aws_ram_resource_share.ssm_params_share.arn
}

resource "aws_ram_principal_association" "ssm_params" {
  count              = length(var.ou_arns_to_share)
  principal          = var.ou_arns_to_share[count.index]
  resource_share_arn = aws_ram_resource_share.ssm_params_share.arn
}