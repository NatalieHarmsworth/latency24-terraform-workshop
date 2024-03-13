variable "deploy_storage" {
  type    = bool
  default = false
}

resource "azurerm_storage_account" "conditional" {
  count = var.deploy_storage ? 1 : 0

  name                     = "${module.naming.storage_account.name}conditional"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}