# Router Config sample
# This Router is enable DHCP,Proxy
resource "nifcloud_router" "webdbrouter" {
  # Router Name
  name              = "webdbrouter"
  # memo
  description       = "dhcp"
  # Create zone
  availability_zone = "jp-east-41"
  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type   = "2"
  # Router Size
  # small :~10 route per route table
  # medium:~30 route per route table
  # large :~80 route per route table
  type              = "small"
  # Firewall Group
  security_group    = nifcloud_security_group.webfw.group_name

  ## Network Interface
  ## this sample is set common global
  #network_interface {
  #  # Connect Network
  #  # net-COMMON_GLOBAL :Common Global
  #  # net-COMMON_PRIVATE:Common Private
  #  # NetworkID         :Network ID at Private LAN
  #  network_id = "net-COMMON_GLOBAL"
  #}

  # this sample is set private lan
  network_interface {
    # Connect Network
    # NetworkID         :Network ID at Private LAN
    network_name    = nifcloud_private_lan.Private01.private_lan_name
    # Router Private IP
    ip_address      = "198.51.100.1"
    # DHCP enable on this private lan
    dhcp            = "true"
    # DHCP config(ip range to distribute)
    dhcp_config_id  = nifcloud_dhcp_config.webdbnw.id
    # DHCP option(dns,default gw and more)
    dhcp_options_id = nifcloud_dhcp_option.webdbnw.id
  }
}

# DHCP config sample
resource "nifcloud_dhcp_config" "webdbnw" {
  # Dynamic distribute ip range
  ipaddress_pool {
    # Range start
    ipaddress_pool_start       = "198.51.100.10"
    # Range end
    ipaddress_pool_stop        = "198.51.100.99"
    # memo
    ipaddress_pool_description = "memo"
  }
  # Static distribute ip range
  static_mapping {
    # distribute ip range
    static_mapping_ipaddress   = "198.51.100.240"
    # target macaddress
    static_mapping_macaddress  = "00:00:5e:00:53:00"
    # memo
    static_mapping_description = "static-mapping-memo"
  }
}

# DHCP option sample
resource "nifcloud_dhcp_option" "webdbnw" {
  # domain name
  domain_name         = "example.com"
  # default gatway
  default_router      = "198.51.100.1"
  # DNS server
  domain_name_servers = ["198.51.100.201","198.51.100.202"]
  # NTP server
  ntp_servers         = ["198.51.100.201","198.51.100.202"]
  # NetBIOS Type
  # 1:not use WINS
  # 2:not use Broadcast
  # 4:Give Priority to Broadcast
  # 8:Give Priority to WINS
  netbios_node_type = "1"
  # NetBIOS nameserver
  netbios_name_servers = ["198.51.100.201","198.51.100.202"]
  # IP lease time
  lease_time          = "600"
}

## Proxy Option
#resource "nifcloud_web_proxy" "proxy" {
#  # memo
#  description                 = "proxy config"
#  # Link Router
#  router_id                   = nifcloud_router.webdbrouter.id
#  # Traffic output Network
#  bypass_interface_network_id = "net-COMMON_GLOBAL"
#  # Traffic listen Network
#  listen_interface_network_id = nifcloud_private_lan.Private01.id
#  # Traffic listen port
#  listen_port                 = "8080"
#  # using dns server
#  name_server                 = "1.1.1.1"
#}
