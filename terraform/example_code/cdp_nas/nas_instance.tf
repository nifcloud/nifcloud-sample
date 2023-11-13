resource "nifcloud_nas_instance" "nas" {
  identifier              = "nas"
  availability_zone       = "east-14"
  allocated_storage       = 100
  protocol                = "nfs"
  type                    = 0
  nas_security_group_name = nifcloud_nas_security_group.nasgr.group_name
  network_id              = nifcloud_private_lan.PrivateLan01.id
  private_ip_address      = "192.0.2.200"
  private_ip_address_subnet_mask = "/24"
}
