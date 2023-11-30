variable "oci_availability_domains" {
  type        = map(string)
  description = "A list of Availability Domains for the provided Compartment"
}

data "oci_identity_fault_domains" "fd" {
  for_each = var.oci_availability_domains

  availability_domain = each.key
  compartment_id      = var.oci_compartment_id
}

resource "random_shuffle" "ampere_a1_ad" {
  input        = keys(var.oci_availability_domains)
  result_count = 1
}

resource "random_shuffle" "ampere_a1_fd" {
  input        = data.oci_identity_fault_domains.fd[local.availability_domains["ampere_a1"]].fault_domains[*].name
  result_count = 2
}
