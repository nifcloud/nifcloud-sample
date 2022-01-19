terraform {
  required_providers {
    nifcloud = {
      source  = "nifcloud/nifcloud"
      version = ">= 1.3.0"
    }
  }
}


provider "nifcloud" {
  region = "jp-east-4"
}
