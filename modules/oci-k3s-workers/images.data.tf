locals {
  # https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm#freetier_topic_Always_Free_Resources_Infrastructure
  free_shapes = {
    amd       = "VM.Standard.E2.1.Micro"
    ampere_a1 = "VM.Standard.A1.Flex"
  }
  os = {
    name    = "Canonical Ubuntu"
    version = "22.04 Minimal"
  }
}

data "oci_core_images" "amd_instances" {
  compartment_id = var.oci_compartment_id

  # If sorting by display_name, it's the only accepted param
  # display_name             = var.image_display_name
  operating_system         = local.os.name
  operating_system_version = local.os.version
  shape                    = local.free_shapes.amd
  state                    = "AVAILABLE"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_images" "ampere_a1_instances" {
  compartment_id = var.oci_compartment_id

  # If sorting by display_name, it's the only accepted param
  # display_name             = var.image_display_name
  operating_system         = local.os.name
  operating_system_version = format("%s aarch64", local.os.version)
  shape                    = local.free_shapes.ampere_a1
  state                    = "AVAILABLE"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

output "images" {
  value = {
    amd       = data.oci_core_images.amd_instances.images,
    ampere_a1 = data.oci_core_images.ampere_a1_instances.images
  }
}
