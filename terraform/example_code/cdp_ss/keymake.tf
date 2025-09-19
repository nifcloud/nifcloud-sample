# SSH key sample
resource "nifcloud_key_pair" "ss" {
  # SSH Key name
  key_name   = "sshkey"
  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")
}
