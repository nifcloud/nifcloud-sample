# Server Instance Config websrv
resource "nifcloud_instance" "w12srv" {
  provider = nifcloud.west1
  instance_id       = "w12srv"
  availability_zone = "west-12"

  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.w1key.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.w12srv.group_name

  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "CDP VPN GW Pattern on West-1"

  # Network Interface
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.W12SVPri01.id
    ip_address = "static"
  }
  user_data = data.template_file.jpw12srv_private_ip.rendered
}

# websrv post-creation process
data "template_file" "jpw12srv_private_ip" {
  template = file("scripts/single_nic_setting.sh")

  vars = {
    private_address = "198.51.100.150/25"
  }
}
