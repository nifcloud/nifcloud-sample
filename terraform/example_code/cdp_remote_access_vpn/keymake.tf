# SSH key
resource "nifcloud_key_pair" "srv" {

  # SSH Key name
  key_name   = "srvkey"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description = "CDP Remote Access VPN Pattern server"

}
