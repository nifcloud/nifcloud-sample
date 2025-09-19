# Server Instance Config srv1
resource "nifcloud_instance" "srv1" {
  instance_id       = "srv1"
  availability_zone = "east-14"

  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.ss.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.ssfw.group_name

  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "CDP Server Separate Pattern"

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

# srv1 post-creation process
data "template_file" "srv1_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.101/24"
  }
}

# Server Instance Config srv2
resource "nifcloud_instance" "srv2" {
  instance_id       = "srv2"
  availability_zone = "east-14"

  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.ss.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.ssfw.group_name

  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "CDP Server Separate Pattern"

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

  user_data = data.template_file.srv2_private_ip.rendered  
}

# srv2 post-creation process
data "template_file" "srv2_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.102/24"
  }
}

# Server Instance Config srv3
resource "nifcloud_instance" "srv3" {
  instance_id       = "srv3"
  availability_zone = "east-14"

  # Pre-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.rockylinux.id

  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.ss.key_name

  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.ssfw.group_name

  # Server size.
  # https://docs.nifcloud.com/cp/api/RunInstances.htm
  instance_type = "c-medium"

  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type = "2"

  # memo
  description       = "CDP Server Separate Pattern"

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

  user_data = data.template_file.srv3_private_ip.rendered
}

# srv3 post-creation process
data "template_file" "srv3_private_ip" {
  template = file("scripts/srv_setting.sh")

  vars = {
    private_address = "192.0.2.103/24"
  }
}
