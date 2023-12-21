terraform {
  required_version = ">= 1.5.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.82.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.2"
    }
  }
}

provider "azurerm" {
  features {}
}

# provider "cloudflare" {
#   api_token = var.cloudflare_api_token
# }

# provider "random" {}

# provider "time" {}
