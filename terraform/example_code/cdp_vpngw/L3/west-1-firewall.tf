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
  cidr_ip = nifcloud_vpn_gateway.e14vpngw.public_ip_address
  lifecycle {
    create_before_destroy = true
  }
}

#------------- server security group --------------------
resource "nifcloud_security_group" "w12srv" {
  provider = nifcloud.west1
  # Firewall Group Name
  group_name = "w12srv"
  # Create Zone
  availability_zone = "west-12"
}


#------------- firewall fule -------------------------

resource "nifcloud_security_group_rule" "accept_https_w12" {
  provider = nifcloud.west1
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.w12srv.group_name]
  # Rule Type
  # can be set IN or OUT
  type = "IN"
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol = "ICMP"
  ## Port Number
  #to_port = "443"
  # Permission Source IP
  cidr_ip = "192.0.2.100"
  lifecycle {
    create_before_destroy = true
  }
}
