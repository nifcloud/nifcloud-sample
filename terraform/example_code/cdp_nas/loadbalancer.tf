resource "nifcloud_load_balancer" "l4lb" {
  load_balancer_name = "l4lb"
  instance_port = 80
  load_balancer_port = 80
  accounting_type = "2"

  instances = [
    nifcloud_instance.srv1.id,
    nifcloud_instance.srv2.id,
  ]
}

