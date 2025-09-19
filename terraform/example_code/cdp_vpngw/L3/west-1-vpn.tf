resource "nifcloud_vpn_gateway" "w12vpngw" {
  provider = nifcloud.west1
  # Base Document https://docs.nifcloud.com/cp/api/CreateVpnGateway.htm
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type   = "2"
  # VPN GW Name
  name              = "w12vpngw"
  # memo
  description       = "CDP VPN GW Pattern on West-1"
  # GW Size.small,medium,large
  # See NiftyVpnGatewayType
  type              = "small"
  # Create zone
  availability_zone = "west-12"
  # Connect Private LAN
  network_name      = nifcloud_private_lan.W12VPNPri01.private_lan_name
  # Private LAN side IP
  ip_address        = var.w12_vpn_gateway_ip
  # Firewall Group
  security_group    = nifcloud_security_group.w12vpnfw.group_name
  # Routing Table
  route_table_id    = nifcloud_route_table.w12vpn.route_table_id
}

resource "nifcloud_route_table" "w12vpn" {
  provider = nifcloud.west1
  route {
    cidr_block = nifcloud_private_lan.E14VPNPri01.cidr_block
    ip_address = var.e13_vpn_gateway_ip
    
  }
  route {
    cidr_block = nifcloud_private_lan.W12SVPri01.cidr_block
    ip_address = var.w12_route_ip_vpn_nw
  }
  lifecycle {
    create_before_destroy = true
  }
}

