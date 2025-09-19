# SSH key
resource "nifcloud_key_pair" "cdprdbredundancy" {

  # SSH Key name
  key_name   = "cdprdbredundancy"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "cdp_rdb_redundancy"

}
