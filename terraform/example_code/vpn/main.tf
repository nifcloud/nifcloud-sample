terraform {
  required_providers {
    nifcloud = {
      source  = "nifcloud/nifcloud"
      version = ">= 1.3.2"
    }
  }
}

provider "nifcloud" {
  region = "jp-west-1"
  alias = "west1"
}

provider "nifcloud" {
  region = "jp-west-2"
  alias = "west2"
}

provider "nifcloud" {
  region = "jp-east-1"
  alias = "east1"
}

