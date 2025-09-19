resource "nifcloud_ssl_certificate" "basic" {
  certificate = file("${path.module}/cert/certificate.pem")
  key         = file("${path.module}/cert/private_key.pem")
}
