terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.91.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = module.naming.resource_group.name
  location = var.location
}

data "http" "current_ip" {
  url = "https://api.ipify.org"
}