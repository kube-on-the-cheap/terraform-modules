variable "oci_compartment_id" {
  type        = string
  description = "The Compartment ID under which to provision resources"
}

variable "oci_tenancy_id" {
  type        = string
  description = "The Compartment ID under which to provision resources"
}

variable "oci_vcn_subnet_id" {
  type        = string
  description = "The VCN subnet to provision Compute resources in"
}

variable "shared_freeform_tags" {
  type        = map(string)
  description = "A map of shared freeform tags"
  default     = {}
}

variable "ampere_a1_availability_domain" {
  type        = string
  description = "If set, use this AD instead of a random one"
  default     = ""
}
