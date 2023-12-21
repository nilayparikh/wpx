resource "azurerm_container_app_environment" "main" {
  name                       = module.naming.container_app_environment.name
  location                   = var.region.qualified_name
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_container_app_environment_storage" "main" {
  name                         = "${module.naming.container_app_environment.name}-stor"
  container_app_environment_id = azurerm_container_app_environment.main.id
  account_name                 = azurerm_storage_account.container_app.name
  share_name                   = azurerm_storage_share.container_app.name
  access_key                   = azurerm_storage_account.container_app.primary_access_key
  access_mode                  = "ReadWrite"
}

# resource "azurerm_container_app" "example" {
#   name                         = "example-app"
#   container_app_environment_id = azurerm_container_app_environment.example.id
#   resource_group_name          = azurerm_resource_group.example.name
#   revision_mode                = "Single"

#   template {
#     container {
#       name   = "examplecontainerapp"
#       image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
#       cpu    = 0.25
#       memory = "0.5Gi"
#     }
#   }
# }
