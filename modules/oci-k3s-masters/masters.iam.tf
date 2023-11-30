# Variables

variable "k3s_bucket_names" {
  type        = set(string)
  description = "The Object Storage bucket names used by the cluster"
  default     = []
}

# Resources

resource "oci_identity_policy" "k3s_allow_masters_write_buckets" {
  for_each = var.k3s_bucket_names

  compartment_id = var.oci_tenancy_id

  name        = "allow_${oci_identity_dynamic_group.k3s_nodes.name}_write_bucket_${each.value}"
  description = "Policy to allow K3s master nodes to access bucket ${each.value}"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_nodes.name} to manage objects in compartment id ${var.oci_compartment_id} where all {target.bucket.name = '${each.value}'}"
  ]

  freeform_tags = local.masters_freeform_tags
}
