# Security Group sample config
#------------- security group --------------------
# https://docs.nifcloud.com/cp/api/CreateSecurityGroup.htm

resource "nifcloud_security_group" "srvfw1" {
  # Firewall Group Name
  group_name        = "srvfw1"
  # Create Zone
  availability_zone = "jp-west-21"
}

resource "nifcloud_security_group" "srvfw2" {
  # Firewall Group Name
  group_name        = "srvfw2"
  # Create Zone
  availability_zone = "jp-west-21"
}

#------------- firewall rule -------------------------
# https://docs.nifcloud.com/cp/api/AuthorizeSecurityGroupIngress.htm
# 

resource "nifcloud_security_group_rule" "ssh1" {
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.srvfw1.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. parameter range 0 - 65535
  from_port            = 22
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "192.0.2.10" ## Enter the access source IP address to access via ssh
  # Depends
  depends_on = [nifcloud_security_group.srvfw1]
  # memo
  description       = "CDP Remote Access VPN Pattern Server"
}

resource "nifcloud_security_group_rule" "ssh2" {
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.srvfw2.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. parameter range 0 - 65535
  from_port            = 22
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "192.0.2.10" ## Enter the access source IP address to access via ssh
  # Depends
  depends_on = [nifcloud_security_group.srvfw2]
  # memo
  description       = "CDP Remote Access VPN Pattern Server"
}
