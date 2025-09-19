# Server Instance Config srv
# DiskAdd
resource "nifcloud_volume" "disk" {
  size            = 100
  volume_id       = "volume001"
  disk_type       = "High-Speed Storage A"
  instance_id     = nifcloud_instance.srv.instance_id # Comment out this line to detach the disk.
  reboot          = "true"
  accounting_type = "2"
  description     = "memo"
}

resource "nifcloud_instance" "srv" {
  instance_id       = "srv"
  availability_zone = "east-14"
  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.disk.key_name
  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.srvfw.group_name
  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "CDP Disk Attach Pattern"

  # Network Interface
  # this sample is set common global and elastic ip
  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan01.id
    network_name = nifcloud_private_lan.PrivateLan01.private_lan_name
    ip_address = "static"
  }
  user_data = data.template_file.srv_private_ip.rendered
}
data "template_file" "srv_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.1/24"
  }
}

