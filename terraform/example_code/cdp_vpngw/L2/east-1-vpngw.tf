# ------- VPN Connection Config ------------------------
resource "nifcloud_customer_gateway" "e14tow12custgw" {
  provider = nifcloud.east1
  # Base Document https://docs.nifcloud.com/cp/api/CreateCustomerGateway.htm
  # Customer Gateway Name
  name                = "e14tow12custgw"
  # VPN Type
  type                = "L2TPv3 / IPsec"
  # Target Global IP for establishing a VPN Connection 
  ip_address          = nifcloud_vpn_gateway.w12vpngw.public_ip_address
  lifecycle {
    create_before_destroy = true
  }
}


resource "nifcloud_vpn_connection" "e14tow12connection" {
  provider = nifcloud.east1
  # Base Document https://docs.nifcloud.com/cp/api/CreateVpnConnection.htm
  # memo
  description                                          = "CDP VPN GW Pattern on East-1"
  # VPN Connection Type.
  # "IPsec"         :L3 VPN.can not use routing
  # "IPsec VTI"     :L3 VPN.can use routing.
  # "L2TPv3 / IPsec":L2 VPN
  type                                                 = "L2TPv3 / IPsec"
  # Perform connection VPN Gateway
  vpn_gateway_name                                     = nifcloud_vpn_gateway.e14vpngw.name
  # VPN Config
  customer_gateway_name                                = nifcloud_customer_gateway.e14tow12custgw.name
  # Tunneling type.Only set "L2TPv3" when use vpn type is "L2TPv3 / IPsec"
  tunnel_type                                          = "L2TPv3"
  # Tunneling mode."Managed" or "Unmanaged" when use tunne_type is "L2TPv3"
  tunnel_mode                                          = "Unmanaged"
  # Tunneling Protocol.
  # IP:use IP.only if tunnel_mode is "Unmanaged" can be set
  # UDP:use UDP.
  tunnel_encapsulation                                 = "UDP"
  # Tunnel ID in local device
  tunnel_id                                            = var.tunnel_id_1
  # Tunnel session ID in local device
  tunnel_session_id                                    = var.tunnel_session_id_1
  # Tunnel port in local device
  tunnel_source_port                                   = var.tunnel_source_port_1
  # Tunnel ID in opposite device 
  tunnel_peer_id                                       = var.tunnel_id_2
  # Tunnel session ID in opposite device 
  tunnel_peer_session_id                               = var.tunnel_session_id_2
  # Tunnel port in opposite device
  tunnel_destination_port                              = var.tunnel_source_port_2
  # MTU Size for L2TP Interface.default 1500
  mtu                                                  = "1500"
  # encryption algorithm.See NiftyIpsecConfiguration.EncryptionAlgorithm
  # Default:AES128
  ipsec_config_encryption_algorithm                    = "AES256"
  # authentication algorithm.See NiftyIpsecConfiguration.HashAlgorithm
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
  # Diffie-Hellman Group Parameter
  # See NiftyIpsecConfiguration.DiffieHellmanGroup
  # default:2(1024-bit MODP group)
  ipsec_config_diffie_hellman_group                    = 2
}
