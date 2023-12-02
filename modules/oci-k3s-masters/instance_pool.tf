# Variables

variable "ampere_a1_allocation_schema" {
  type = map(number)
  validation {
    condition     = length([for class, count in var.ampere_a1_allocation_schema : class if contains(["wood", "copper", "silver", "gold", "platinum", "diamond"], class)]) == length(keys(var.ampere_a1_allocation_schema))
    error_message = "Please specify one of \"wood\", \"copper\", \"silver\", \"gold\", \"platinum\" or \"diamond\" as keys."
  }
  # TODO: count should be at least 1
  # validation {
  #   condition     = length([for class, params in var.ampere_a1_allocation_schema : class if contains(["wood", "copper", "silver", "gold", "platinum", "diamond"], class)]) > 0
  #   error_message = "Your map must describe at least one of the four tiers."
  # }
  # validation {
  #   condition = setsubtract([for class, params in var.ampere_a1_allocation_schema : [
  #     for item in params : item if contains(["master", "worker"], item.role) && item.count > 0
  #   ]], values(var.ampere_a1_allocation_schema)) == []
  #   error_message = "Please include only positive count values and \"master\" or \"worker\" types."
  # }
  description = "The resource allocation schema for flexible Ampere A1 instances"
}

# Locals

locals {
  ampere_a1_tiers = {
    "wood" = {
      cpu    = 1
      memory = 2
    }
    "copper" = {
      cpu    = 2
      memory = 4
    }
    "silver" = {
      cpu    = 1
      memory = 6
    }
    "gold" = {
      cpu    = 1
      memory = 8
    }
    "platinum" = {
      cpu    = 1
      memory = 10
    }
    "diamond" = {
      cpu    = 2
      memory = 12
    }
  }
}

# Data Sources

data "oci_core_instance_pool_instances" "instance_pool_instances" {
  for_each = var.ampere_a1_allocation_schema

  compartment_id   = var.oci_compartment_id
  instance_pool_id = oci_core_instance_pool.ampere_a1[each.key].id
}

# Resources

# NOTE: Always Free tier won't allow more than 2 Instance Pools; please remember this when creating multiple pools
resource "oci_core_instance_pool" "ampere_a1" {
  for_each = var.ampere_a1_allocation_schema

  compartment_id = var.oci_compartment_id
  freeform_tags  = merge(var.shared_freeform_tags, local.masters_freeform_tags)

  instance_configuration_id = oci_core_instance_configuration.configuration_ampere_a1[each.key].id
  display_name              = format("k3s_masters_ampere_a1_%s", each.key)
  size                      = each.value

  placement_configurations {
    primary_subnet_id   = var.oci_vcn_subnet_id
    availability_domain = local.availability_domains.ampere_a1
    fault_domains       = local.fault_domains.ampere_a1
  }

  load_balancers {
    backend_set_name = one(oci_load_balancer_backend_set.masters_backend_set[*].name)
    load_balancer_id = one(oci_load_balancer_load_balancer.k3s_apiserver_load_balancer[*].id)
    port             = 6443
    vnic_selection   = "PrimaryVnic"
  }

}

# Outputs

output "instances_ids" {
  value = toset(flatten([
    for schema in data.oci_core_instance_pool_instances.instance_pool_instances :
    [for element in schema.instances : element.id if element.state == "Running"]
  ]))
  description = "A set of IDs of the provisioned instances in state 'Running'"
}
