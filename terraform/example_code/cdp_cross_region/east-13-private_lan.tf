resource "nifcloud_private_lan" "EastPrivateLan" {
  provider = nifcloud.east1

  # Private LAN name
  private_lan_name  = "EastPrivateLan"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type   = "2"

  # Create zone
  availability_zone = "east-13"

  # ip range in the private lan use
  cidr_block        = "192.0.2.0/24"

   # memo
  description       = "CDP Cross Region Pattern"
}
