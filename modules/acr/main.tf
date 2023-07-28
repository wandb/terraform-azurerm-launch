resource "azurerm_container_registry" "acr" {
  name                      = var.registry_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  sku                       = var.sku
  admin_enabled             = var.admin_enabled
  network_rule_set          = var.network_rule_set
  quarantine_policy_enabled = var.quarantine_policy_enabled

  trust_policy {
    enabled = var.trust_policy_enabled
  }

  retention_policy {
    days    = var.retention_policy_days
    enabled = var.retention_policy_enabled
  }

  tags = var.tags
}
