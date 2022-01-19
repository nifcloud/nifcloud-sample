# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "webfw" {
  # Firewall Group Name
  group_name        = "webfw"
  # Create Zone
  availability_zone = "jp-east-41"
}

resource "nifcloud_security_group" "privatefw" {
  group_name        = "privatefw"
  availability_zone = "jp-east-41"
}

#------------- webfw firewall fule -------------------------

# Single Host Permit Rule
resource "nifcloud_security_group_rule" "ssh" {
  # Target Firewall Group Nmae
  security_group_names = [nifcloud_security_group.webfw.group_name]
  # Rule Type
  # can be set IN or OUT
  type                 = "IN"
  # Range start of Accept Port. paramete range 0 - 65535
  from_port            = 22
  # Port. paramete range 0 - 65535
  to_port              = 22
  # Protocol Type.
  # Parameter is "ANY","TCP","UDP","ICMP","GRE","ESP","AH","VRRP","ICMPv6-all"
  protocol             = "TCP"
  # Permission Source IP
  cidr_ip              = "203.0.113.1"
}

# IP Range Permit Rule
resource "nifcloud_security_group_rule" "web-classB" {
  security_group_names = [nifcloud_security_group.webfw.group_name]
  type                 = "IN"
  protocol             = "ANY"
  # Permission Source IP Range
  cidr_ip              = "198.51.100.0/24"
}

# Single Host Permit Rule by using Protocl
resource "nifcloud_security_group_rule" "web_access_allow" {
  security_group_names = [nifcloud_security_group.webfw.group_name]
  type                 = "IN"
  # When specified ICMP.ICMP Protocol is allow.
  protocol             = "ICMP"
  # Permission Source IP
  cidr_ip              = "203.0.113.2"
}

# Permit Rule by using Firewall Group
resource "nifcloud_security_group_rule" "privateallow" {
  security_group_names       = [nifcloud_security_group.webfw.group_name]
  type                       = "IN"
  # in ANY is any port permit
  protocol                   = "ANY"
  # permit communication Firewall Group
  source_security_group_name = nifcloud_security_group.privatefw.group_name
}

# Permit Rule from multi load barancer
resource "nifcloud_security_group_rule" "mlb" {
  security_group_names = [nifcloud_security_group.webfw.group_name]
  type                 = "IN"
  from_port            = 80
  to_port              = 80
  protocol             = "TCP"
  # Multi Loadbarancer IP
  cidr_ip              = nifcloud_elb.web001.dns_name
}


#------------- private fw rule ----------------------------

# Permit Rule by using Firewall Group
resource "nifcloud_security_group_rule" "weballow" {
  security_group_names       = [nifcloud_security_group.privatefw.group_name]
  source_security_group_name = nifcloud_security_group.webfw.group_name
  type                       = "IN"
  protocol                   = "ANY"
}

# IP Range Permit Rule
resource "nifcloud_security_group_rule" "private-classB" {
  security_group_names = [nifcloud_security_group.privatefw.group_name]
  type                 = "IN"
  protocol             = "ANY"
  cidr_ip              = "198.51.100.0/24"
}

