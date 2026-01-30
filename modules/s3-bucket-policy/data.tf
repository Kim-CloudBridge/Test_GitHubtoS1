data "aws_caller_identity" "current" {}
data "aws_region" "current" {}



data "aws_iam_policy_document" "access_logs_policy" {
  statement {
    sid = "AWSLogDeliveryALB"
    principals {
      type        = "AWS"
      identifiers = [format ("arn:aws:iam::%s:root", "652711504416")]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${var.bucket.bucket_arn}/*",
    ]
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      "${var.bucket.bucket_arn}",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        "${data.aws_caller_identity.current.account_id}"
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
      ]
    }
  }

  statement {
    sid = "AWSLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${var.bucket.bucket_arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        "${data.aws_caller_identity.current.account_id}"
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}


data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.external_accounts
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      var.bucket.bucket_arn,
      "${var.bucket.bucket_arn}/*",
    ]
  }
}