# SSH key
resource "nifcloud_key_pair" "caserouternat" {

  # SSH Key name
  key_name   = "caserouternat"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP Router NAT Pattern"

}