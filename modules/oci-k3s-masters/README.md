# oci-compute

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
This module creates an Instance Pool dedicated to becoming either K3s masters or workers. In case of masters, a Load Balancer is provisioned to expose port 6443.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | 2.3.3 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | 4.87.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | 2.3.3 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | 4.87.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.1 |

## Resources

| Name | Type |
|------|------|
| [oci_core_instance_configuration.configuration_ampere_a1](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/core_instance_configuration) | resource |
| [oci_core_instance_pool.ampere_a1](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/core_instance_pool) | resource |
| [oci_identity_dynamic_group.k3s_nodes](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/identity_dynamic_group) | resource |
| [oci_identity_policy.k3s_allow_masters_write_buckets](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/identity_policy) | resource |
| [oci_identity_policy.k3s_allow_nodes_ccm](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/identity_policy) | resource |
| [oci_identity_policy.k3s_allow_nodes_read_lb](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/identity_policy) | resource |
| [oci_identity_policy.k3s_allow_nodes_read_secrets](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/identity_policy) | resource |
| [oci_identity_policy.k3s_allow_nodes_update_self](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/identity_policy) | resource |
| [oci_load_balancer_backend_set.masters_backend_set](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/load_balancer_backend_set) | resource |
| [oci_load_balancer_listener.k3s_api_server_listener](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/load_balancer_listener) | resource |
| [oci_load_balancer_load_balancer.k3s_apiserver_load_balancer](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/resources/load_balancer_load_balancer) | resource |
| [random_shuffle.ampere_a1_ad](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/shuffle) | resource |
| [random_shuffle.ampere_a1_fd](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/shuffle) | resource |
| [tls_private_key.root_ssh_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.1/docs/resources/private_key) | resource |
| [cloudinit_config.cloudinit](https://registry.terraform.io/providers/hashicorp/cloudinit/2.3.3/docs/data-sources/config) | data source |
| [oci_core_images.amd_instances](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/data-sources/core_images) | data source |
| [oci_core_images.ampere_a1_instances](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/data-sources/core_images) | data source |
| [oci_core_instance_pool_instances.instance_pool_instances](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/data-sources/core_instance_pool_instances) | data source |
| [oci_identity_fault_domains.fd](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/data-sources/identity_fault_domains) | data source |
| [oci_objectstorage_namespace.namespace](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/data-sources/objectstorage_namespace) | data source |
| [oci_objectstorage_object.kubeconfig](https://registry.terraform.io/providers/oracle/oci/4.87.0/docs/data-sources/objectstorage_object) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ampere_a1_allocation_schema"></a> [ampere\_a1\_allocation\_schema](#input\_ampere\_a1\_allocation\_schema) | The resource allocation schema for flexible Ampere A1 instances | `map(number)` | n/a | yes |
| <a name="input_ampere_a1_availability_domain"></a> [ampere\_a1\_availability\_domain](#input\_ampere\_a1\_availability\_domain) | If set, use this AD instead of a random one | `string` | `""` | no |
| <a name="input_cloud_init_config"></a> [cloud\_init\_config](#input\_cloud\_init\_config) | The init.cfg templated file content | `string` | n/a | yes |
| <a name="input_cloud_init_script"></a> [cloud\_init\_script](#input\_cloud\_init\_script) | The init.cfg templated file content | `string` | n/a | yes |
| <a name="input_k3s_bucket_names"></a> [k3s\_bucket\_names](#input\_k3s\_bucket\_names) | The Object Storage bucket names used by the cluster | `set(string)` | `[]` | no |
| <a name="input_k3s_tags"></a> [k3s\_tags](#input\_k3s\_tags) | A map of defined tags to apply | `map(string)` | n/a | yes |
| <a name="input_oci_availability_domains"></a> [oci\_availability\_domains](#input\_oci\_availability\_domains) | A list of Availability Domains for the provided Compartment | `map(string)` | n/a | yes |
| <a name="input_oci_compartment_id"></a> [oci\_compartment\_id](#input\_oci\_compartment\_id) | The Compartment ID under which to provision resources | `string` | n/a | yes |
| <a name="input_oci_network_security_groups"></a> [oci\_network\_security\_groups](#input\_oci\_network\_security\_groups) | A map of available Network Security Groups | `map(any)` | n/a | yes |
| <a name="input_oci_tenancy_id"></a> [oci\_tenancy\_id](#input\_oci\_tenancy\_id) | The Compartment ID under which to provision resources | `string` | n/a | yes |
| <a name="input_oci_vcn_subnet_id"></a> [oci\_vcn\_subnet\_id](#input\_oci\_vcn\_subnet\_id) | The VCN subnet to provision Compute resources in | `string` | n/a | yes |
| <a name="input_shared_freeform_tags"></a> [shared\_freeform\_tags](#input\_shared\_freeform\_tags) | A map of shared freeform tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ampere_a1_availability_domain"></a> [ampere\_a1\_availability\_domain](#output\_ampere\_a1\_availability\_domain) | The AD the master nodes are located in |
| <a name="output_images"></a> [images](#output\_images) | n/a |
| <a name="output_instances_ids"></a> [instances\_ids](#output\_instances\_ids) | A set of IDs of the provisioned instances in state 'Running' |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | The K3s cluster administrative Kubeconfig |
| <a name="output_oci_lb_ip"></a> [oci\_lb\_ip](#output\_oci\_lb\_ip) | The IP address of the provisioned API Load Balancer. Empty for workers. |
| <a name="output_rsa_private_key"></a> [rsa\_private\_key](#output\_rsa\_private\_key) | The RSA key used to connect to the instances via SSH |
| <a name="output_rsa_public_key"></a> [rsa\_public\_key](#output\_rsa\_public\_key) | The RSA public key used to connect to the instances via SSH |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
