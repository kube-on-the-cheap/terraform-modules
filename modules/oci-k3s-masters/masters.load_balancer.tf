# Variables

variable "oci_network_security_groups" {
  type        = map(any)
  description = "A map of available Network Security Groups"
}

# Resources

resource "oci_load_balancer_listener" "k3s_api_server_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.masters_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.k3s_apiserver_load_balancer.id
  name                     = "k3s_api_server"
  port                     = 6443
  protocol                 = "TCP"

  connection_configuration {
    idle_timeout_in_seconds = 10
  }
}

resource "oci_load_balancer_backend_set" "masters_backend_set" {
  health_checker {
    protocol          = "TCP"
    interval_ms       = 10000
    timeout_in_millis = 3000
    port              = 6443
    retries           = 3
  }
  load_balancer_id = oci_load_balancer_load_balancer.k3s_apiserver_load_balancer.id
  name             = "k3s-masters"
  policy           = "LEAST_CONNECTIONS"
}

resource "oci_load_balancer_load_balancer" "k3s_apiserver_load_balancer" {
  compartment_id = var.oci_compartment_id
  freeform_tags  = merge(var.shared_freeform_tags, local.masters_freeform_tags)

  display_name = "k3s_apiserver_load_balancer"
  shape        = "flexible"
  subnet_ids   = [var.oci_vcn_subnet_id]

  ip_mode                    = "IPV4"
  is_private                 = false
  network_security_group_ids = [var.oci_network_security_groups.permit_apiserver]

  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}

# Outputs

output "oci_lb_ip" {
  value       = one([for ip in oci_load_balancer_load_balancer.k3s_apiserver_load_balancer.ip_address_details : ip.ip_address if ip.is_public])
  description = "The IP address of the provisioned API Load Balancer."
}
