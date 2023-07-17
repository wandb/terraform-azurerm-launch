resource "azurerm_resource_group" "launch" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_resource_group" "launch" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  resource_group_name     = var.create_resource_group ? azurerm_resource_group.launch[0].name : data.azurerm_resource_group.launch[0].name
  resource_group_location = var.create_resource_group ? azurerm_resource_group.launch[0].location : data.azurerm_resource_group.launch[0].location
}

module "blob" {
  source               = "./modules/blob"
  storage_account_name = "${var.namespace}${var.prefix}sa" #only lowercase letters and numbers
  container_name       = "${var.namespace}${var.prefix}"   #only lowercase letters and numbers
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
}

module "acr" {
  source              = "./modules/acr"
  registry_name       = "${var.namespace}${var.prefix}reg" #only lowercase letters and numbers
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  tags                = var.tags
}

module "workload_identity" {
  source              = "./modules/workload-identity"
  identity_name       = "${var.namespace}-${var.prefix}-workload-id"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location

  oidc_issuer        = var.aks_oidc_issuer_url
  kubelet_identity   = var.kubelet_identity
  storage_account_id = module.blob.storage_account_id
  acr_id             = module.acr.azurerm_container_registry_id
}

locals {
  container_registry_uri  = "${module.acr.azurerm_container_registry_uri}${var.namespace}-${var.prefix}"
  build_context_store_uri = module.blob.build_context_store_uri

  service_account_annotations = {
    "azure.workload.identity/client-id" = module.workload_identity.workload_identity_client_id
  }

  agent_labels = {
    "azure.workload.identity/use" = "true"
  }

  queues = join(",", var.queues)

  launch_config = templatefile("${path.module}/templates/launch-config.yaml.tpl", {
    queues                  = local.queues
    entity                  = var.entity
    max_jobs                = var.max_jobs
    max_schedulers          = var.max_schedulers
    uri                     = local.container_registry_uri
    build_context_store_uri = local.build_context_store_uri
  })
}

module "launch" {
  source  = "wandb/launch/helm"
  version = "1.0.1"

  # TF defined inputs
  service_account_annotations = local.service_account_annotations
  azure_storage_access_key    = module.blob.storage_access_key
  agent_labels                = local.agent_labels

  # Launch Config 
  launch_config = local.launch_config

  # Required to be defined inputs
  helm_chart_version = var.helm_chart_version
  agent_api_key      = var.agent_api_key
  agent_image        = var.agent_image
  base_url           = var.base_url

  additional_target_namespaces = var.additional_target_namespaces

  # Optional 
  helm_repository         = var.helm_repository
  agent_image_pull_policy = var.agent_image_pull_policy
  namespace               = var.k8s_namespace
  volcano                 = var.volcano
  git_creds               = var.git_creds
}
