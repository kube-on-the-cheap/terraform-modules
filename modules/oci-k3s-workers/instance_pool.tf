# NOTE: Always Free tier won't allow more than 2 Instance Pools; please remember this when creating multiple pools

resource "oci_core_instance_pool" "ampere_a1" {
  for_each = var.ampere_a1_allocation_schema

  compartment_id = var.oci_compartment_id
  freeform_tags  = merge(var.shared_freeform_tags, local.compute_freeform_tags)

  instance_configuration_id = oci_core_instance_configuration.configuration_ampere_a1[each.key].id
  display_name              = format("k3s_%ss_ampere_a1_%s", local.node_role, each.key)
  size                      = each.value
  placement_configurations {
    primary_subnet_id   = var.oci_vcn_subnet_id
    availability_domain = local.availability_domains.ampere_a1
    fault_domains       = local.fault_domains.ampere_a1
  }
  dynamic "load_balancers" {
    # Actual for_each content doesn't matter, the goal is to prevent creation of a backend set for workers
    for_each = local.is_master ? { "create_master_lb_backend_set" : true } : {}

    content {
      backend_set_name = one(oci_load_balancer_backend_set.masters_backend_set[*].name)
      load_balancer_id = one(oci_load_balancer_load_balancer.k3s_apiserver_load_balancer[*].id)
      port             = 6443
      vnic_selection   = "PrimaryVnic"
    }
  }
}
