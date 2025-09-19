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
  # Firewall Group
  security_group    = nifcloud_security_group.w12vpnfw.group_name
}
