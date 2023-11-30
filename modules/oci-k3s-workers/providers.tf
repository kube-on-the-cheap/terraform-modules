terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.87.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.3"
    }

  }
  required_version = "~> 1.4.0"
}
