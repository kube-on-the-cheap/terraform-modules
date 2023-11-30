# Variables

variable "oci_availability_domains" {
  type        = map(string)
  description = "A list of Availability Domains for the provided Compartment"
}

variable "ampere_a1_availability_domain" {
  type        = string
  description = "If set, use this AD instead of a random one"
  default     = ""
}

# Locals

locals {
  availability_domains = {
    # AMD is available only in AD 1
    # "amd" = ["QjOL:EU-FRANKFURT-1-AD-1"]
    "amd" = keys(var.oci_availability_domains)[0]

    # Randomly picked Availability Domain for Ampere A1
    "ampere_a1" = coalesce(var.ampere_a1_availability_domain, one(random_shuffle.ampere_a1_ad.result))
  }

  fault_domains = {
    # AMD is available only within FD 1
    "amd" = [data.oci_identity_fault_domains.fd[local.availability_domains["amd"]].fault_domains[0].name]

    # Randomly picking two fault domains from the chosen AD
    "ampere_a1" = random_shuffle.ampere_a1_fd.result
  }
}

# Data Sources

data "oci_identity_fault_domains" "fd" {
  for_each = var.oci_availability_domains

  availability_domain = each.key
  compartment_id      = var.oci_compartment_id
}

# Resources

resource "random_shuffle" "ampere_a1_ad" {
  input        = keys(var.oci_availability_domains)
  result_count = 1
}

resource "random_shuffle" "ampere_a1_fd" {
  input        = data.oci_identity_fault_domains.fd[local.availability_domains["ampere_a1"]].fault_domains[*].name
  result_count = 2
}
