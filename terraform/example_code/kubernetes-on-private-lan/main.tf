terraform {
  required_providers {
    nifcloud = {
      source = "nifcloud/nifcloud"
      version = ">= 1.5.1"
    }
  }
}

provider "nifcloud" {
  region = var.region
}
