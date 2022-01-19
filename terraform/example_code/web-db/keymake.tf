# SSH key sample
resource "nifcloud_key_pair" "east41" {
  # SSH Key name
  key_name   = "tfeast41"
  # SSH Key File
  public_key = filebase64("${path.module}/../pubkey.pub")
}

