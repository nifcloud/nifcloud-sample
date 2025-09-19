variable tunnel_id_1{
  type        = string
  description = "VPN GW 1 tunnel id"
}
variable tunnel_session_id_1{
  type        = string
  description = "VPN GW 1 session id"
}
variable tunnel_source_port_1{
  type        = string
  description = "VPN GW 1 surce Port"
}

variable tunnel_id_2{
  type        = string
  description = "VPN GW 2 tunnel id"
}
variable tunnel_session_id_2{
  type        = string
  description = "VPN GW 2 session id"
}
variable tunnel_source_port_2{
  type        = string
  description = "VPN GW 2 surce Port"
}
variable w12_route_ip_vpn_nw{
  type = string
  description = "value of west-1 router ipaddress on VPN network"
}
variable w12_route_ip_srv_nw{
  type = string
  description = "value of west-1 router ipaddress on server network"
}
