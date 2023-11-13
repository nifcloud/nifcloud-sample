# Loadbalancer Config l4lb
resource "nifcloud_load_balancer" "basic" {
  load_balancer_name = "l4lb"

  # The port on the instance to route to
  instance_port = 80
  # The port to listen on for the load balancer
  load_balancer_port = 80

  # Accounting type. (1: monthly, 2: pay per use)
  accounting_type = "2"

  # filter 
  # A list of IP address filter for load balancer
  filter = ["124.24.48.221"]
  # The filter_type of filter (1: Allow, 2: Deny)
  filter_type = "1"

  # A list of instance names to place in the load balancer pool
  # show file server.tf
  instances = [
    nifcloud_instance.srv1.id,
    nifcloud_instance.srv2.id,
  ]

  # Sorry page
  # The flag of sorry page
  sorry_page_enable = true
  # The HTTP status code for sorry page
  sorry_page_status_code = "200"
}
