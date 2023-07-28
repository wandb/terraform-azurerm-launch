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

resource "azurerm_virtual_network" "default" {
  name                = "${var.namespace}-vpc"
  location            = var.location
  resource_group_name = azurerm_resource_group.launch.name

  address_space = ["10.10.0.0/16"]

  tags = var.tags
}

resource "azurerm_subnet" "private" {
  name                 = "${var.namespace}-private"
  resource_group_name  = azurerm_resource_group.launch.name
  address_prefixes     = ["10.10.1.0/24"]
  virtual_network_name = azurerm_virtual_network.default.name
}

resource "azurerm_kubernetes_cluster" "launch" {
  name                = "${var.namespace}-${random_id.prefix.hex}-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.launch.name
  dns_prefix          = "${var.namespace}-${random_id.prefix.hex}"
  # kubernetes_version  = var.kubernetes_version #needs to be k8s 1.25+
  azure_policy_enabled      = true
  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  automatic_channel_upgrade         = "stable"
  role_based_access_control_enabled = true
  http_application_routing_enabled  = false

  default_node_pool {
    name                = "default"
    node_count          = 3
    vm_size             = "Standard_D4s_v3"
    vnet_subnet_id      = azurerm_subnet.private.id
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
    zones               = ["1", "2"]
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  tags = merge({ "launch-cluster" = "true" }, var.tags)

  lifecycle {
    ignore_changes = [
      microsoft_defender,
    ]
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.launch.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.launch.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.launch.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.launch.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.launch.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.launch.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.launch.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.launch.kube_config.0.cluster_ca_certificate)
  }
}

module "launch" {
  source = "../../"

  # Infra variables
  namespace             = var.namespace
  prefix                = random_id.prefix.hex
  location              = var.location
  resource_group_name   = azurerm_resource_group.launch.name
  aks_oidc_issuer_url   = azurerm_kubernetes_cluster.launch.oidc_issuer_url
  kubelet_identity      = azurerm_kubernetes_cluster.launch.kubelet_identity[0].object_id
  create_resource_group = var.create_resource_group

  # launch-helm variables
  helm_repository              = var.helm_repository
  helm_chart_version           = var.helm_chart_version
  agent_api_key                = var.agent_api_key
  agent_image                  = var.agent_image
  agent_image_pull_policy      = var.agent_image_pull_policy
  agent_resources              = var.agent_resources
  k8s_namespace                = var.k8s_namespace
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
