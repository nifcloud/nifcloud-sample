# SSH key
resource "nifcloud_key_pair" "casesorrypage" {

  # SSH Key name
  key_name   = "casesorrypage"

  # SSH Key File
  public_key = filebase64("${path.module}/pubkey/pubkey.pub")

  # memo
  description       = "CDP SorryPage Pattern 2"

}
