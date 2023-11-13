# SSH key
resource "nifcloud_key_pair" "nas" {

  # SSH Key name
  key_name   = "naskey"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "nas"

}
