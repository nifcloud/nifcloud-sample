# Router Config sample
# This Router is enable NAT
resource "nifcloud_router" "rt" {
  # Router Name
  name              = "rt"
  # memo
  description       = "CDP Router NAT Pattern"
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
  security_group    = nifcloud_security_group.rtfw.group_name

  # Nat table
  nat_table_id = nifcloud_nat_table.nat.id
  
  ## Network Interface
  ## this sample is set common global
  network_interface {
  #  # Connect Network
  #  # net-COMMON_GLOBAL :Common Global
  #  # net-COMMON_PRIVATE:Common Private
  #  # NetworkID         :Network ID at Private LAN
    network_id = "net-COMMON_GLOBAL"
  }

  # this sample is set private lan
  network_interface {
    # Connect Network
    network_name    = nifcloud_private_lan.PrivateLan01.private_lan_name
    # Router Private IP
    ip_address      = "192.0.2.1"
    # DHCP enable on this private lan
    dhcp            = "false"
    # DHCP config(ip range to distribute)
    # dhcp_config_id  = nifcloud_dhcp_config.webdbnw.id
    # DHCP option(dns,default gw and more)
    # dhcp_options_id = nifcloud_dhcp_option.webdbnw.id
  }

}
