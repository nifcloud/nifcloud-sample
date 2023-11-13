# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "websrvfw" {
  # Firewall Group Name
  group_name        = "websrvfw"
  # Create Zone
  availability_zone = "east-14"

}
resource "nifcloud_security_group" "appsrvfw" {
  # Firewall Group Name
  group_name        = "appsrvfw"
  # Create Zone
  availability_zone = "east-14"

}
resource "nifcloud_security_group" "dbsrvfw" {
  # Firewall Group Name
  group_name        = "dbsrvfw"
  # Create Zone
  availability_zone = "east-14"

}
#------------- firewall rule -------------------------

#  WebSrv Permit Rule
resource "nifcloud_security_group_rule" "ssh" {
  # Target Firewall Group Nmae
  security_group_names = [nifcloud_security_group.websrvfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. paramete range 0 - 65535
  from_port            = 22
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "xxx.xxx.xxx.xxx" ## Enter the access source IP address to access via ssh
  # Depends
  depends_on = [nifcloud_security_group.websrvfw]
  # memo
  description       = "Web Server ssh rule"
}
resource "nifcloud_security_group_rule" "http" {
  # Target Firewall Group Nmae
  security_group_names = [nifcloud_security_group.websrvfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. paramete range 0 - 65535
  from_port            = 80
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "xxx.xxx.xxx.xxx" ## Enter the access source IP address to access via http
  # Depends
  depends_on = [nifcloud_security_group.websrvfw]
  # memo
  description       = "Web Server http rule"
}
resource "nifcloud_security_group_rule" "https" {
  # Target Firewall Group Nmae
  security_group_names = [nifcloud_security_group.websrvfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. paramete range 0 - 65535
  from_port            = 443
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "xxx.xxx.xxx.xxx" ## Enter the access source IP address to access via https
  # Depends
  depends_on = [nifcloud_security_group.websrvfw]

  # memo
  description       = "Web Server https rule"
}

#  AppSrv Permit Rule
resource "nifcloud_security_group_rule" "app-allow" {
  security_group_names = [nifcloud_security_group.appsrvfw.group_name]
  type                 = "IN"
  protocol             = "ANY"
  # permit communication Firewall Group websrvfw
  source_security_group_name = nifcloud_security_group.websrvfw.group_name
  # Depends
  depends_on = [nifcloud_security_group.websrvfw,nifcloud_security_group.appsrvfw]

}

#  DBSrv Permit Rule
resource "nifcloud_security_group_rule" "db-allow" {
  security_group_names = [nifcloud_security_group.dbsrvfw.group_name]
  type                 = "IN"
  protocol             = "ANY"
  # permit communication Firewall Group appsrvfw
  source_security_group_name = nifcloud_security_group.appsrvfw.group_name
  # Depends
  depends_on = [nifcloud_security_group.appsrvfw,nifcloud_security_group.dbsrvfw]
}