terraform {
  required_providers {
    nifcloud = {
      source = "nifcloud/nifcloud"
    }
  }
}

provider "nifcloud" {
  region = "jp-east-1"
  alias = "east1"
}

provider "nifcloud" {
  region = "jp-west-1"
  alias = "west1"
}
