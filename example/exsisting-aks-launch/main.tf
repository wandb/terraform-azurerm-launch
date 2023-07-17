provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

resource "random_id" "prefix" {
  byte_length = 2
}

data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "existing" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

locals {
  oidc_issuer_url  = data.azurerm_kubernetes_cluster.existing.oidc_issuer_url
  kubelet_identity = data.azurerm_kubernetes_cluster.existing.kubelet_identity[0].object_id

  host                   = data.azurerm_kubernetes_cluster.existing.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.existing.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.existing.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.existing.kube_config.0.cluster_ca_certificate)
}

provider "kubernetes" {
  host                   = local.host
  client_certificate     = local.client_certificate
  client_key             = local.client_key
  cluster_ca_certificate = local.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = local.host
    client_certificate     = local.client_certificate
    client_key             = local.client_key
    cluster_ca_certificate = local.cluster_ca_certificate
  }
}

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
