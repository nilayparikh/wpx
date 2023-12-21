resource "azurerm_mysql_flexible_server" "main" {
  name                = module.naming.mysql_server.name
  location            = var.region.qualified_name
  resource_group_name = azurerm_resource_group.main.name

  administrator_login    = "admin123"
  administrator_password = "NPkksdf££$23lk"

  backup_retention_days        = var.mysql.backup.retention_days
  geo_redundant_backup_enabled = var.mysql.backup.geo_redundant_enabled

  delegated_subnet_id = azurerm_subnet.public.id

  sku_name = var.mysql.sku_name
  version  = var.mysql.version
  zone     = var.mysql.zone_redundant.id

  dynamic "high_availability" {
    for_each = var.mysql.zone_redundant.enable ? [1] : []
    content {
      mode                      = "ZoneRedundant"
      standby_availability_zone = each.value.id
    }
  }

  storage {
    iops    = var.mysql.storage.iops
    size_gb = var.mysql.storage.size
  }

  tags = local.default_tags
}

resource "azurerm_mysql_flexible_database" "main" {
  for_each = { for wp in var.sites : wp.name => wp }

  name                = each.key
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb3"
  collation           = "utf8mb3_unicode_ci"
}
