# Private LAN sample config
resource "nifcloud_private_lan" "E13VPNPri01" {
  provider = nifcloud.east1
  # Private LAN name
  private_lan_name = "E13VPNPri01"
  # memo
  description = "vpn network"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"
  # Create zone
  availability_zone = "east-13"
  # ip range in the private lan use
  cidr_block = "192.0.2.0/24"
}
