## Data source to get the AD ID
data "terraform_remote_state" "managed_ad" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/managed-ad/terraform.tfstate"
    region = "eu-west-2"
  }
}

## Data source to get the TGW ID
data "terraform_remote_state" "transit_gateway" {
  backend = "s3"
  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/network/terraform.tfstate"
    region = "eu-west-2"
  }
}

# data "terraform_remote_state" "north_south_firewall" {
#   backend = "s3"
#   config = {
#     bucket = "hms-01x-0000ss-tfn-states-bucket"
#     key    = "terraform/eu-west-2/network/north-south-firewall/terraform.tfstate"
#     region = "eu-west-2"
#   }
# }

data "terraform_remote_state" "central_vpc_flow_logs" {
  backend = "s3"

  config = {
    bucket = "hms-01x-0000ss-tfn-states-bucket"
    key    = "terraform/eu-west-2/central-vpc-fl/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["967702029755"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      module.s3_bucket.bucket_arn,
      "${module.s3_bucket.bucket_arn}/*",
    ]
  }
}