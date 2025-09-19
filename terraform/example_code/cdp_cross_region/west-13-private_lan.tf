resource "nifcloud_private_lan" "WestPrivateLan" {
  provider = nifcloud.west1

  # Private LAN name
  private_lan_name  = "WestPrivateLan"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type   = "2"

  # Create zone
  availability_zone = "west-13"

  # ip range in the private lan use
  cidr_block        = "192.0.2.0/24"

   # memo
  description       = "CDP Cross Region Pattern"
}
