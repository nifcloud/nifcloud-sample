# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "eastsrvfw" {
  provider = nifcloud.east1

  # Firewall Group Name
  group_name        = "eastsrvfw"
  # Create Zone
  availability_zone = "east-13"
}

#------------- firewall rule -------------------------
#  eastsrv Permit Rule
resource "nifcloud_security_group_rule" "eastsrv-allow" {
  provider = nifcloud.east1

  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.eastsrvfw.group_name]
  type                 = "IN"
  protocol             = "ANY"

  # Permission cidr block
  cidr_ip = nifcloud_private_lan.EastPrivateLan.cidr_block

  # memo
  description       = "CDP Cross Region Pattern srv rule"
}
