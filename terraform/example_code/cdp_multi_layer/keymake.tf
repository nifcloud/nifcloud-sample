# SSH key
resource "nifcloud_key_pair" "multilayer" {

  # SSH Key name
  key_name   = "multilayer"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "multi_layer"

}
