# Server Instance Config websrv
resource "nifcloud_instance" "websrv" {
  instance_id       = "websrv"
  availability_zone = "east-14"

  # Pri-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.casecdpfw.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.websrvfw.group_name

  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type = "2"

  # memo
  description       = "CDP FireWall Pattern"

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
  user_data = data.template_file.websrv_private_ip.rendered
}

# websrv post-creation process
data "template_file" "websrv_private_ip" {
  template = file("scripts/websrv_setting.sh")

  vars = {
    private_address = "192.0.2.1/24"
  }
}
# Server Instance Config appsrv
resource "nifcloud_instance" "appsrv" {
  instance_id       = "appsrv"
  availability_zone = "east-14"
  # Pri-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.casecdpfw.key_name
  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.appsrvfw.group_name
  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"
  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type = "2"

  # memo
  description       = "CDP FireWall Pattern"

  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan01.id
    ip_address = "static"
  }
  user_data = data.template_file.appsrv_private_ip.rendered
}

# appsrv post-creation process
data "template_file" "appsrv_private_ip" {
  template = file("scripts/appsrv_setting.sh")

  vars = {
    private_address = "192.0.2.2/24"
  }
}
# Server Instance Config dbsrv
resource "nifcloud_instance" "dbsrv" {
  instance_id       = "dbsrv"
  availability_zone = "east-14"
  # Pri-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.casecdpfw.key_name
  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.dbsrvfw.group_name
  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"
  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type = "2"

  # memo
  description       = "CDP FireWall Pattern"

  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan01.id
    ip_address = "static"
  }
  user_data = data.template_file.dbsrv_private_ip.rendered
}
# DiskAdd
resource "nifcloud_volume" "dbdisk" {
  size            = 100
  volume_id       = "volume001"
  disk_type       = "High-Speed Storage A"
  instance_id     = nifcloud_instance.dbsrv.instance_id
  reboot          = "true"
  accounting_type = "2"
  description     = "CDP FireWall Pattern"
}

# dbsrv post-creation process
data "template_file" "dbsrv_private_ip" {
  template = file("scripts/dbsrv_setting.sh")

  vars = {
    private_address = "192.0.2.3/24"
  }
}
