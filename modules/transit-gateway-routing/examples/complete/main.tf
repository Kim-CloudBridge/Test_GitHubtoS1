module "edge" {
  source = "../../"

  tgw_id             = "tgw-00a81cd7e3b802b56"
  tgw_route_table_id = "tgw-rtb-0b2033a4f3edcf08d"
  tgw_routing_details = {
    associated_attachments = [
      "tgw-attach-02a05ab5024875504",
      "tgw-attach-06d16453311d531ef" # vpn
    ],
    propagated_attachments = [
      "tgw-attach-06d16453311d531ef" # vpn
    ],
    static_routes = {
      "192.168.1.1/32" : "blackhole",
      "172.16.1.0/24" : "tgw-attach-06d16453311d531ef" # vpn
    }
  }
}

module "nonprod" {
  source = "../../"

  tgw_id             = "tgw-00a81cd7e3b802b56"
  tgw_route_table_id = "tgw-rtb-038e6bde157d43219"
  tgw_routing_details = {
    associated_attachments = [],
    propagated_attachments = [
    ],
    static_routes = {
      "0.0.0.0/0" : "tgw-attach-02a05ab5024875504",
      "192.168.1.1/32" : "blackhole",
    }
  }
}