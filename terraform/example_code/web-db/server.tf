# Server Instance Config
resource "nifcloud_instance" "web001" {
  instance_id       = "web001"
  availability_zone = "jp-east-41"
  # Pri-installed OS
  # Show file os_image.tf
  image_id = data.nifcloud_image.CentOS_8_1.id
  # SSH Key File
  # Show file keymake.tf
  key_name = nifcloud_key_pair.east41.key_name
  # Firewall Group
  # show file firewall.tf
  security_group = nifcloud_security_group.webfw.group_name
  # Server size.
  # https://pfs.nifcloud.com/api/rest/RunInstances.htm
  instance_type = "small"
  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type = "2"

  # Network Interface
  # this sample is set common global and elastic ip
  network_interface {
    # Connect Network
    # net-COMMON_GLOBAL :Common Global
    # net-COMMON_PRIVATE:Common Private
    # NetworkID         :Network ID at Private LAN
    network_id = "net-COMMON_GLOBAL"
    # Ipaddress.
    ip_address = nifcloud_elastic_ip.web001.public_ip
  }

  # this sample is set private lan
  network_interface {
    # Connect Network
    # net-COMMON_GLOBAL :Common Global
    # net-COMMON_PRIVATE:Common Private
    # NetworkID         :Network ID at Private LAN
    network_id = nifcloud_private_lan.Private01.id
    ip_address = "198.51.100.20"
  }
}

resource "nifcloud_instance" "web002" {
  instance_id       = "web002"
  availability_zone = "jp-east-41"
  image_id          = data.nifcloud_image.CentOS_8_1.id
  key_name          = nifcloud_key_pair.east41.key_name
  security_group    = nifcloud_security_group.webfw.group_name
  instance_type     = "small"
  accounting_type   = "2"

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = nifcloud_elastic_ip.web002.public_ip
  }

  network_interface {
    network_id = nifcloud_private_lan.Private01.id
    ip_address = "198.51.100.21"
  }
}

# Private Network Only Server sample
resource "nifcloud_instance" "commonserver" {
  instance_id       = "commonsv"
  description       = "ntp dns server"
  availability_zone = "jp-east-41"
  image_id          = data.nifcloud_image.CentOS_8_1.id
  key_name          = nifcloud_key_pair.east41.key_name
  security_group    = nifcloud_security_group.privatefw.group_name
  instance_type     = "small"
  accounting_type   = "2"

  # this sample is set private lan only
  network_interface {
    network_id = nifcloud_private_lan.Private01.id
    ip_address = "198.51.100.201"
  }
}

# Disk Create server
resource "nifcloud_volume" "commonserver" {
  # Comment
  description     = "memo"
  #1:Monthly
  #2:Payper
  accounting_type = "2"
  # Disk Size
  size            = 100
  # Disk Nmae
  volume_id       = "comdisk01"
  # Disk Type
  # See also diskType at https://pfs.nifcloud.com/api/rest/DescribeVolumes.htm
  disk_type       = "High-Speed Storage B"
  # Connect Server ID
  instance_id     = nifcloud_instance.commonserver.instance_id
  # to reboot when connecting this disk
  reboot          = "true"
}
