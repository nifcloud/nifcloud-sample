# SSH key
resource "nifcloud_key_pair" "westcrossregion" {
  provider = nifcloud.west1

  # SSH Key name
  key_name   = "westcrossregion"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP Cross Region Pattern"
}
