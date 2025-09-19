# Server Instance Config websrv
resource "nifcloud_instance" "websrv" {
  instance_id       = "websrv"
  availability_zone = "east-14"

  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.multilayer.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.websrvfw.group_name

  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "multi_layer"

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
  user_data = data.template_file.websrv_private_ip.rendered
}
data "template_file" "websrv_private_ip" {
  template = file("scripts/websrv_setting.sh")

  vars = {
    private_address = "192.0.2.100/24"
  }
}

# Server Instance Config dbsrv
# DiskAdd
resource "nifcloud_volume" "dbdisk" {
  size            = 100
  volume_id       = "volume001"
  disk_type       = "High-Speed Storage A"
  instance_id     = nifcloud_instance.dbsrv.instance_id
  reboot          = "true"
  accounting_type = "2"
  description     = "multi_layer"
}

resource "nifcloud_instance" "dbsrv" {
  instance_id       = "dbsrv"
  availability_zone = "east-14"
  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.multilayer.key_name
  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.dbsrvfw.group_name
  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "multi_layer"

  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan02.id
    network_name = nifcloud_private_lan.PrivateLan02.private_lan_name
    ip_address = "static"
  }
  user_data = data.template_file.dbsrv_private_ip.rendered
}

data "template_file" "dbsrv_private_ip" {
  template = file("scripts/dbsrv_setting.sh")

  vars = {
    private_address = "198.51.100.100/24"
  }
}
