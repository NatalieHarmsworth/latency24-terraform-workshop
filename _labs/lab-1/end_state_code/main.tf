terraform {
  backend "local" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.91.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "########-####-####-####-############"
}

resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = "australiaEast"
}