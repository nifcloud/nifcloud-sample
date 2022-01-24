resource "nifcloud_hatoba_firewall_group" "this" {
  name = var.hatoba_fw_name

  dynamic "rule" {
    for_each = var.hatoba_fw_rules
    content {
      protocol = rule.value.protocol
      direction = rule.value.direction
      from_port = rule.value.from_port
      to_port = rule.value.to_port
      cidr_ip = rule.value.cidr_ip
      description = rule.value.description
    }
  }
}

resource "nifcloud_hatoba_cluster" "this" {
  name = var.hatoba_cluster_name
  firewall_group = nifcloud_hatoba_firewall_group.this.name
  locations = [var.zone]

  dynamic "node_pools" {
    for_each = var.hatoba_cluster_node_pools
    content {
      name = node_pools.value.name
      instance_type = node_pools.value.instance_type
      node_count = node_pools.value.node_count
    }
  }

  addons_config {
    http_load_balancing {
      disabled = var.hatoba_cluster_addons_config_http_load_balancing_disabled
    }
  }

  network_config {
    network_id = nifcloud_private_lan.this.id
  }
}
