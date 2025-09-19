# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "rtfw" {
  # Firewall Group Name
  group_name        = "rtfw"
  # Create Zone
  availability_zone = "east-14"

}
resource "nifcloud_security_group" "srvfw" {
  # Firewall Group Name
  group_name        = "srvfw"
  # Create Zone
  availability_zone = "east-14"

}


#------------- firewall rule -------------------------

# Single Host Permit Rule
resource "nifcloud_security_group_rule" "ssh" {
  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.srvfw.group_name]
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
  depends_on = [nifcloud_security_group.srvfw]
  # memo
  description       = "ssh"
}

# Single Host Permit Rule
resource "nifcloud_security_group_rule" "srv-allow" {
  security_group_names = [nifcloud_security_group.rtfw.group_name]
  type                 = "IN"
  protocol             = "ANY"
  # Permission srv IP
  cidr_ip              = "192.0.2.0/24"
  # Depends
  depends_on = [nifcloud_security_group.rtfw]
}
