# Private LAN sample config
resource "nifcloud_private_lan" "Private01" {
  # Private LAN name
  private_lan_name  = "Private01"
  # memo
  description       = "ap db network"
  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type   = "2"
  # Create zone
  availability_zone = "jp-east-41"
  # ip range in the private lan use
  cidr_block        = "198.51.100.0/24"
}
