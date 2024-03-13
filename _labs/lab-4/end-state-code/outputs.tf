locals {
  for_each    = { for k, v in azurerm_linux_web_app.app : k => v.id }
  count       = { for k, v in azurerm_storage_account.count : k => v.id }
  conditional = { for k, v in azurerm_storage_account.conditional : k => v.id }
}

output "for_each" {
  value = local.for_each
}

output "count" {
  value = local.count
}

output "conditional" {
  value = local.conditional
}