# Server Instance Config websrv
resource "nifcloud_instance" "srv1" {
  instance_id       = "srv1"
  availability_zone = "east-14"

  # Pri-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.casesorrypage.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.srvfw.group_name

  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type = "2"

  # memo
  description       = "CDP SorryPage Pattern 2"

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
  user_data = data.template_file.srv_private_ip1.rendered
}
data "template_file" "srv_private_ip1" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.1/24"
  }
}

resource "nifcloud_instance" "srv2" {
  instance_id       = "srv2"
  availability_zone = "east-14"

  # Pri-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.casesorrypage.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.srvfw.group_name

  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type = "2"

  # memo
  description       = "CDP SorryPage Pattern 2"

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
  user_data = data.template_file.srv_private_ip2.rendered
}
data "template_file" "srv_private_ip2" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.2/24"
  }
}
