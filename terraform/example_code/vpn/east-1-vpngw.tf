# ------- VPN Connection Config ------------------------
resource "nifcloud_customer_gateway" "e13tow12custgw" {
  provider = nifcloud.east1
  # Base Document https://docs.nifcloud.com/cp/api/CreateCustomerGateway.htm
  # Cosuter Gateway Name
  name                = "e13tow12custgw"
  # Target Global IP for establishing a VPN Connection 
  ip_address          = nifcloud_vpn_gateway.w12vpngw.public_ip_address
  ## IP of the network to which the Opposite device
  #lan_side_ip_address = "198.51.100.254"
  ## Private networkc CIDR which the Opposite device
  ## only can set when use vpn type is "L2TPv3 / IPsec"
  #lan_side_cidr_block  = nifcloud_private_lan.W12VPNPri01.cidr_block
}


resource "nifcloud_vpn_connection" "e13tow12connection" {
  provider = nifcloud.east1
  # Base Document https://docs.nifcloud.com/cp/api/CreateVpnConnection.htm
  # memo
  description                                          = "e13tow12connection"
  # VPN Connection Type.
  # "IPsec"         :L3 VPN.can not use routing
  # "IPsec VTI"     :L3 VPN.can use routing.
  # "L2TPv3 / IPsec":L2 VPN
  type                                                 = "L2TPv3 / IPsec"
  # Perform connection VPN Gateway
  vpn_gateway_name                                     = nifcloud_vpn_gateway.e13vpngw.name
  # VPN Configu
  customer_gateway_name                                = nifcloud_customer_gateway.e13tow12custgw.name
  # Tunneling type.Only set "L2TPv3"
  tunnel_type                                          = "L2TPv3"
  # Tunneling mode."Managed" or "Unmanaged"
  tunnel_mode                                          = "Unmanaged"
  # Tunneling Protocol.
  # IP:use IP.only if tunnel_mode is "Unmanaged" can be set
  # UDP:use UDP.
  tunnel_encapsulation                                 = "UDP"
  # Tunnle ID in local device
  tunnel_id                                            = var.tunnel_id_1
  # Tunnle session ID in local device
  tunnel_session_id                                    = var.tunnel_session_id_1
  # Tunnle port in local device
  tunnel_source_port                                   = var.tunnel_source_port_1
  # Tunnel ID in opposide device 
  tunnel_peer_id                                       = var.tunnel_id_2
  # Tunnel session ID in opposide device 
  tunnel_peer_session_id                               = var.tunnel_session_id_2
  # Tunnle port in opposide device
  tunnel_destination_port                              = var.tunnel_source_port_2
  # MTU Size for L2TP Interface.default 1500
  mtu                                                  = "1500"
  # encryption algorithm.See NiftyIpsecConfiguration.EncryptionAlgorithm
  # Default:AES128
  ipsec_config_encryption_algorithm                    = "AES256"
  # authentation algorithm.See NiftyIpsecConfiguration.HashAlgorithm
  # Default:SHA1
  ipsec_config_hash_algorithm                          = "SHA256"
  # pre shared key.See NiftyIpsecConfiguration.PreSharedKey
  # default:auto generation
  ipsec_config_pre_shared_key                          = "test"
  # IKE Protocol."IKEv1"(default) or "IKEv2"
  ipsec_config_internet_key_exchange                   = "IKEv2"
  # expiration time for IKE SA.Range 30～86400(sec).default 28800
  ipsec_config_internet_key_exchange_lifetime          = 28800
  # expiration time for ESP SA.Range 30～86400(sec).default 3600
  ipsec_config_encapsulating_security_payload_lifetime = 3600
  # Diffie-Hellman Group Paramater
  # See NiftyIpsecConfiguration.DiffieHellmanGroup
  # default:2(1024-bit MODP group)
  ipsec_config_diffie_hellman_group                    = 2
}


resource "nifcloud_customer_gateway" "e13tow21custgw" {
  provider = nifcloud.east1
  # Base Document https://docs.nifcloud.com/cp/api/CreateCustomerGateway.htm
  # Cosuter Gateway Name
  name                = "e13tow21custgw"
  # Target Global IP for establishing a VPN Connection 
  ip_address          = nifcloud_vpn_gateway.w21vpngw.public_ip_address
  ## IP of the network to which the Opposite device
  #lan_side_ip_address = "198.51.100.254"
  ## Private networkc CIDR which the Opposite device
  ## only can set when use vpn type is "L2TPv3 / IPsec"
  #lan_side_cidr_block  = nifcloud_private_lan.W12VPNPri01.cidr_block
}


resource "nifcloud_vpn_connection" "e13tow21connection" {
  provider = nifcloud.east1
  # Base Document https://docs.nifcloud.com/cp/api/CreateVpnConnection.htm
  # memo
  description                                          = "tow21connection"
  # VPN Connection Type.
  # "IPsec"         :L3 VPN.can not use routing
  # "IPsec VTI"     :L3 VPN.can use routing.
  # "L2TPv3 / IPsec":L2 VPN
  type                                                 = "L2TPv3 / IPsec"
  # Perform connection VPN Gateway
  vpn_gateway_name                                     = nifcloud_vpn_gateway.e13vpngw.name
  # VPN Configu
  customer_gateway_name                                = nifcloud_customer_gateway.e13tow21custgw.name
  # Tunneling type.Only set "L2TPv3"
  tunnel_type                                          = "L2TPv3"
  # Tunneling mode."Managed" or "Unmanaged"
  tunnel_mode                                          = "Unmanaged"
  # Tunneling Protocol.
  # IP:use IP.only if tunnel_mode is "Unmanaged" can be set
  # UDP:use UDP.
  tunnel_encapsulation                                 = "UDP"
  # Tunnle ID in local device
  tunnel_id                                            = var.tunnel_id_3
  # Tunnle session ID in local device
  tunnel_session_id                                    = var.tunnel_session_id_3
  # Tunnle port in local device
  tunnel_source_port                                   = var.tunnel_source_port_3
  # Tunnel ID in opposide device 
  tunnel_peer_id                                       = var.tunnel_id_4
  # Tunnel session ID in opposide device 
  tunnel_peer_session_id                               = var.tunnel_session_id_4
  # Tunnle port in opposide device
  tunnel_destination_port                              = var.tunnel_source_port_4
  # MTU Size for L2TP Interface.default 1500
  mtu                                                  = "1500"
  # encryption algorithm.See NiftyIpsecConfiguration.EncryptionAlgorithm
  # Default:AES128
  ipsec_config_encryption_algorithm                    = "AES256"
  # authentation algorithm.See NiftyIpsecConfiguration.HashAlgorithm
  # Default:SHA1
  ipsec_config_hash_algorithm                          = "SHA256"
  # pre shared key.See NiftyIpsecConfiguration.PreSharedKey
  # default:auto generation
  ipsec_config_pre_shared_key                          = "test"
  # IKE Protocol."IKEv1"(default) or "IKEv2"
  ipsec_config_internet_key_exchange                   = "IKEv2"
  # expiration time for IKE SA.Range 30～86400(sec).default 28800
  ipsec_config_internet_key_exchange_lifetime          = 28800
  # expiration time for ESP SA.Range 30～86400(sec).default 3600
  ipsec_config_encapsulating_security_payload_lifetime = 3600
  # Diffie-Hellman Group Paramater
  # See NiftyIpsecConfiguration.DiffieHellmanGroup
  # default:2(1024-bit MODP group)
  ipsec_config_diffie_hellman_group                    = 2
}
