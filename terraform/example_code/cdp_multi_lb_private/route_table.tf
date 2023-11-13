resource "nifcloud_route_table" "route_table" {
  # Route Table
  route {
    # PrivateLan01 CIDR
    cidr_block = nifcloud_private_lan.PrivateLan01.cidr_block

    # Router Ip_Address network_interface2
    ip_address = tolist(nifcloud_router.rt.network_interface)[1].ip_address
  }
}

