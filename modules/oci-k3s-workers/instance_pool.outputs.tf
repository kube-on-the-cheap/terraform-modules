data "oci_core_instance_pool_instances" "instance_pool_instances" {
  for_each = var.ampere_a1_allocation_schema

  compartment_id   = var.oci_compartment_id
  instance_pool_id = oci_core_instance_pool.ampere_a1[each.key].id
}

output "instances_ids" {
  value = toset(flatten([
    for schema in data.oci_core_instance_pool_instances.instance_pool_instances :
    [for element in schema.instances : element.id if element.state == "Running"]
  ]))
  description = "A set of IDs of the provisioned instances in state 'Running'"
}
