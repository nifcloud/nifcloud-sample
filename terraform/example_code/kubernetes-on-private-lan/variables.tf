variable "region" {
  default = "jp-east-4"
  type = string
}

variable "zone" {
  default = "jp-east-41"
  type = string
}

variable "private_lan_name" {
  default = "privatelan"
  type = string
}

variable "private_lan_cidr_block" {
  default = "192.168.0.0/16"
  type = string
}

variable "private_lan_accounting_type" {
  default = "1"
  type = string
}

variable "dhcp_config_ipaddress_pool_start" {
  default = "192.168.1.1"
  type = string
}

variable "dhcp_config_ipaddress_pool_stop" {
  default = "192.168.1.255"
  type = string
}

variable "security_group_name_for_router" {
  default = "routerfw"
  type = string
}

variable "router_name" {
  default = "router"
  type = string
}

variable "router_accounting_type" {
  default = "1"
  type = string
}

variable "router_type" {
  default = "small"
  type = string
}

variable "router_ip_address" {
  default = "192.168.0.1"
  type = string
}

variable "hatoba_fw_name" {
  default = "hatobafw"
  type = string
}

variable "hatoba_fw_rules" {
  type = list(object({
    protocol = string
    direction = string
    from_port = number
    to_port = number
    cidr_ip = string
    description = string
  }))
  default = []
}

variable "hatoba_cluster_name" {
  default = "hatobacluster"
  type = string
}

variable "hatoba_cluster_node_pools" {
  type = list(object({
    name = string
    instance_type = string
    node_count = number
  }))
  default = [
    {
      name = "pool01"
      instance_type = "c-medium"
      node_count = 3
    }
  ]
}

variable "hatoba_cluster_addons_config_http_load_balancing_disabled" {
  default = false
  type = bool
}
