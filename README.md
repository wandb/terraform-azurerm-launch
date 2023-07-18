# terraform-azurerm-launch

`terraform-azurerm-launch` is a Terraform module designed to deploy `wandb launch` into an exsisting Azure Kubernetes Service (AKS) cluster. This module simplifies the process of setting up and managing the cloud resources and helm deployment of `wandb launch` in Azure Cloud environments.

## Prerequisites

- Terraform v1.0+
- Azure subscription
- Azure CLI
- kubectl
- Exsisting AKS cluster
- Helm v3+


**Note** The target AKS cluster should have
```hcl
  workload_identity_enabled = true
  oidc_issuer_enabled       = true
```
enabled in order to configure the [Azure Workload Identity](`https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster`) needed to pull and push build contexts to and from the Azure Container Registry and Blob Storage Container.

If this needs to be confugured manually, please run:
```bash
az aks update -g ${resource_group} -n ${aks_cluster} --enable-oidc-issuer --enable-workload-identity 
```

## Usage

To use the `terraform-azurerm-launch` module, add the following code to your Terraform configuration.

1. Create a `.tfvars` file and fill out the required fields and some of the optional fields if required. Here's an example:

```hcl
subscription_id    = "<azure-subscription-id>"
namespace          = "my-namespace"
location           = "eastus"
helm_chart_version = "0.8.0"
agent_api_key      = "<wandb-api-key>"
agent_image        = "wandb/launch-agent-dev:f0cf9e0a"
base_url           = "<wandb-api-url>"
queues             = ["<launch-queue>"]
entity             = "<team-entity>"
...
```

2. Use the `terraform-azurerm-launch` module in your Terraform configuration. The [examples exsisting-aks-cluster](./example/exsisting-aks-launch/main.tf) is a good place to start:

```hcl
module "launch" {
  source  = "wandb/launch/azurerm"
  version = "1.0.0"

  # Infra variables
  subscription_id       = var.subscription_id
  namespace             = var.namespace
  prefix                = random_id.prefix.hex
  location              = data.azurerm_resource_group.existing.location
  resource_group_name   = var.resource_group_name
  aks_oidc_issuer_url   = local.oidc_issuer_url
  kubelet_identity      = local.kubelet_identity
  create_resource_group = var.create_resource_group

  # launch-helm variables
  helm_repository              = var.helm_repository
  helm_chart_version           = var.helm_chart_version
  agent_api_key                = var.agent_api_key
  agent_image                  = var.agent_image
  agent_image_pull_policy      = var.agent_image_pull_policy
  agent_resources              = var.agent_resources
  k8s_namespace                = var.k8s_namespace
  node_count                   = var.node_count
  base_url                     = var.base_url
  volcano                      = var.volcano
  git_creds                    = var.git_creds
  additional_target_namespaces = var.additional_target_namespaces

  # launch_config variables
  queues         = var.queues
  entity         = var.entity
  max_jobs       = var.max_jobs
  max_schedulers = var.max_schedulers

  tags = var.tags
}
```

3. Run `terraform init` to initialize the Terraform working directory.
4. Run `terraform apply -var-file="your.tfvars"` to apply the changes.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.64 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.10 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.21 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.64 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acr"></a> [acr](#module\_acr) | ./modules/acr | n/a |
| <a name="module_blob"></a> [blob](#module\_blob) | ./modules/blob | n/a |
| <a name="module_launch"></a> [launch](#module\_launch) | wandb/launch/helm | 1.0.1 |
| <a name="module_workload_identity"></a> [workload\_identity](#module\_workload\_identity) | ./modules/workload-identity | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.launch](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_target_namespaces"></a> [additional\_target\_namespaces](#input\_additional\_target\_namespaces) | Additional target namespaces that the launch agent can deploy into | `list(string)` | <pre>[<br>  "wandb",<br>  "default"<br>]</pre> | no |
| <a name="input_agent_api_key"></a> [agent\_api\_key](#input\_agent\_api\_key) | The Weights and Biases team service account API key | `string` | n/a | yes |
| <a name="input_agent_image"></a> [agent\_image](#input\_agent\_image) | Container image to use for the agent | `string` | n/a | yes |
| <a name="input_agent_image_pull_policy"></a> [agent\_image\_pull\_policy](#input\_agent\_image\_pull\_policy) | Image pull policy for agent image | `string` | `"Always"` | no |
| <a name="input_agent_resources"></a> [agent\_resources](#input\_agent\_resources) | Resources block for the agent spec | <pre>object({<br>    limits = map(string)<br>  })</pre> | <pre>{<br>  "limits": {<br>    "cpu": "1",<br>    "memory": "1Gi"<br>  }<br>}</pre> | no |
| <a name="input_aks_oidc_issuer_url"></a> [aks\_oidc\_issuer\_url](#input\_aks\_oidc\_issuer\_url) | The URL of the OpenID issuer, only applicable when using Azure AD pod identity | `string` | n/a | yes |
| <a name="input_base_url"></a> [base\_url](#input\_base\_url) | W&B api url | `string` | n/a | yes |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | The 'create\_resource\_group' variable is a boolean flag that determines whether to create a resource group (RG) in Azure or use an exsisting one. | `bool` | `true` | no |
| <a name="input_entity"></a> [entity](#input\_entity) | The team entity to be used | `string` | n/a | yes |
| <a name="input_git_creds"></a> [git\_creds](#input\_git\_creds) | The contents of a git credentials file | `string` | `""` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Helm chart version | `string` | n/a | yes |
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Helm repository URL | `string` | `"https://wandb.github.io/helm-charts"` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Namespace to deploy launch agent into | `string` | `"wandb"` | no |
| <a name="input_kubelet_identity"></a> [kubelet\_identity](#input\_kubelet\_identity) | The kubelet identity to use for the acr pull federation | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location refers to the physical region or datacenter where your Azure resources are deployed. | `string` | n/a | yes |
| <a name="input_max_jobs"></a> [max\_jobs](#input\_max\_jobs) | The maximum number of jobs | `string` | `"5"` | no |
| <a name="input_max_schedulers"></a> [max\_schedulers](#input\_max\_schedulers) | The maximum number of schedulers | `string` | `"8"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Unique namespace name for your resources | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for your resources | `string` | n/a | yes |
| <a name="input_queues"></a> [queues](#input\_queues) | The list of queues to be used | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be assigned to the project resources. | `map(string)` | `{}` | no |
| <a name="input_volcano"></a> [volcano](#input\_volcano) | Set to false to disable volcano install | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_release_status"></a> [helm\_release\_status](#output\_helm\_release\_status) | Status of the helm release |

<!-- END_TF_DOCS -->

## Examples

For more examples on how to use the `terraform-azurerm-launch` module, please refer to the [examples](./examples) directory.

## Contributing

We welcome contributions to the `terraform-azurerm-launch` module. Please submit a pull request with your changes, and ensure that your code follows the existing code style and conventions.