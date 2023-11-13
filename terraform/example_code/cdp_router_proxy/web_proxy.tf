resource "nifcloud_web_proxy" "router_proxy" {
  router_id                   = nifcloud_router.rt.id
  bypass_interface_network_id = "net-COMMON_GLOBAL"
  listen_interface_network_name    = nifcloud_private_lan.PrivateLan01.private_lan_name
  listen_port                 = "8080"
  description                 = "CDP Router WebProxy Pattern"
  name_server                 = "8.8.8.8"
}
