# Server Instance Config server
resource "nifcloud_instance" "websrv2" {
  instance_id       = "websrv2"
  availability_zone = "east-14"
  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.casemultizone.key_name
  # Firewall Group
  # show file east-14-firewall.tf
  security_group = nifcloud_security_group.websrv2fw.group_name
  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "CDP Multi Zone Pattern"
 
  # Network Interface
  # this sample is set common global and elastic ip
  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }
  
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan02.id
    ip_address = "static"
  }
  user_data = data.template_file.websrv2_private_ip.rendered
}
data "template_file" "websrv2_private_ip" {
  template = file("scripts/websrv_setting.sh")

  vars = {
    private_address = "192.0.2.2/24" ## Edit to the IP address for the server
  }
}

resource "nifcloud_instance" "dbsrv2" {
  instance_id       = "dbsrv2"
  availability_zone = "east-14"
  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.casemultizone.key_name
  # Firewall Group
  # show file east-14-firewall.tf
  security_group = nifcloud_security_group.dbsrv2fw.group_name
  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "CDP Multi Zone Pattern"
 
  # Network Interface
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan02.id
    ip_address = "static"
  }
  user_data = data.template_file.dbsrv2_private_ip.rendered
}
data "template_file" "dbsrv2_private_ip" {
  template = file("scripts/dbsrv_setting.sh")

  vars = {
    private_address = "192.0.2.12/24" ## Edit to the IP address for the server
  }
}
