resource "nifcloud_private_lan" "this" {
  private_lan_name = var.private_lan_name
  availability_zone = var.zone
  cidr_block = var.private_lan_cidr_block
  accounting_type = var.private_lan_accounting_type
}
