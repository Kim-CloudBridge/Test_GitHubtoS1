module "transit_gateway_route_tables" {
  source = "../../../modules/transit-gateway-route-tables"

  transit_gateway_id = local.transit_gateway_id #tgw0101

  transit_gateway_naming_prefix = local.nomenclature_1

  transit_gateway_route_tables = [
    "${local.network_nomenclature_2}-core", #tgw0105
    "${local.network_nomenclature_2}-ns-insp", #tgw0106
    "${local.network_nomenclature_2}-ew-insp", #tgw0107
    "${local.prod_nomenclature_2}-dmz", #tgw0108
    "${local.prod_nomenclature_2}-apps", #tgw0109
    "${local.test_nomenclature_2}-dmz", #tgw0110
    "${local.test_nomenclature_2}-apps", #tgw0111
    "${local.network_nomenclature_2}-dx-vpn", #tgw0112
  ]

  tags = local.tags
}