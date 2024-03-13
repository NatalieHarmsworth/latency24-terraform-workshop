# Lab 4 - Looping back into the Code

1. Add to the `variable` block, `web_app`.

```hcl [16-20]
variable "subscription_id" {
  description = "Subscription to deploy all resources into."
  type        = string
}

variable "location" {
  description = "Location to deploy all resources to."
  type        = string
  default     = "australiaEast"
}

variable "web_app" {
  description = <<EOT
 Object for the configuration of the Web App and the Service Plan
 `service_plan_sku` - SKU for the Service Plan. Check [azurerm documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan#sku_name) for values.
 `web_apps` - List of Web Apps to deploy to this service plan.
  `name` - Name of the Web App. Must be globally unique.
  `docker_image_name` - Name of the Docker Image to use. If not supplied, default Web App will be deployed.
  `docker_registry_url` - Docker Registry containing the Image to use.
  `app_settings` -  A map of app settings to use for the Web App. Overrides duplicate app_settings keys found in web_app.tf
 EOT
  type = object({
    service_plan_sku = optional(string, "B1")
    web_apps = list(object({
      name              = string
      docker_image_name = optional(string)
      docker_registry_url = optional(string,
      "https://docker.io")
      app_settings = optional(map(string))
    }))
  })
  default = {}
}

variable "naming" {
  description = <<EOT
 Strings used to create the names for all resources. check [locals.tf](./locals.tf) for convention.
 - org_code - The organization code. Example: "lat"
 - env_code -  The environment code. Example: "dev"
 - loc_code - The location code. Example: "aue"
 - wrk_code - The workload code. Example: "webapp"
 - lucky_numbers - List of numbers. Example: [15,03,2024]
    EOT
  type = object({
    org_code      = string
    env_code      = string
    loc_code      = string
    wrk_code      = string
    lucky_numbers = list(number)
  })
}
```

```hcl [23-35]
# variables.tf
variable "subscription_id" {
  description = "Subscription to deploy all resources into."
  type        = string
}

variable "location" {
  description = "Location to deploy all resources to."
  type        = string
  default     = "australiaEast"
}

variable "web_app" {
  description = <<EOT
 Object for the configuration of the Web App and the Service Plan
 `service_plan_sku` - SKU for the Service Plan. Check [azurerm documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan#sku_name) for values.
 `web_apps` - List of Web Apps to deploy to this service plan.
  `name` - Name of the Web App. Must be globally unique.
  `docker_image_name` - Name of the Docker Image to use. If not supplied, default Web App will be deployed.
  `docker_registry_url` - Docker Registry containing the Image to use.
  `app_settings` -  A map of app settings to use for the Web App. Overrides duplicate app_settings keys found in web_app.tf
 EOT
  type = object({
    service_plan_sku = optional(string, "B1")
    web_apps = list(object({
      name              = string
      docker_image_name = optional(string)
      docker_registry_url = optional(string,
      "https://docker.io")
      app_settings = optional(map(string))
    }))
  })
  default = {
    web_apps = []
  }
}

variable "naming" {
  description = <<EOT
 Strings used to create the names for all resources. check [locals.tf](./locals.tf) for convention.
 - org_code - The organization code. Example: "lat"
 - env_code -  The environment code. Example: "dev"
 - loc_code - The location code. Example: "aue"
 - wrk_code - The workload code. Example: "webapp"
 - lucky_numbers - List of numbers. Example: [15,03,2024]
    EOT
  type = object({
    org_code      = string
    env_code      = string
    loc_code      = string
    wrk_code      = string
    lucky_numbers = list(number)
  })
}
```

> [!note]  
>
> `optional()` is super useful but just keep in mind its default is `null`, but you can set a different default by going `optional({type}, {default})`.

2. Update `webapp.tf`

```hcl [9-28]
# webapp.tf
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
```

```hcl [19-28]
# webapp.tf
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
```

3. Add to the `variables/dev.tfvars` file, and do some `plan`, `apply` and `show`. See what you can find.  
  
`docker_image_name = "ryanroyals/helloworldenv:latest"`

4. Create `count.tf`, and add a `azurerm_storage_account` with a `count` loop.

```hcl [2-14]
# count.tf
variable "count_storage" {
 description = "Number of Storage Accounts to deploy."
 type = number
}
resource "azurerm_storage_account" "count" {
  count = var.count_storage

  name = "${module.naming.storage_account.name}${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

5. Add to the `variables/dev.tfvars` file, and do some `plan`, `apply` and `show`. See what you can find.

6. Create a `conditional.tf` and add a `variable` and a `azurerm_storage_account`.

```hcl [2-14]
# conditional.tf
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
```

7. Add to the `variables/dev.tfvars` file, and do some `plan`, `apply` and `show`. See what you can find.

8. Create `outputs.tf` and add a `locals`, and a `output`.

```hcl [2-15]
# outputs.tf
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
```
