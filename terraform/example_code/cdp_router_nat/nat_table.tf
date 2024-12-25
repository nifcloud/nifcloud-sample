resource "nifcloud_nat_table" "nat" {
  snat {
    rule_number                   = "1"
    description                   = "router_nat_snat"
    protocol                      = "ALL"
    source_address                = "192.0.2.2"
    outbound_interface_network_id = "net-COMMON_GLOBAL"
  }

  dnat {
    rule_number                    = "1"
    description                    = "router_nat_dnat"
    protocol                       = "ALL"
    translation_address            = "192.0.2.2"
    inbound_interface_network_id = "net-COMMON_GLOBAL"
  }
}