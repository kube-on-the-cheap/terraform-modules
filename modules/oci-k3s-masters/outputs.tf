output "rsa_private_key" {
  value       = tls_private_key.root_ssh_key.private_key_pem_pkcs8
  description = "The RSA key used to connect to the instances via SSH"
  sensitive   = true
}

output "rsa_public_key" {
  value = {
    pem     = tls_private_key.root_ssh_key.public_key_pem
    openssh = tls_private_key.root_ssh_key.public_key_openssh
  }
  description = "The RSA public key used to connect to the instances via SSH"
}

data "oci_objectstorage_namespace" "namespace" {
  compartment_id = var.oci_tenancy_id
}

# TODO: wait until the file is uploaded to fetch it
data "oci_objectstorage_object" "kubeconfig" {
  bucket    = "k3s_kubeconfig"
  namespace = data.oci_objectstorage_namespace.namespace.namespace
  object    = ".kube/config"
  # depends_on = [
  #   time_sleep.instance_pool_completion.instance_pool_config
  # ]
}

output "kubeconfig" {
  sensitive   = true
  value       = data.oci_objectstorage_object.kubeconfig.content
  description = "The K3s cluster administrative Kubeconfig"
}

output "ampere_a1_availability_domain" {
  value       = local.availability_domains["ampere_a1"]
  description = "The AD the master nodes are located in"
}
