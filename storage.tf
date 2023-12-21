resource "azurerm_storage_account" "container_app" {
  name                = "${module.naming.storage_account.name}capp"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.region.qualified_name

  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_share" "container_app" {
  name                 = var.container_app.storage_share_name
  storage_account_name = azurerm_storage_account.container_app.name
  quota                = var.container_app.storage_share_quota
}
