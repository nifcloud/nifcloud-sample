# Server Instance Config srv
resource "nifcloud_instance" "srv1" {
  instance_id       = "srv1"
  availability_zone = "east-14"

  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.redundantize.key_name

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
  description       = "redundantize"

  # Network Interface
  # this sample is set common global and elastic ip
  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan01.id
    ip_address = "static"
  }
  user_data = data.template_file.srv1_private_ip.rendered
}
data "template_file" "srv1_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.1/24"
  }
}

resource "nifcloud_instance" "srv2" {
  instance_id       = "srv2"
  availability_zone = "east-14"
  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.redundantize.key_name
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
  description       = "redundantize"
  
  # this sample is set common global and elastic ip
  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan01.id
    ip_address = "static"
  }
  user_data = data.template_file.srv2_private_ip.rendered
}

data "template_file" "srv2_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.2/24"
  }
}

# Server Instance Config srv
# DiskAdd
resource "nifcloud_volume" "srv1disk" {
  size            = 100
  volume_id       = "volume001"
  disk_type       = "High-Speed Storage A"
  instance_id     = nifcloud_instance.srv1.instance_id
  reboot          = "true"
  accounting_type = "2"
  description     = "redundantize"
}

resource "nifcloud_volume" "srv2disk" {
  size            = 100
  volume_id       = "volume002"
  disk_type       = "High-Speed Storage B"
  instance_id     = nifcloud_instance.srv2.instance_id
  reboot          = "true"
  accounting_type = "2"
  description     = "redundantize"
}