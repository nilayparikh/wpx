variable "project" {
  type        = string
  description = "The project name"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project name must be lowercase alphanumeric characters or hyphens"
  }
}

variable "env" {
  type        = string
  description = "The environment"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.env))
    error_message = "Environment must be lowercase alphanumeric characters or hyphens"
  }
}

variable "region" {
  type = object({
    qualified_name = string
    short_name     = string
  })
  description = "The region"
  validation {
    condition     = contains(["australiacentral", "australiacentral2", "australiaeast", "australiasoutheast", "brazilsouth", "brazilsoutheast", "brazilus", "canadacentral", "canadaeast", "centralindia", "centralus", "centraluseuap", "eastasia", "eastus", "eastus2", "eastus2euap", "francecentral", "francesouth", "germanynorth", "germanywestcentral", "israelcentral", "italynorth", "japaneast", "japanwest", "jioindiacentral", "jioindiawest", "koreacentral", "koreasouth", "malaysiasouth", "mexicocentral", "northcentralus", "northeurope", "norwayeast", "norwaywest", "polandcentral", "qatarcentral", "southafricanorth", "southafricawest", "southcentralus", "southeastasia", "southindia", "spaincentral", "swedencentral", "swedensouth", "switzerlandnorth", "switzerlandwest", "uaecentral", "uaenorth", "uksouth", "ukwest", "westcentralus", "westeurope", "westindia", "westus", "westus2", "westus3", "austriaeast", "chilecentral", "eastusslv", "israelnorthwest", "malaysiawest", "newzealandnorth", "northeuropefoundational", "taiwannorth", "taiwannorthwest"], var.region.qualified_name) && can(regex("^[a-z0-9]+$", var.region.short_name))
    error_message = "Region properties must be lowercase alphanumeric characters or hyphens and qualified_name must be a valid region"
  }
}

variable "logs" {
  type = object({
    sku               = string
    retention_in_days = number
  })

  default = {
    sku               = "Free"
    retention_in_days = 7
  }

  validation {
    condition     = contains(["Free", "PerNode", "Premium", "Standard", "Standalone", "Unlimited", "CapacityReservation", "PerGB2018"], var.logs.sku)
    error_message = "The sku must be one of the following: Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, PerGB2018."
  }

  validation {
    condition     = var.logs.sku == "Free" ? contains([7, 30], var.logs.retention_in_days) : (var.logs.retention_in_days >= 7 && var.logs.retention_in_days <= 730)
    error_message = "If sku is Free, retention_in_days must be 7 or 30. Otherwise, it must be between 7 and 730."
  }
}

variable "sites" {
  type = list(object({
    name = string
  }))

  validation {
    condition     = alltrue([for wp in var.sites : can(regex("^[a-zA-Z0-9_-]+$", wp.name))])
    error_message = "The name must be alphanumeric."
  }
}

variable "mysql" {
  type = object({
    sku_name = string
    version  = string
    zone_redundant = object({
      enable = bool
      id     = string
    })
    storage = object({
      auto_grow  = bool
      io_scaling = bool
      iops       = number
      size       = number
    })
    backup = object({
      retention_days        = number
      geo_redundant_enabled = bool
    })
  })

  default = {
    sku_name = "Standard_B1ms"
    version  = "8.0.21"
    zone_redundant = {
      enable = false
      id     = "1"
    }
    storage = {
      auto_grow  = true
      io_scaling = true
      iops       = 360
      size       = 20
    }
    backup = {
      retention_days        = 3
      geo_redundant_enabled = false
    }
  }

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+$", var.mysql.version))
    error_message = "The version must be in the format of X.Y.Z where X, Y, and Z are non-negative integers."
  }

  validation {
    condition     = contains(["1", "2", "3"], var.mysql.zone_redundant.id)
    error_message = "The zone_redundant id must be one of the following: 1, 2, 3."
  }

  validation {
    condition     = var.mysql.storage.iops >= 260 && var.mysql.storage.iops <= 20000
    error_message = "The iops must be between 260 and 20000."
  }

  validation {
    condition     = var.mysql.storage.size >= 20 && var.mysql.storage.size <= 16384
    error_message = "The size must be between 20 and 16384."
  }

  validation {
    condition     = var.mysql.backup.retention_days >= 0
    error_message = "The retention_days must be a non-negative integer."
  }
}

variable "container_app" {
  type = object({
    storage_share_name  = string
    storage_share_quota = number
  })
  default = {
    storage_share_name  = "default"
    storage_share_quota = 5
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.container_app.storage_share_name))
    error_message = "The storage_share_name must be alphanumeric."
  }

  validation {
    condition     = var.container_app.storage_share_quota > 1
    error_message = "The storage_share_quota must be greater than 1."
  }
}

variable "address_space" {
  type        = string
  description = "The address space for the Azure VNet"
  validation {
    condition     = can(regex("^(10|172|192)\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})$", var.address_space))
    error_message = "Address space must be in the format of '10.x.x.x/xx', '172.x.x.x/xx', or '192.x.x.x/xx'"
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[a-zA-Z0-9-_]*$", k)) && can(regex("^[a-zA-Z0-9-_]*$", v))])
    error_message = "All tag keys and values must be alphanumeric characters, hyphens, or underscores. They can also be empty."
  }
}


# variable "cloudflare_api_token" {
#   type        = string
#   description = "The Cloudflare API key"
#   validation {
#     condition     = can(regex("^[a-zA-Z0-9-_]{40}$", var.cloudflare_api_token))
#     error_message = "Cloudflare API key must be 40 characters in length and consist of lowercase alphanumeric characters, hyphens, or underscores"
#   }
# }
