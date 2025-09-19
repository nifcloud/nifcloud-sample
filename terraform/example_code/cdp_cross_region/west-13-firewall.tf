# Security Group sample config
#------------- security group --------------------
resource "nifcloud_security_group" "westbackupsrvfw" {
  provider = nifcloud.west1

  # Firewall Group Name
  group_name        = "westbackupsrvfw"
  # Create Zone
  availability_zone = "west-13"
}

resource "nifcloud_security_group" "westdbsrvfw" {
  provider = nifcloud.west1

  # Firewall Group Name
  group_name        = "westdbsrvfw"
  # Create Zone
  availability_zone = "west-13"
}

#------------- firewall rule -------------------------
#  westbackupsrv Permit Rule
resource "nifcloud_security_group_rule" "westbackupsrv-allow" {
  provider = nifcloud.west1

  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.westbackupsrvfw.group_name]
  type                 = "IN"
  protocol             = "ANY"

  # Permission cidr block
  cidr_ip = nifcloud_private_lan.WestPrivateLan.cidr_block

  # memo
  description       = "CDP Cross Region Pattern backupsrv rule"
}

#  westdbsrv Permit Rule
resource "nifcloud_security_group_rule" "westdbsrv-allow" {
  provider = nifcloud.west1

  # Target Firewall Group Name
  security_group_names = [nifcloud_security_group.westdbsrvfw.group_name]
  type                 = "IN"
  protocol             = "ANY"

  # Permission cidr block
  cidr_ip = nifcloud_private_lan.WestPrivateLan.cidr_block

  # memo
  description       = "CDP Cross Region Pattern dbsrv rule"
}
