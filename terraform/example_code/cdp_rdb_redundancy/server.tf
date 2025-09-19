# Server Instance Config
resource "nifcloud_instance" "web001" {
  instance_id       = "web001"
  availability_zone = "east-11"
  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.cdprdbredundancy.key_name
  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.websrvfw.group_name
  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c2-medium"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

# memo
  description       = "cdp_rdb_redundancy"

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
  user_data = data.template_file.web001_private_ip.rendered
}
data "template_file" "web001_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.10/24"
  }
}
