# Server Instance Config srv
resource "nifcloud_instance" "srv" {
  instance_id       = "srv"
  availability_zone = "east-14"

  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.cdprockyimage.id

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.srvfw.group_name

  # Server size.
  # https://pfs.nifcloud.com/api/rest/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "cdp_image"

  # Network Interface
  # this sample is set common_global & common_private
  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }

  network_interface {
    network_id = "net-COMMON_PRIVATE"
  }
}
