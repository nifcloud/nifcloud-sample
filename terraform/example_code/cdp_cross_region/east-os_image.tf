data "nifcloud_image" "east-rockylinux" {
  provider = nifcloud.east1

  image_name = "Rocky Linux 9.5"
}
