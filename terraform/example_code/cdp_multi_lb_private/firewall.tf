# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "lan02srvfw" {
  # Firewall Group Name
  group_name        = "lan02srvfw"
  # Create Zone
  availability_zone = "east-14"

}
resource "nifcloud_security_group" "rtfw" {
  # Firewall Group Name
  group_name        = "rtfw"
  # Create Zone
  availability_zone = "east-14"

}
#------------- firewall rule -------------------------
#  LAN02-Server ELB Permit Rule
resource "nifcloud_security_group_rule" "lan02-elb-allow" {
  security_group_names = [nifcloud_security_group.lan02srvfw.group_name]
  type                 = "IN"
  from_port            = 80
  protocol             = "TCP"
  cidr_ip             = tostring(tolist(nifcloud_elb.elb.network_interface)[0].ip_address)
  # Depends
  depends_on = [nifcloud_security_group.lan02srvfw]
}

#  LAN02-Server ELB_VIP HealthCheck Permit Rule
resource "nifcloud_security_group_rule" "lan02-elb-vip-allow" {
  security_group_names = [nifcloud_security_group.lan02srvfw.group_name]
  type                 = "IN"
  protocol             = "ICMP"
  cidr_ip             = tostring(tolist(nifcloud_elb.elb.network_interface)[0].ip_address)
  # Depends
  depends_on = [nifcloud_security_group.lan02srvfw]
}

#  LAN02-Server SystemIpAddress1 HealthCheck Permit Rule
resource "nifcloud_security_group_rule" "lan02-elb-sysadrip1-allow" {
  security_group_names = [nifcloud_security_group.lan02srvfw.group_name]
  type                 = "IN"
  protocol             = "ICMP"
  cidr_ip             = tostring(tolist(tolist(nifcloud_elb.elb.network_interface)[0].system_ip_addresses)[0].system_ip_address)
  # Depends
  depends_on = [nifcloud_security_group.lan02srvfw]
}

#  LAN02-Server SystemIpAddress2 HealthCheck Permit Rule
resource "nifcloud_security_group_rule" "lan02-elb-sysadrip2-allow" {
  security_group_names = [nifcloud_security_group.lan02srvfw.group_name]
  type                 = "IN"
  protocol             = "ICMP"
  cidr_ip             = tostring(tolist(tolist(nifcloud_elb.elb.network_interface)[0].system_ip_addresses)[1].system_ip_address)
  # Depends
  depends_on = [nifcloud_security_group.lan02srvfw]
}

#  LAN01 Permit Rule
resource "nifcloud_security_group_rule" "lan01-allow" {
  security_group_names = [nifcloud_security_group.rtfw.group_name]
  type                 = "IN"
  protocol             = "ANY"
  cidr_ip             = "192.0.1.0/24"
  # Depends
  depends_on = [nifcloud_security_group.rtfw]
}
#  LAN02 Permit Rule
resource "nifcloud_security_group_rule" "lan02-allow" {
  security_group_names = [nifcloud_security_group.rtfw.group_name]
  type                 = "IN"
  protocol             = "ANY"
  cidr_ip             = "192.0.2.0/24"
  # Depends
  depends_on = [nifcloud_security_group.rtfw]
}

