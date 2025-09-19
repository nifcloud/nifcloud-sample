resource "nifcloud_vpn_gateway" "e14vpngw" {
  provider = nifcloud.east1
  # Base Document https://docs.nifcloud.com/cp/api/CreateVpnGateway.htm
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type   = "2"
  # VPN GW Name
  name              = "e14vpngw"
  # memo
  description       = "CDP VPN GW Pattern on East-1"
  # GW Size.small,medium,large
  # See NiftyVpnGatewayType
  type              = "small"
  # Create zone
  availability_zone = "east-14"
  # Connect Private LAN
  network_name      = nifcloud_private_lan.E14VPNPri01.private_lan_name
  # Private LAN side IP
  ip_address        = var.e13_vpn_gateway_ip
  # Firewall Group
  security_group    = nifcloud_security_group.e14vpnfw.group_name
  # Routing Table
  route_table_id    = nifcloud_route_table.e14vpn.route_table_id
}

resource "nifcloud_route_table" "e14vpn" {
  provider = nifcloud.east1
  route {
    cidr_block = "198.51.100.0/24"
    ip_address = var.w12_vpn_gateway_ip
  }
  lifecycle {
    create_before_destroy = true
  }
}

