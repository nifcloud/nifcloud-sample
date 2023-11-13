# SSH key
resource "nifcloud_key_pair" "caserouterproxy" {

  # SSH Key name
  key_name   = "caserouterproxy"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP Router WebProxy Pattern"

}
