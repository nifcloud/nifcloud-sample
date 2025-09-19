# Multi Loadbarancer sample
resource "nifcloud_elb" "web001" {
  # see https://docs.nifcloud.com/cp/api/NiftyCreateElasticLoadBalancer.htm
  # Multi Loadbarancer name
  elb_name          = "web001"
  # memo
  description       = "memo-upd"
  # Create zone
  availability_zone = "jp-east-41"
  # Accounting
  #1:Monthly
  #2:Pay-per
  accounting_type   = "2"
  # Traffic limit
  network_volume    = 30
  # Balancing Type
  # 1:Round-Robin
  # 2:Least-Connection
  balancing_type    = 1
  # Protocol Type
  # TCP  : any TCP traffic
  # UDP  : any UDP traffic
  # HTTP : HTTP Traffic
  # HTTPS: HTTPS Traffic.request SSL Cert
  protocol          = "HTTPS"
  # Waiting Port
  lb_port           = 443
  # Target Port
  instance_port     = 80

  # Target Server
  instances = [
    nifcloud_instance.web001.id,
    nifcloud_instance.web002.id,
  ]

  # SSL Cert ID
  ssl_certificate_id                 = nifcloud_ssl_certificate.example_com.id
  # Health Check Config
  unhealthy_threshold                = 3 #times
  health_check_target                = "HTTP:80"
  health_check_interval              = 11 #second
  health_check_path                  = "/health-upd"
  health_check_expectation_http_code = ["200", "302"]
  # Sessin Stickiy Config
  session_stickiness_policy_enable            = true
  ## Sessin Stickiey Type
  ## 1:Source IP
  ## 2:Cookie
  session_stickiness_policy_method            = "2"
  session_stickiness_policy_expiration_period = 5 #second
  # Sorryp Page Config
  sorry_page_enable       = true
  sorry_page_redirect_url = "http://example.com"
  # Route Table Config
  #route_table_id = nifcloud_route_table.upd.id


  network_interface {
    network_id     = "net-COMMON_GLOBAL"
    is_vip_network = true
  }

  network_interface {
    network_id = nifcloud_private_lan.Private01.id
    is_vip_network = false
  }
}
