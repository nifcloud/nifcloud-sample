# Server Instance Config server
resource "nifcloud_instance" "eastsrv" {
  provider = nifcloud.east1

  instance_id       = "eastsrv"
  availability_zone = "east-13"
  # Pre-installed OS
  # Show file east-os_image.tf
  image_id = data.nifcloud_image.east-rockylinux.id
  # SSH Key File
  # Show file east-keymake.tf
  key_name = nifcloud_key_pair.eastcrossregion.key_name
  # Firewall Group
  # show file east-13-firewall.tf
  security_group = nifcloud_security_group.eastsrvfw.group_name
  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "CDP Cross Region Pattern"

  # Network Interface
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.EastPrivateLan.id
    ip_address = "static"
  }
  user_data = data.template_file.srv_private_ip.rendered
}
data "template_file" "srv_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.11/24" ## Edit to the IP address for the server
  }
}
