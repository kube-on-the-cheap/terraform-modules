# Resources

resource "oci_identity_dynamic_group" "k3s_masters" {
  compartment_id = var.oci_tenancy_id

  name        = "k3s_master_instances"
  description = "Dynamic group which contains all K3s master instances in this compartment"
  matching_rule = format("All { instance.compartment.id='${var.oci_compartment_id}', tag.K3s-NodeInfo.NodeRole.value = 'master' }"
  )

  freeform_tags = local.masters_freeform_tags
}

# resource "oci_identity_policy" "k3s_allow_masters_list_instances" {
#   compartment_id = var.oci_tenancy_id

#   name        = "allow_${oci_identity_dynamic_group.k3s_masters.name}_list_instances"
#   description = "Policy to allow each instance of K3s master node to read instance data"
#   statements = [
#     "allow dynamic-group ${oci_identity_dynamic_group.k3s_masters.name} to read instance in compartment id ${var.oci_compartment_id}"
#   ]

#   freeform_tags = local.masters_freeform_tags
# }

resource "oci_identity_policy" "k3s_allow_masters_update_self" {
  compartment_id = var.oci_tenancy_id

  name        = "allow_${oci_identity_dynamic_group.k3s_masters.name}_update_self"
  description = "Policy to allow each instance of K3s masters to update only itself"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_masters.name} to use instance in compartment id ${var.oci_compartment_id} where request.instance.id=target.instance.id"
  ]

  freeform_tags = local.masters_freeform_tags
}

resource "oci_identity_policy" "k3s_allow_masters_k3s_nodeinfo_tag" {
  compartment_id = var.oci_tenancy_id

  name        = "allow_${oci_identity_dynamic_group.k3s_masters.name}_defined_tags"
  description = "Policy to allow each instance of K3s masters to access defined tags"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_masters.name} to inspect tag-namespaces in tenancy",
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_masters.name} to read tag-namespaces in compartment id ${var.oci_compartment_id}",
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_masters.name} to use tag-namespaces in compartment id ${var.oci_compartment_id} where target.tag-namespace.name='K3s-NodeInfo'"
  ]

  freeform_tags = local.masters_freeform_tags
}

# resource "oci_identity_policy" "k3s_allow_masters_read_lb" {
#   compartment_id = var.oci_tenancy_id
#   name        = "allow_${oci_identity_dynamic_group.k3s_masters.name}_read_lb"
#   description = "Policy to allow K3s master nodes to read lb resources"
#   statements = [
#     "allow dynamic-group ${oci_identity_dynamic_group.k3s_masters.name} to read load-balancer in compartment id ${var.oci_compartment_id}"
#   ]

#   freeform_tags = local.masters_freeform_tags
# }

resource "oci_identity_policy" "k3s_allow_masters_read_secrets" {
  for_each = var.k3s_tags_secrets

  compartment_id = var.oci_tenancy_id

  name        = "allow_${oci_identity_dynamic_group.k3s_masters.name}_read_secret_${replace(split(".", each.key)[1], "-", "_")}"
  description = "Policy to allow K3s nodes to read secret ${split(".", each.key)[1]}"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_masters.name} to inspect vaults in compartment id ${var.oci_compartment_id}",
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_masters.name} to use secret-family in compartment id ${var.oci_compartment_id} where target.secret.id='${each.value}'"
  ]

  freeform_tags = local.masters_freeform_tags
}

# allow dynamic-group [your dynamic group name] to read instance-family in compartment [your compartment name]
# allow dynamic-group [your dynamic group name] to use virtual-network-family in compartment [your compartment name]
# allow dynamic-group [your dynamic group name] to manage load-balancers in compartment [your compartment name]

resource "oci_identity_policy" "k3s_allow_masters_ccm" {
  for_each = {
    "instance-family" : "read",
    "virtual-network-family" : "use",
    "load-balancers" : "manage"
  }

  compartment_id = var.oci_tenancy_id

  name        = "allow_${oci_identity_dynamic_group.k3s_masters.name}_${each.value}_${replace(each.key, "-", "_")}"
  description = "Policy to allow K3s master nodes to ${each.value} ${each.key}"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_masters.name} to ${each.value} ${each.key} in compartment id ${var.oci_compartment_id}"
  ]

  freeform_tags = local.masters_freeform_tags
}
