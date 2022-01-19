#------------- security group --------------------
resource "nifcloud_security_group" "w21vpnfw" {
  provider = nifcloud.west2
  group_name        = "w21vpnfw"
  availability_zone = "jp-west-21"
}

#------------- firewall fule -------------------------

resource "nifcloud_security_group_rule" "accept_east_vpn_in_w21" {
  provider = nifcloud.west2
  # Target Firewall Group Nmae
  security_group_names = [nifcloud_security_group.w21vpnfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type = "IN"
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol = "ANY"
  # Permission Source IP
  cidr_ip = nifcloud_vpn_gateway.e13vpngw.public_ip_address
}

