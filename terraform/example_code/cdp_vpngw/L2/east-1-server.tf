# Server Instance Config websrv
resource "nifcloud_instance" "e14srv" {
  instance_id       = "e14srv"
  availability_zone = "east-14"

  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.e1key.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.e14srv.group_name

  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "CDP VPN GW Pattern on East-1"

  # Network Interface
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.E14VPNPri01.id
    ip_address = "static"
  }
  user_data = data.template_file.e14srv_private_ip.rendered
}

# srv post-creation process
data "template_file" "e14srv_private_ip" {
  template = file("scripts/single_nic_setting.sh")

  vars = {
    private_address = "198.51.100.50/25"
  }
}
