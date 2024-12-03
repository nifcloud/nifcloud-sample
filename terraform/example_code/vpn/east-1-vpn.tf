resource "nifcloud_vpn_gateway" "e13vpngw" {
  provider = nifcloud.east1
  # Base Document https://docs.nifcloud.com/cp/api/CreateVpnGateway.htm
  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type   = "2"
  # VPN GW Name
  name              = "e13vpngw"
  # memo
  description       = "vpn gateway"
  # GW Size.small,medium,large
  # See NiftyVpnGatewayType
  type              = "small"
  # Create zone
  availability_zone = "east-13"
  # Connect Private LAN
  network_name      = nifcloud_private_lan.E13VPNPri01.private_lan_name
  # Private LAN side IP
  ip_address        = "192.0.2.254"
  # Firewall Group
  security_group    = nifcloud_security_group.e13vpnfw.group_name
  # Routing Table
  route_table_id    = nifcloud_route_table.e13rutetable.route_table_id
}

resource "nifcloud_route_table" "e13rutetable" {
  provider = nifcloud.east1
  route {
    cidr_block = "10.0.0.0/24"
    ip_address = "192.0.2.1"
  }
}

