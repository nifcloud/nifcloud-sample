# Private LAN sample config
resource "nifcloud_private_lan" "W12VPNPri01" {
  provider = nifcloud.west1
  # Private LAN name
  private_lan_name = "W12VPNPri01"
  # memo
  description = "vpn network"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"
  # Create zone
  availability_zone = "west-12"
  # ip range in the private lan use
  cidr_block = "198.51.100.0/24"
}
