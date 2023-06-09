resource "nifcloud_instance" "demo" {
  count = 2

  instance_id    = "demo${count.index + 1}"
  instance_type  = "small"
  image_id       = data.nifcloud_image.ubuntu.id
  key_name       = nifcloud_key_pair.demo.id
  security_group = nifcloud_security_group.demo.id

  network_interface {
    network_id = nifcloud_private_lan.demo.id
  }

  depends_on = [nifcloud_router.demo]
}

data "nifcloud_image" "ubuntu" {
  image_name = "Ubuntu Server 22.04 LTS"
}
