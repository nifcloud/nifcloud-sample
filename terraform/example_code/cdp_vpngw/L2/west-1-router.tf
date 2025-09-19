# Router Config sample
resource "nifcloud_router" "rt" {
  provider = nifcloud.west1
  # Router Name
  name              = "rt"
  # memo
  description       = "CDP VPN GW Pattern on West-1"
  # Create zone
  availability_zone = "west-12"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type   = "2"
  # Router Size
  # small :~10 route per route table
  # medium:~30 route per route table
  # large :~80 route per route table
  type              = "small"
  
  ## Network Interface
  network_interface {
    # Connect Network
    network_name    = nifcloud_private_lan.W12VPNPri01.private_lan_name
    # Router Private IP
    ip_address      = var.w12_route_ip_vpn_nw
    # DHCP enable on this private lan
    dhcp            = "false"
  }

  network_interface {
    network_name    = nifcloud_private_lan.W12SVPri01.private_lan_name
    ip_address      = var.w12_route_ip_srv_nw
    dhcp            = "false"
  }

}
