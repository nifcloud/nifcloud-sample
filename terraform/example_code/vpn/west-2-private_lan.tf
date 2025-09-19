# Private LAN sample config
resource "nifcloud_private_lan" "W21VPNPri01" {
  provider = nifcloud.west2
  # Private LAN name
  private_lan_name = "W21VPNPri01"
  # memo
  description = "vpn network"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"
  # Create zone
  availability_zone = "jp-west-21"
  # ip range in the private lan use
  cidr_block = "203.0.113.0/24"
}
