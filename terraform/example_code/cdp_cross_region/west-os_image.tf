data "nifcloud_image" "west-rockylinux" {
  provider = nifcloud.west1

  image_name = "Rocky Linux 9.5"
}
