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
  subscription_id = "ee7ef8c3-5d6f-46ea-bafc-50fdddaf5355"
}

resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = "australiaEast"
}