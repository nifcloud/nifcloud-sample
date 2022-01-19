# Cert sample config
resource "nifcloud_ssl_certificate" "example_com" {
  # memo
  description = "example.com"
  # Public key File
  certificate = file("${path.module}/../cert.pem")
  # Private key File
  key         = file("${path.module}/../privkey.pem")
  # Intermediate certificate  File
  ca          = file("${path.module}/../chain.pem")
}
