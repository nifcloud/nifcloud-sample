#------------- vpn gw security group --------------------
resource "nifcloud_security_group" "e14vpnfw" {
  provider = nifcloud.east1
  # Firewall Group Name
  group_name = "e14vpnfw"
  # Create Zone
  availability_zone = "east-14"
}


#------------- firewall fule -------------------------

resource "nifcloud_security_group_rule" "accept_west_vpn" {
  provider = nifcloud.east1
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.e14vpnfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type = "IN"
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol = "ANY"
  # Permission Source IP
  cidr_ip = nifcloud_vpn_gateway.w12vpngw.public_ip_address
  lifecycle {
    create_before_destroy = true
  }
}


#------------- server security group --------------------
resource "nifcloud_security_group" "e14srv" {
  provider = nifcloud.east1
  # Firewall Group Name
  group_name = "e14sv"
  # Create Zone
  availability_zone = "east-14"
}


#------------- firewall fule -------------------------

resource "nifcloud_security_group_rule" "accept_https_e14" {
  provider = nifcloud.east1
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.e14srv.group_name]
  # Rule Type
  # can be set IN or OUT
  type = "IN"
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol = "ICMP"
  ## Port Number
  #to_port = "443"
  # Permission Source IP
  cidr_ip = "198.51.100.150"
  lifecycle {
    create_before_destroy = true
  }
}
