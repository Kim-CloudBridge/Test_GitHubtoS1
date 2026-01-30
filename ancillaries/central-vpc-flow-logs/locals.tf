locals {
  enabled = true

  nomenclature_1 = "${module.globalvars.global.naming_convention.product}-${module.globalvars.global.naming_convention.regions[var.region]}"
  nomenclature_2 = "${var.hms_client_id}${var.hms_environment_id}"

  bucket_name = format("%sx-%s-central-vpc-fl-s3",
    local.nomenclature_1,
    local.nomenclature_2,
  )

  key_alias = format("%sx-%s-central-vpc-fl-key",
    local.nomenclature_1,
    local.nomenclature_2,
  )

  arn_format  = "arn:${data.aws_partition.current.partition}"
  create_kms  = local.enabled && (var.kms_key_arn == null || var.kms_key_arn == "")
  kms_key_arn = local.create_kms ? module.kms.arn : var.kms_key_arn

  tags = merge(var.tags, module.globalvars.global["tags"])
}