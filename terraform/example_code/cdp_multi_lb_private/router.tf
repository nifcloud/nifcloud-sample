# Router Config sample
# This Router is enable WebProxy
resource "nifcloud_router" "rt" {
  # Router Name
  name              = "rt"
  # memo
  description       = "cdp_multi_lb_private"
  # Create zone
  availability_zone = "east-14"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type   = "2"
  # Router Size
  # small :~10 route per route table
  # medium:~30 route per route table
  # large :~80 route per route table
  type              = "small"
  # Firewall Group
  security_group = nifcloud_security_group.rtfw.group_name

  # this sample is set private lan
  # network_interface1
  network_interface {
    # Connect Network
    network_id = nifcloud_private_lan.PrivateLan01.id
    # Router Private IP
    ip_address      = "192.0.1.2"
    # DHCP enable on this private lan
    dhcp            = "false"
  }
  # network_interface2
  network_interface {
    # Connect Network
    network_id = nifcloud_private_lan.PrivateLan02.id
    # Router Private IP
    ip_address      = "192.0.2.3"
    # DHCP enable on this private lan
    dhcp            = "false"
  }
}

