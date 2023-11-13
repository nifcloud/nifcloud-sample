resource "nifcloud_nat_table" "nat" {
  dnat {
    rule_number                    = "1"
    description                    = "multi_layer_dnat"
    protocol                       = "ALL"
    translation_address            = "198.51.100.100"
    inbound_interface_network_name = nifcloud_private_lan.PrivateLan01.private_lan_name
  }
}
