resource "azurerm_storage_account" "launch" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.tags
}

resource "azurerm_storage_container" "build_context_store" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.launch.name
  container_access_type = var.container_access_type
}
