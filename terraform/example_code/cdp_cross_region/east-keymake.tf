# SSH key
resource "nifcloud_key_pair" "eastcrossregion" {
  provider = nifcloud.east1

  # SSH Key name
  key_name   = "eastcrossregion"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP Cross Region Pattern"
}
