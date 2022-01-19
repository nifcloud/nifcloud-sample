resource "nifcloud_vpn_gateway" "w21vpngw" {
  provider = nifcloud.west2
  # Base Document https://pfs.nifcloud.com/api/rest/CreateVpnGateway.htm
  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type   = "2"
  # VPN GW Name
  name              = "w21vpngw"
  # memo
  description       = "vpn gateway"
  # GW Size.small,medium,large
  # See NiftyVpnGatewayType
  type              = "small"
  # Create zone
  availability_zone = "jp-west-21"
  # Connect Private LAN
  network_name      = nifcloud_private_lan.W21VPNPri01.private_lan_name
  # Private LAN side IP
  ip_address        = "203.0.113.254"
  # Firewall Group
  security_group    = nifcloud_security_group.w21vpnfw.group_name
  # Routing Table
  route_table_id    = nifcloud_route_table.w21rutetable.route_table_id
}

resource "nifcloud_route_table" "w21rutetable" {
  provider = nifcloud.west2
  route {
    cidr_block = "10.0.10.0/24"
    ip_address = "192.0.2.1"
  }
}

