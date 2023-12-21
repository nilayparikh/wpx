resource "azurerm_log_analytics_workspace" "main" {
  name                = module.naming.log_analytics_workspace.name
  location            = var.region.qualified_name
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.logs.sku
  retention_in_days   = var.logs.retention_in_days
}
