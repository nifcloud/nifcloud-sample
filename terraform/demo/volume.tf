resource "nifcloud_volume" "demo" {
  count = length(nifcloud_instance.demo)

  disk_type   = "High-Speed Flash Storage A"
  instance_id = element(nifcloud_instance.demo.*.id, count.index)
  size        = 100
}
