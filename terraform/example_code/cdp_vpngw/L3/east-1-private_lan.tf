# Private LAN sample config
resource "nifcloud_private_lan" "E14VPNPri01" {
  provider = nifcloud.east1
  # Private LAN name
  private_lan_name = "E14VPNPri01"
  # memo
  description = "CDP VPN GW Pattern on East-1"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"
  # Create zone
  availability_zone = "east-14"
  # ip range in the private lan use
  cidr_block = "192.0.2.0/24"
}
