# SSH key
resource "nifcloud_key_pair" "e1key" {
  provider = nifcloud.east1

  # SSH Key name
  key_name   = "e1sshkey"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP VPN GW Pattern on East-1"

}

resource "nifcloud_key_pair" "w1key" {
  provider = nifcloud.west1

  # SSH Key name
  key_name   = "w1sshkey"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP VPN GW Pattern on West-1"

}
