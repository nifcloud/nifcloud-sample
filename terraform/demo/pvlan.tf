resource "nifcloud_private_lan" "demo" {
  private_lan_name = "demo"
  cidr_block       = "192.168.1.0/24"
}
