resource "nifcloud_remote_access_vpn_gateway" "basic" {

  # remote access vpn gateway document
  # https://docs.nifcloud.com/network/spec/ra_vpngw/ra_vpngw.htm
  # https://docs.nifcloud.com/cp/api/CreateRemoteAccessVpnGateway.htm

  # The remote access vpn gateway name.
  name               = "example"
  
  # The remote access vpn gateway description.
  description        = "CDP Remote Access VPN Pattern"

  # The availability zone.
  availability_zone  = "jp-west-21"

  # Accounting type. (1: monthly, 2: pay per use).
  accounting_type    = "2"

  # The type of the remote access vpn gateway. Valid types are small, medium, large
  type               = "small"

  # The cidr of pool network; can be specified in the range of /16 to /27.
  pool_network_cidr  = "198.51.100.0/24"

  # The Cipher suite; can be specified one of AES128-GCM-SHA256 AES256-GCM-SHA384 ECDHE-RSA-AES128-GCM-SHA256 ECDHE-RSA-AES256-GCM-SHA384 .
  cipher_suite       = ["AES128-GCM-SHA256"]
  
  # The ID of ssl certificate.
  ssl_certificate_id = nifcloud_ssl_certificate.basic.id

  # The ID of ca certificate.
  ca_certificate_id  = "cac-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  user {
    # The name of remote access vpn gateway user.
    name        = "user1"
    # The password of remote access vpn gateway user.
    password    = random_password.password.result
    # The remote access vpn gateway user description.
    description = "CDP Remote Access VPN Pattern user1"
  }

  network_interface {
    # The ID of the network to attach private lan network.
    network_id = nifcloud_private_lan.PrivateLan01.id
    # The IP address of the network interface.
    ip_address = "192.0.2.10"
  }

}

resource "random_password" "password" {
  length = 8
}
