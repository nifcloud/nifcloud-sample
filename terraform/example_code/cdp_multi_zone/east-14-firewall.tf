# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "websrv2fw" {
  # Firewall Group Name
  group_name        = "websrv2fw"
  # Create Zone
  availability_zone = "east-14"

}

resource "nifcloud_security_group" "dbsrv2fw" {
  # Firewall Group Name
  group_name        = "dbsrv2fw"
  # Create Zone
  availability_zone = "east-14"

}

#------------- firewall rule -------------------------
#  WebSrv2 Permit Rule
resource "nifcloud_security_group_rule" "websrv2-ssh" {
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.websrv2fw.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. parameter range 0 - 65535
  from_port            = 22
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "xxx.xxx.xxx.xxx" ## Edit to the access source IP address that is accessed by SSH.
  # memo
  description       = "CDP Multi Zone Pattern Web ssh rule"
}

#  DBSrv2 Permit Rule
resource "nifcloud_security_group_rule" "dbsrv2-allow" {
  security_group_names = [nifcloud_security_group.dbsrv2fw.group_name]
  type                 = "IN"
  protocol             = "ANY"
  # Permission Source security group
  source_security_group_name = nifcloud_security_group.websrv2fw.group_name
  # memo
  description       = "CDP Multi Zone Pattern DB rule"
}
