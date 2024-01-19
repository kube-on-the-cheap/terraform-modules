resource "oci_identity_policy" "k3s_allow_masters_write_buckets" {
  for_each = local.is_master ? var.k3s_bucket_names : []

  compartment_id = var.oci_tenancy_id

  name        = "allow_${oci_identity_dynamic_group.k3s_nodes.name}_write_bucket_${each.value}"
  description = "Policy to allow K3s master nodes to access bucket ${each.value}"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_nodes.name} to manage objects in compartment id ${var.oci_compartment_id} where all {target.bucket.name = '${each.value}'}"
  ]

  freeform_tags = var.shared_freeform_tags
}

resource "oci_identity_policy" "k3s_allow_nodes_read_lb" {
  compartment_id = var.oci_tenancy_id
  name           = "allow_${oci_identity_dynamic_group.k3s_nodes.name}_read_lb"
  description    = "Policy to allow K3s master nodes to read lb resources"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_nodes.name} to read load-balancer in compartment id ${var.oci_compartment_id}"
  ]

  freeform_tags = var.shared_freeform_tags
}
