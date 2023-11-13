# SSH key
resource "nifcloud_key_pair" "redundantize" {

  # SSH Key name
  key_name   = "redundantize"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "redundantize"

}
