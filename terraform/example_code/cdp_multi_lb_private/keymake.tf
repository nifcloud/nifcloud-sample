# SSH key
resource "nifcloud_key_pair" "cdpmlbprivate" {

  # SSH Key name
  key_name   = "cdpmlbprivate"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "cdp_multi_lb_private"

}

