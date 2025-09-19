# Loadbalancer Config l4lb
resource "nifcloud_load_balancer" "basic" {
  load_balancer_name = "l4lb"

  # The port on the instance to route to
  instance_port = 80
  # The port to listen on for the load balancer
  load_balancer_port = 80

  # Accounting type. (1: monthly, 2: pay per use)
  accounting_type = "2"

  # A list of instance names to place in the load balancer pool
  # show file east-13-server.tf and east-14-server.tf
  instances = [
    nifcloud_instance.websrv1.id,
    nifcloud_instance.websrv2.id,
  ]

  # Sorry page
  # The flag of sorry page
  sorry_page_enable = true
  # The HTTP status code for sorry page
  sorry_page_status_code = "503"
}
