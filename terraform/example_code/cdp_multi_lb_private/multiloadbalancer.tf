# Multi Loadbarancer Config
resource "nifcloud_elb" "elb" {
  # see https://docs.nifcloud.com/cp/api/NiftyCreateElasticLoadBalancer.htm
  # Multi Loadbarancer name
  elb_name          = "elb"
  # memo
  description       = "cdp_multi_lb_private"
  # Create zone
  availability_zone = "jp-east-14"
  # Accounting
  #1:Monthly
  #2:Payper
  accounting_type   = "2"
  # Traffic limit
  network_volume    = 10
  # Balancing Type
  # 1:Round-Robin
  # 2:Least-Connection
  balancing_type    = 1
  # Protocol Type
  # TCP  : any TCP traffic
  # UDP  : any UDP traffic
  # HTTP : HTTP Traffic
  # Target Port
  instance_port     = 80
  # HTTPS: HTTPS Traffic.request SSL Cert
  protocol          = "HTTP"
  # Waiting Port
  lb_port           = 80

  # Target Server
  instances = [
    nifcloud_instance.srv2.id,
    nifcloud_instance.srv3.id
  ]

  # Sorryp Page Config
  sorry_page_enable       = true
  sorry_page_redirect_url = "https://example.com/"
  # Route Table
  route_table_id = nifcloud_route_table.route_table.id

  # network_interface1
  network_interface {
    # Connect Network
    network_id = nifcloud_private_lan.PrivateLan02.id
    # Private IP
    ip_address      = "192.0.2.4"
    # systemIpAddress1
    system_ip_addresses{
      system_ip_address = "192.0.2.100"
    }
    # systemIpAddress2
    system_ip_addresses{
      system_ip_address = "192.0.2.101"
    }
  }
}
