variable "shared_freeform_tags" {
  type        = map(string)
  description = "A map of shared freeform tags"
  default     = {}
}

locals {
  masters_freeform_tags = {
    "CreatedWith"     = "Terraform"
    "ResourcesFamily" = "K3s"
    "TerraformModule" = "oci-k3s-masters"
  }
  freeform_tags = merge(var.shared_freeform_tags, local.masters_freeform_tags)
  k3s_tags      = merge(var.k3s_tags_config, var.k3s_tags_secrets)
}
