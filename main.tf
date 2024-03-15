terraform {
 backend "azurerm" {} // where state file is kept - record of what is being deployed. e.g to s3. 
 required_providers {
  azurerm = {
   source = "hashicorp/azurerm"
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

resource "azurerm_service_plan" "asp" {
  name                = module.naming.app_service_plan.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.web_app.service_plan_sku
}
