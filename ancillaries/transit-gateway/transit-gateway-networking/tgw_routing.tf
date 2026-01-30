module "core" { #tgw0105
  source = "../../../modules/transit-gateway-routing"

  tgw_id             = local.transit_gateway_id #tgw0101
  tgw_route_table_id = module.transit_gateway_route_tables.this_transit_gw_rtb["${local.network_nomenclature_2}-core"] #tgw0105
  tgw_routing_details = {
    associated_attachments = local.core.associated_attachments,
    propagated_attachments = local.core.propagated_attachments,
    static_routes          = local.core.static_routes
  }
}

module "ns-insp" { #tgw0106
  source = "../../../modules/transit-gateway-routing"

  tgw_id             = local.transit_gateway_id #tgw0101
  tgw_route_table_id = module.transit_gateway_route_tables.this_transit_gw_rtb["${local.network_nomenclature_2}-ns-insp"] #tgw0106
  tgw_routing_details = {
    associated_attachments = local.ns_insp.associated_attachments,
    propagated_attachments = local.ns_insp.propagated_attachments,
    static_routes          = local.ns_insp.static_routes
  }
}

module "ew-insp" { #tgw0107
  source = "../../../modules/transit-gateway-routing"

  tgw_id             = local.transit_gateway_id #tgw0101
  tgw_route_table_id = module.transit_gateway_route_tables.this_transit_gw_rtb["${local.network_nomenclature_2}-ew-insp"] #tgw0107
  tgw_routing_details = {
    associated_attachments = local.ew_insp.associated_attachments,
    propagated_attachments = local.ew_insp.propagated_attachments,
    static_routes          = local.ew_insp.static_routes
  }
}

module "prod-dmz" { #tgw0108
  source = "../../../modules/transit-gateway-routing"

  tgw_id             = local.transit_gateway_id #tgw0101
  tgw_route_table_id = module.transit_gateway_route_tables.this_transit_gw_rtb["${local.prod_nomenclature_2}-dmz"] #tgw0108
  tgw_routing_details = {
    associated_attachments = local.prod_dmz.associated_attachments,
    propagated_attachments = local.prod_dmz.propagated_attachments,
    static_routes          = local.prod_dmz.static_routes
  }
}

module "prod-apps" { #tgw0109
  source = "../../../modules/transit-gateway-routing"

  tgw_id             = local.transit_gateway_id #tgw0101
  tgw_route_table_id = module.transit_gateway_route_tables.this_transit_gw_rtb["${local.prod_nomenclature_2}-apps"] #tgw0109
  tgw_routing_details = {
    associated_attachments = local.prod_apps.associated_attachments,
    propagated_attachments = local.prod_apps.propagated_attachments,
    static_routes          = local.prod_apps.static_routes
  }
}

module "test-dmz" { #tgw0110
  source = "../../../modules/transit-gateway-routing"

  tgw_id             = local.transit_gateway_id #tgw0101
  tgw_route_table_id = module.transit_gateway_route_tables.this_transit_gw_rtb["${local.test_nomenclature_2}-dmz"] #tgw0110
  tgw_routing_details = {
    associated_attachments = local.test_dmz.associated_attachments,
    propagated_attachments = local.test_dmz.propagated_attachments,
    static_routes          = local.test_dmz.static_routes
  }
}

module "test-apps" { #tgw0111
  source = "../../../modules/transit-gateway-routing"

  tgw_id             = local.transit_gateway_id #tgw0101
  tgw_route_table_id = module.transit_gateway_route_tables.this_transit_gw_rtb["${local.test_nomenclature_2}-apps"] #tgw0111
  tgw_routing_details = {
    associated_attachments = local.test_apps.associated_attachments,
    propagated_attachments = local.test_apps.propagated_attachments,
    static_routes          = local.test_apps.static_routes
  }
}

module "dx-vpn" { #tgw0112
  source = "../../../modules/transit-gateway-routing"

  tgw_id             = local.transit_gateway_id #tgw0101
  tgw_route_table_id = module.transit_gateway_route_tables.this_transit_gw_rtb["${local.network_nomenclature_2}-dx-vpn"] #tgw0112
  tgw_routing_details = {
    associated_attachments = local.dx_vpn.associated_attachments,
    propagated_attachments = local.dx_vpn.propagated_attachments,
    static_routes          = local.dx_vpn.static_routes
  }
}