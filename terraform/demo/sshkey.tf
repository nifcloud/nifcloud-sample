resource "nifcloud_key_pair" "demo" {
  key_name   = "demokey"
  public_key = base64encode(tls_private_key.demo.public_key_openssh)
}

resource "tls_private_key" "demo" {
  algorithm = "RSA"
}
