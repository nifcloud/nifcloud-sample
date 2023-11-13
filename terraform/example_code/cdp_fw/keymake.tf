# SSH key
resource "nifcloud_key_pair" "casecdpfw" {

  # SSH Key name
  key_name   = "casecdpfw"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP FireWall Pattern"

}