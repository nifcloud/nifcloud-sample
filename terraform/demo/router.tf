resource "nifcloud_router" "demo" {
  name           = "demo"
  security_group = nifcloud_security_group.demo.id

  network_interface {
    network_id = nifcloud_private_lan.demo.id
    dhcp       = true
  }
}
