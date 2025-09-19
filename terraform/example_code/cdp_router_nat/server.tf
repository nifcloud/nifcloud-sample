# Server Instance Config server
resource "nifcloud_instance" "srv" {
  instance_id       = "srv"
  availability_zone = "east-14"
  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.caserouternat.key_name
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
  description       = "CDP Router NAT Pattern"
 
  # Network Interface
  # this sample is set common global and elastic ip
  ### network_interface {
  ###  network_id = "net-COMMON_GLOBAL"
  ###}
  #
  # this sample is set private lan
  network_interface {
    network_id = nifcloud_private_lan.PrivateLan01.id
    ip_address = "static"
  }
  user_data = data.template_file.srv_private_ip.rendered
}
data "template_file" "srv_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.2/24" ## Enter the IP address for the server
    private_gateway = "192.0.2.1"  ## Enter the IP address for the server's default gateway
  }
}
