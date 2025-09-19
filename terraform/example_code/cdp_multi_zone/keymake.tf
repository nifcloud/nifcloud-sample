# SSH key
resource "nifcloud_key_pair" "casemultizone" {

  # SSH Key name
  key_name   = "casemultizone"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP Multi Zone Pattern"

}
