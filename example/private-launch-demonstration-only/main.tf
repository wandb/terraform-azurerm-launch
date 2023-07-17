provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

resource "random_id" "prefix" {
  byte_length = 2
}

resource "azurerm_resource_group" "launch" {
  location = var.location
  name     = "${var.namespace}-${random_id.prefix.hex}-rg"
}

module "networking" {
  source              = "../../demonstration-modules/networking"
  namespace           = "${var.namespace}-${random_id.prefix.hex}"
  resource_group_name = azurerm_resource_group.launch.name
  location            = var.location

  tags       = var.tags
  depends_on = [azurerm_resource_group.launch]
}

module "aks" {
  source = "../../demonstration-modules/aks"

  name                = "${var.namespace}-${random_id.prefix.hex}-cluster"
  resource_group_name = azurerm_resource_group.launch.name
  location            = var.location
  cluster_subnet_id   = module.networking.private_subnet.id

  node_count = var.node_count

  depends_on = [
    module.networking.private_subnet
  ]
}

provider "kubernetes" {
  host                   = module.aks.cluster_host
  client_certificate     = base64decode(module.aks.cluster_client_certificate)
  client_key             = base64decode(module.aks.cluster_client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.aks.cluster_host
    client_certificate     = base64decode(module.aks.cluster_client_certificate)
    client_key             = base64decode(module.aks.cluster_client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

module "launch" {
  source = "../../"
  # version = "1.0.1"

  # Infra variables
  subscription_id       = var.subscription_id
  namespace             = var.namespace
  prefix                = random_id.prefix.hexåå
  location              = var.location
  resource_group_name   = azurerm_resource_group.launch.name
  aks_oidc_issuer_url   = module.aks.cluster_oidc_issuer_url
  kubelet_identity      = module.aks.kubelet_identity
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
