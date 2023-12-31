resource "azurerm_user_assigned_identity" "workload_identity" {
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "launch_serviceaccount" {
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  audience            = var.audiences
  issuer              = var.oidc_issuer
  parent_id           = azurerm_user_assigned_identity.workload_identity.id
  subject             = var.subject
}

resource "azurerm_role_assignment" "blob_owner_role" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
}

resource "azurerm_role_assignment" "acr_contrubutor_role" {
  scope                = var.acr_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.kubelet_identity
}