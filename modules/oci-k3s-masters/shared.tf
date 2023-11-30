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
  node_role = var.k3s_tags["K3s-NodeInfo.NodeRole"]
}
