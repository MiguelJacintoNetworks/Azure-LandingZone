terraform {
  required_version = ">= 1.8.0, < 2.0.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}