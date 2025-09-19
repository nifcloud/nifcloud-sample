# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "ssfw" {
  # Firewall Group Name
  group_name        = "ssfw"
  # Create Zone
  availability_zone = "east-14"

}



#------------- firewall rule -------------------------

# SS Host Permit Rule
resource "nifcloud_security_group_rule" "ssh" {
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.ssfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. parameter range 0 - 65535
  from_port            = 22
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "xxx.xxx.xxx.xxx" ## Enter the access source IP address to access via SSH
  # Depends
  depends_on = [nifcloud_security_group.ssfw]
  # memo
  description       = "CDP Server Separate Pattern"
}

resource "nifcloud_security_group_rule" "http" {
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.ssfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. parameter range 0 - 65535
  from_port            = 80
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "xxx.xxx.xxx.xxx" ## Enter the access source IP address to access via SSH
  # Depends
  depends_on = [nifcloud_security_group.ssfw]
  # memo
  description       = "CDP Server Separate Pattern"
}

resource "nifcloud_security_group_rule" "https" {
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.ssfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. parameter range 0 - 65535
  from_port            = 443
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "xxx.xxx.xxx.xxx" ## Enter the access source IP address to access via SSH
  # Depends
  depends_on = [nifcloud_security_group.ssfw]
  # memo
  description       = "CDP Server Separate Pattern"
}
