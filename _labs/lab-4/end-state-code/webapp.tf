resource "azurerm_service_plan" "asp" {
  name                = module.naming.app_service_plan.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.web_app.service_plan_sku
}

resource "azurerm_linux_web_app" "app" {
  for_each = { for o in var.web_app.web_apps : o.name => o }

  service_plan_id     = azurerm_service_plan.asp.id
  resource_group_name = azurerm_service_plan.asp.resource_group_name
  location            = azurerm_service_plan.asp.location

  name         = each.value.name
  app_settings = merge({}, each.value.app_settings)

  site_config {
    dynamic "application_stack" {
      for_each = each.value.docker_image_name != null ? [1] : []
      content {
        docker_image_name   = each.value.docker_image_name
        docker_registry_url = each.value.docker_registry_url
      }
    }
  }
}