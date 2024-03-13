variable "count_storage" {
  description = "Number of Storage Accounts to deploy."
  type        = number
}

resource "azurerm_storage_account" "count" {
  count = var.count_storage

  name                     = "${module.naming.storage_account.name}${count.index}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}