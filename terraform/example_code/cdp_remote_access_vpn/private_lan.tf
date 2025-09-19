resource "nifcloud_private_lan" "PrivateLan01" {

  # private_lan document
  # https://docs.nifcloud.com/network/spec/plan/index.htm
  # https://docs.nifcloud.com/cp/api/NiftyCreatePrivateLan.htm

  # Private LAN name
  private_lan_name  = "PrivateLan01"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type   = "2"

  # Create zone
  availability_zone = "jp-west-21"

  # ip range in the private lan use
  cidr_block        = "192.0.2.0/24"

  # memo
  description       = "CDP Remote Access VPN Pattern"
}
