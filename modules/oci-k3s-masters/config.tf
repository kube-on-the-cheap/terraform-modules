# Variables

variable "cloud_init_config" {
  description = "The init.cfg templated file content"
  type        = string
}

variable "cloud_init_script" {
  description = "The init.cfg templated file content"
  type        = string
}

variable "k3s_tags_config" {
  type        = map(string)
  description = "A map of defined tags to apply"
}

variable "k3s_tags_secrets" {
  type        = map(string)
  description = "A map of secret tags to apply"
}

# Data Sources

data "cloudinit_config" "cloudinit" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = var.cloud_init_config
  }

  part {
    content_type = "text/x-shellscript"
    content      = var.cloud_init_script
  }
}

# Resources

resource "tls_private_key" "root_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "oci_core_instance_configuration" "configuration_ampere_a1" {
  for_each = var.ampere_a1_allocation_schema

  compartment_id = var.oci_compartment_id
  freeform_tags  = local.freeform_tags

  display_name = format("K3s Masters - Ampere A1 - %s tier", each.key)
  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = var.oci_compartment_id
      freeform_tags  = local.freeform_tags
      defined_tags   = local.k3s_tags

      display_name        = format("k3s-masters-ampere-a1-%s", each.key)
      availability_domain = local.availability_domains.ampere_a1
      create_vnic_details {
        assign_private_dns_record = true
        assign_public_ip          = true
        freeform_tags             = local.freeform_tags
        # TODO: modify NSGs to ensure proper hardening
        nsg_ids = [
          var.oci_network_security_groups["permit_ssh"],
          var.oci_network_security_groups["permit_apiserver"]
        ]
        subnet_id = var.oci_vcn_subnet_id
      }
      instance_options {
        are_legacy_imds_endpoints_disabled = true
      }
      agent_config {
        is_management_disabled = "false"
        is_monitoring_disabled = "false"

        plugins_config {
          desired_state = "DISABLED"
          name          = "Vulnerability Scanning"
        }

        plugins_config {
          desired_state = "ENABLED"
          name          = "Bastion"
        }
      }

      metadata = {
        "ssh_authorized_keys" = tls_private_key.root_ssh_key.public_key_openssh
        "user_data"           = data.cloudinit_config.cloudinit.rendered
      }
      extended_metadata = {}

      shape = local.free_shapes.ampere_a1
      shape_config {
        memory_in_gbs = local.ampere_a1_tiers[each.key].memory
        ocpus         = local.ampere_a1_tiers[each.key].cpu
      }
      source_details {
        source_type             = "image"
        boot_volume_size_in_gbs = 50
        image_id                = data.oci_core_images.ampere_a1_instances.images[0].id
      }
    }
  }

  lifecycle {
    ignore_changes = [instance_details[0].launch_details[0].source_details[0].image_id]
  }

  # NOTE: This action will fail when reaching the Always Free tier limit.
  #       We can't update an attached configuration, we can't provision a new one if we're going over quota.
  # lifecycle {
  #   create_before_destroy = true
  # }
}
