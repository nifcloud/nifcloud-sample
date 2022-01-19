# Static IP sample
# see https://pfs.nifcloud.com/api/rest/AllocateAddress.htm
resource "nifcloud_elastic_ip" "web001" {
  # true :Private IP
  # false:Global IP
  ip_type           = false
  # Create zone
  availability_zone = "jp-east-41"
  # memo
  description       = "memo"
}

resource "nifcloud_elastic_ip" "web002" {
  ip_type           = false
  availability_zone = "jp-east-41"
  description       = "memo"
}
