# Private LAN sample config
resource "nifcloud_private_lan" "PrivateLan01" {

  # Private LAN name
  private_lan_name  = "PrivateLan01"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type   = "2"

  # Create zone
  availability_zone = "east-14"

  # ip range in the private lan use
  cidr_block        = "192.0.2.0/24"

  # memo
  description       = "CDP FireWall Pattern"
}