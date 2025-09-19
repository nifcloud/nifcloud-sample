# SSH key
resource "nifcloud_key_pair" "disk" {

  # SSH Key name
  key_name   = "diskkey"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP Disk Attach Pattern"

}
