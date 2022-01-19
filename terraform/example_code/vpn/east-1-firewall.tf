#------------- security group --------------------
resource "nifcloud_security_group" "e13vpnfw" {
  provider = nifcloud.east1
  # Firewall Group Name
  group_name = "e13vpnfw"
  # Create Zone
  availability_zone = "east-13"
}


#------------- firewall fule -------------------------

resource "nifcloud_security_group_rule" "accept_west_vpn" {
  provider = nifcloud.east1
  # Target Firewall Group Nmae
  security_group_names = [nifcloud_security_group.e13vpnfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type = "IN"
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol = "ANY"
  # Permission Source IP
  cidr_ip = nifcloud_vpn_gateway.w12vpngw.public_ip_address
}

resource "nifcloud_security_group_rule" "accept_west21_vpn" {
  provider = nifcloud.east1
  # Target Firewall Group Nmae
  security_group_names = [nifcloud_security_group.e13vpnfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type = "IN"
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol = "ANY"
  # Permission Source IP
  cidr_ip = nifcloud_vpn_gateway.w21vpngw.public_ip_address
}

