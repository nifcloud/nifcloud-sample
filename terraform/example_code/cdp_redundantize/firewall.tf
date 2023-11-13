# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "srvfw" {
  # Firewall Group Name
  group_name        = "srvfw"
  # Create Zone
  availability_zone = "east-14"

}
#------------- firewall rule -------------------------

#  WebSrv Permit Rule
resource "nifcloud_security_group_rule" "ssh" {
  # Target Firewall Group Nmae
  security_group_names = [nifcloud_security_group.srvfw.group_name]
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
  depends_on = [nifcloud_security_group.srvfw]
  # memo
  description       = "Server ssh rule"
}



