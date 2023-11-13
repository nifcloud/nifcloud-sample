resource "nifcloud_nas_security_group" "nasgr" {
  group_name        = "nasgroup001"
  description       = "nas"
  availability_zone = "east-14"

  rule {
    cidr_ip = "192.0.2.0/24"
  }

  rule {
    security_group_name = nifcloud_security_group.nas.group_name
  }
}

resource "nifcloud_security_group" "nas" {
  group_name        = "group001"
  availability_zone = "east-14"
}