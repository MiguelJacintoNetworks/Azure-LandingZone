terraform {
  required_version = ">= 1.8.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }

    msgraph = {
      source  = "microsoft/msgraph"
      version = "~> 0.3.0"
    }
  }
}