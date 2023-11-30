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
  availability_domains = {
    # AMD is available only in AD 1
    # "amd" = ["QjOL:EU-FRANKFURT-1-AD-1"]
    "amd" = keys(var.oci_availability_domains)[0]

    # Randomly picked Availability Domain for Ampere A1
    "ampere_a1" = coalesce(var.ampere_a1_availability_domain, one(random_shuffle.ampere_a1_ad.result))
  }

  fault_domains = {
    # AMD is available only within FD 1
    "amd" = [data.oci_identity_fault_domains.fd[local.availability_domains["amd"]].fault_domains[0].name]

    # Randomly picking two fault domains from the chosen AD
    "ampere_a1" = random_shuffle.ampere_a1_fd.result
  }

  compute_freeform_tags = {
    "CreatedWith"     = "Terraform"
    "ResourcesFamily" = "K3s"
  }
  freeform_tags = merge(var.shared_freeform_tags, local.compute_freeform_tags)

  node_role = var.k3s_tags["K3s-NodeInfo.NodeRole"]
  is_master = local.node_role == "master" ? true : false
}
