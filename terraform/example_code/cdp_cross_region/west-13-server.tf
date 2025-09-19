# Server Instance Config server
resource "nifcloud_instance" "westbackupsrv" {
  provider = nifcloud.west1

  instance_id       = "westbackupsrv"
  availability_zone = "west-13"
  # Pre-installed OS
  # Show file west-os_image.tf
  image_id = data.nifcloud_image.west-rockylinux.id
  # SSH Key File
  # Show file west-keymake.tf
  key_name = nifcloud_key_pair.westcrossregion.key_name
  # Firewall Group
  # show file west-13-firewall.tf
  security_group = nifcloud_security_group.westbackupsrvfw.group_name
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
    network_id = nifcloud_private_lan.WestPrivateLan.id
    ip_address = "static"
  }
  user_data = data.template_file.backupsrv_private_ip.rendered
}
data "template_file" "backupsrv_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.21/24" ## Edit to the IP address for the server
  }
}

resource "nifcloud_instance" "westdbsrv" {
  provider = nifcloud.west1

  instance_id       = "westdbsrv"
  availability_zone = "west-13"
  # Pre-installed OS
  # Show file west-os_image.tf
  image_id = data.nifcloud_image.west-rockylinux.id
  # SSH Key File
  # Show file west-keymake.tf
  key_name = nifcloud_key_pair.westcrossregion.key_name
  # Firewall Group
  # show file west-13-firewall.tf
  security_group = nifcloud_security_group.westdbsrvfw.group_name
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
    network_id = nifcloud_private_lan.WestPrivateLan.id
    ip_address = "static"
  }
  user_data = data.template_file.dbsrv_private_ip.rendered
}
data "template_file" "dbsrv_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.22/24" ## Edit to the IP address for the server
  }
}
