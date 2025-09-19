#------------- security group --------------------
resource "nifcloud_security_group" "w12vpnfw" {
  provider = nifcloud.west1
  group_name        = "w12vpnfw"
  availability_zone = "west-12"
}

#------------- firewall fule -------------------------

resource "nifcloud_security_group_rule" "accept_east_vpn" {
  provider = nifcloud.west1
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.w12vpnfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type = "IN"
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol = "ANY"
  # Permission Source IP
  cidr_ip = nifcloud_vpn_gateway.e13vpngw.public_ip_address
}

