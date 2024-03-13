resource "azurerm_storage_account" "st" {
  name                     = join("", concat(local.prefix, ["st"], local.suffix, ["tfs"]))
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  network_rules {
    default_action = "Deny"
    ip_rules       = [data.http.current_ip.response_body]
    bypass         = ["Metrics", "AzureServices"]
  }
}

resource "azurerm_storage_container" "state" {
  name                 = "tfstate"
  storage_account_name = azurerm_storage_account.st.name
}