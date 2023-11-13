# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "srvfw" {
  # Firewall Group Name
  group_name        = "srvfw"
  # Create Zone
  availability_zone = "east-14"

}


#------------- firewall rule -------------------------

# Single Host Permit Rule
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
  cidr_ip              = "xxx.xxx.xxx.xxx" ## Enter the access source IP address to access via SSH
  # Depends
  depends_on = [nifcloud_security_group.srvfw]
  # memo
  description       = "CDP SorryPage Pattern 2"
}

#  ELB Permit Rule
resource "nifcloud_security_group_rule" "elb-allow" {
  security_group_names = [nifcloud_security_group.srvfw.group_name]
  type                 = "IN"
  from_port            = 80
  protocol             = "TCP"
  cidr_ip             =  nifcloud_elb.elb.dns_name
  # memo
  description       = "CDP SorryPage Pattern 2"
  # Depends
  depends_on = [nifcloud_security_group.srvfw]
}

#  ELB_VIP HealthCheck Permit Rule
resource "nifcloud_security_group_rule" "elb-vip-allow" {
  security_group_names = [nifcloud_security_group.srvfw.group_name]
  type                 = "IN"
  protocol             = "ICMP"
  cidr_ip             =  nifcloud_elb.elb.dns_name
  # memo
  description       = "CDP SorryPage Pattern 2"
  # Depends
  depends_on = [nifcloud_security_group.srvfw]
}  
