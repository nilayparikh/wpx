resource "azurerm_virtual_network" "main" {
  name                = module.naming.virtual_network.name
  address_space       = [var.address_space]
  location            = var.region.qualified_name
  resource_group_name = azurerm_resource_group.main.name

  tags = local.default_tags
}

resource "azurerm_subnet" "public" {
  name                 = "public"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["${cidrsubnet(var.address_space, 1, 0)}"]

  service_endpoints = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["${cidrsubnet(var.address_space, 1, 1)}"]
}
