resource "nifcloud_dhcp_config" "this" {
  ipaddress_pool {
    ipaddress_pool_start = var.dhcp_config_ipaddress_pool_start
    ipaddress_pool_stop = var.dhcp_config_ipaddress_pool_stop
  }
}

resource "nifcloud_security_group" "this" {
  group_name = var.security_group_name_for_router
  availability_zone = var.zone
}

resource "nifcloud_router" "this" {
  name = var.router_name
  availability_zone = var.zone
  security_group = nifcloud_security_group.this.group_name
  accounting_type = var.router_accounting_type
  type = var.router_type

  network_interface {
    network_name = nifcloud_private_lan.this.private_lan_name
    ip_address = var.router_ip_address
    dhcp = true
    dhcp_config_id = nifcloud_dhcp_config.this.id
  }
}
