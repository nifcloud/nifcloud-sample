# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "websrv1fw" {
  # Firewall Group Name
  group_name        = "websrv1fw"
  # Create Zone
  availability_zone = "east-13"

}

resource "nifcloud_security_group" "dbsrv1fw" {
  # Firewall Group Name
  group_name        = "dbsrv1fw"
  # Create Zone
  availability_zone = "east-13"

}

#------------- firewall rule -------------------------
#  WebSrv1 Permit Rule
resource "nifcloud_security_group_rule" "websrv1-ssh" {
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.websrv1fw.group_name]
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

#  DBSrv1 Permit Rule
resource "nifcloud_security_group_rule" "dbsrv1-allow" {
  security_group_names = [nifcloud_security_group.dbsrv1fw.group_name]
  type                 = "IN"
  protocol             = "ANY"
  # Permission Source security group
  source_security_group_name = nifcloud_security_group.websrv1fw.group_name
  # memo
  description       = "CDP Multi Zone Pattern DB rule"
}
