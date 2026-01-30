locals {

  # Dynamically generate a map of Customer CIDR to North South Firewall routing
  dmz_to_app_routes = { for cidr in module.globalvars.global["site_networks"]["eu-west-2_customer_range"]: cidr => data.terraform_remote_state.north_south_firewall.outputs.gateway_vpc_transit_gateway_vpc_attachment }


  core = { #tgw0105
    associated_attachments = {
      "managed_ad" = data.terraform_remote_state.mad.outputs.tgw_attachment_id,
      "north_south_firewall" = data.terraform_remote_state.north_south_firewall.outputs.firewall_vpc_transit_gateway_vpc_attachment,
      "cicd_app_vpc" = data.terraform_remote_state.cicd.outputs.cicd_app_vpc_tgw_att,
      "shared_test_domain_db" = data.terraform_remote_state.shared_test_db.outputs.test_db_vpc_tgw_att,
    }
    propagated_attachments = {}
    static_routes = {
      "0.0.0.0/0" : data.terraform_remote_state.east_west_firewall.outputs.tgw_attachment,
    }
  }


  ns_insp = { #tgw0106
    associated_attachments = {
      "north_south_firewall" = data.terraform_remote_state.north_south_firewall.outputs.gateway_vpc_transit_gateway_vpc_attachment,
    }
    propagated_attachments = {
      "shared_test_domain_dmz" = data.terraform_remote_state.shared_test_dmz.outputs.test_dmz_vpc_tgw_att,
      "client_0000_app_vpc" = data.terraform_remote_state.client_0000.outputs.client-0000_app_vpc_tgw_att,
      "client_0000_dmz_vpc" = data.terraform_remote_state.client_0000.outputs.client-0000_dmz_vpc_tgw_att,
      "client_0852_test_app_vpc" = data.terraform_remote_state.client_0852_test.outputs.client-0852_app_vpc_tgw_att,
      "client_0000_test_shared_web_server" = data.terraform_remote_state.client_0000_test_shared_web_server.outputs.test_ws_vpc_tgw_att
    }
    static_routes = {
      "0.0.0.0/0" : "blackhole",
    }
  }

  ew_insp = { #tgw0107
    associated_attachments = {
      "east_west_firewall" = data.terraform_remote_state.east_west_firewall.outputs.tgw_attachment
    }
    propagated_attachments = {
      "client_0000_app_vpc" = data.terraform_remote_state.client_0000.outputs.client-0000_app_vpc_tgw_att,
      "client_0000_dmz_vpc" = data.terraform_remote_state.client_0000.outputs.client-0000_dmz_vpc_tgw_att,
      "client_0852_test_app_vpc" = data.terraform_remote_state.client_0852_test.outputs.client-0852_app_vpc_tgw_att
      "managed_ad" = data.terraform_remote_state.mad.outputs.tgw_attachment_id,
      "cicd_app_vpc" = data.terraform_remote_state.cicd.outputs.cicd_app_vpc_tgw_att,
      "shared_test_domain_ws" = data.terraform_remote_state.shared_test_ws.outputs.test_ws_vpc_tgw_att,
      "shared_test_domain_db" = data.terraform_remote_state.shared_test_db.outputs.test_db_vpc_tgw_att,
    }
    static_routes = {
      "0.0.0.0/0" : "blackhole",
    }
  }

  prod_dmz = { #tgw0108
    associated_attachments = {}
    propagated_attachments = {}
    static_routes = merge({
      # cidrsubnet(module.globalvars.global["site_networks"][var.region], 6, 31) : "blackhole",
      cidrsubnet(module.globalvars.global["site_networks"][var.region], 6, 28) : data.terraform_remote_state.north_south_firewall.outputs.gateway_vpc_transit_gateway_vpc_attachment, # "10.210.112.0/22" - PROD CIDR for Shared Web Servers
      "0.0.0.0/0" : "blackhole",
    }, local.dmz_to_app_routes)
  }

  prod_apps = { #tgw0109
    associated_attachments = {}
    propagated_attachments = {}
    static_routes = {
      module.globalvars.global["site_networks"][var.region] : data.terraform_remote_state.east_west_firewall.outputs.tgw_attachment,
      module.globalvars.global["site_networks"]["${var.region}-dmz"] : data.terraform_remote_state.north_south_firewall.outputs.gateway_vpc_transit_gateway_vpc_attachment,
      "0.0.0.0/0" : data.terraform_remote_state.east_west_firewall.outputs.tgw_attachment,
    }
  }

  test_dmz = { #tgw0110
    associated_attachments = {
      # data.terraform_remote_state.client_0000.outputs.client-0000_dmz_vpc_tgw_att,
      "shared_test_domain_dmz" = data.terraform_remote_state.shared_test_dmz.outputs.test_dmz_vpc_tgw_att
    }
    propagated_attachments = {}
    static_routes = merge({
      # cidrsubnet(module.globalvars.global["site_networks"][var.region], 6, 31) : "blackhole",
      cidrsubnet(module.globalvars.global["site_networks"][var.region], 6, 25) : data.terraform_remote_state.north_south_firewall.outputs.gateway_vpc_transit_gateway_vpc_attachment, # "10.210.100.0/22" - TEST CIDR for Shared Web Servers
      "0.0.0.0/0" : "blackhole",
    }, local.dmz_to_app_routes)
  }

  test_apps = { #tgw0111
    associated_attachments = {
      "client_0000_app_vpc" = data.terraform_remote_state.client_0000.outputs.client-0000_app_vpc_tgw_att,
      "client_0852_test_app_vpc" = data.terraform_remote_state.client_0852_test.outputs.client-0852_app_vpc_tgw_att,
      "shared_test_domain_ws" = data.terraform_remote_state.shared_test_ws.outputs.test_ws_vpc_tgw_att,
    }
    propagated_attachments = {}
    static_routes = {
      module.globalvars.global["site_networks"][var.region] : data.terraform_remote_state.east_west_firewall.outputs.tgw_attachment,
      module.globalvars.global["site_networks"]["${var.region}-dmz"] : data.terraform_remote_state.north_south_firewall.outputs.gateway_vpc_transit_gateway_vpc_attachment,
      "0.0.0.0/0" : data.terraform_remote_state.east_west_firewall.outputs.tgw_attachment,
    }
  }

  dx_vpn = { #tgw0112
    associated_attachments = {
      "direct_connect_gateway" = data.aws_ec2_transit_gateway_dx_gateway_attachment.network.id
    }
    propagated_attachments = {}
    static_routes = {
      module.globalvars.global["site_networks"][var.region] : data.terraform_remote_state.east_west_firewall.outputs.tgw_attachment,
      "0.0.0.0/0" : "blackhole",
    }
  }
}