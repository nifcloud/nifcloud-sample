# Server Instance Config srv
resource "nifcloud_instance" "srv1" {
  instance_id       = "srv1"
  availability_zone = "east-14"

  # Pri-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.cdpmlbprivate.key_name

  # Firewall Group
  # show file firewall.tf
 # security_group = nifcloud_security_group.lan01fw.group_name

  # Server size.
  # https://pfs.nifcloud.com/api/rest/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type = "2"

  # memo
  description       = "cdp_multi_lb_private"

  # Network Interface
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
    private_address = "192.0.1.1/24"
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
  key_name = nifcloud_key_pair.cdpmlbprivate.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.lan02srvfw.group_name

  # Server size.
  # https://pfs.nifcloud.com/api/rest/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type = "2"

  # memo
  description       = "cdp_multi_lb_private"

  # Network Interface
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan02.id
    ip_address = "static"
  }
  user_data = data.template_file.srv2_private_ip.rendered
}
data "template_file" "srv2_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.1/24"
  }
}
resource "nifcloud_instance" "srv3" {
  instance_id       = "srv3"
  availability_zone = "east-14"

  # Pri-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.cdpmlbprivate.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.lan02srvfw.group_name

  # Server size.
  # https://pfs.nifcloud.com/api/rest/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type = "2"

  # memo
  description       = "cdp_multi_lb_private"

  # Network Interface
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan02.id
    ip_address = "static"
  }
  user_data = data.template_file.srv3_private_ip.rendered
}
data "template_file" "srv3_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.2/24"
  }
}
