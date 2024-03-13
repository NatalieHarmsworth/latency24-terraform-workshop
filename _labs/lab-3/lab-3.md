# Lab 3 - Let's Make This Better

## Part 1

1. Create a `variables.tf` and add `variable` blocks

```hcl [2-10]
# variables.tf
variable "subscription_id" {
 description = "Subscription to deploy all resources into."
 type = string
}
variable "location" {
 description = "Location to deploy all resources to."
 type = string
 default = "australiaEast"
}
```

2. Update the `azurerm_resource_group` and `provider` to use the new variables.

```hcl [14,18]
# main.tf
terraform {
 backend "local" {}
 required_providers {
  azurerm = {
   source  = "hashicorp/azurerm"
   version = "3.91.0"
   }
  }
 }
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = var.location
}
```

> [!Tip]  
>
> When calling `variable` blocks, you have to prepend `var`, not `variable`  
> Don't worry, it gets worse.

3. Add a `web_app` variable.

```hcl [11-20]
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
 EOT
  type = object({
    service_plan_sku = optional(string, "B1")
  })
  default = {}
}
```

4. Update the `azurerm_service_plan`.

```hcl [2-8]
# webapp.tf
resource "azurerm_service_plan" "asp" {
  name                = "my-web-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.web_app.service_plan_sku
}
```

5. Add a `naming` variable.

```hcl [21-37]
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
 EOT
  type = object({
    service_plan_sku = optional(string, "B1")
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

6. Create a `locals.tf` and add a `locals` block

```hcl[2-9]
# locals.tf
locals {
  luckiest_number = sum(var.naming.lucky_numbers)
  prefix          = [var.naming.org_code]
  suffix = [
    var.naming.env_code, var.naming.loc_code,
    var.naming.wrk_code, local.luckiest_number
  ]
}
```

> [!note]
>
> You can have multiple `locals` blocks where ever you want, and they do not need a label.

> [!tip]  
>
> When calling a `locals` attribute, you have to prepend `local`, not `locals`, `lcl`, `loc` or anything like that.  
> Don't worry, *it still gets worse*

7. Add a `module` to the `locals.tf` file.

```hcl[10-15]
# locals.tf
locals {
 luckiest_number = sum(var.naming.lucky_numbers)
 prefix = [var.naming.org_code]
 suffix = [
  var.naming.env_code, var.naming.loc_code, 
  var.naming.wrk_code, local.luckiest_number
 ]
}
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  prefix  = local.prefix
  suffix  = local.suffix
}
```

8. Update the naming for the `azurerm_resource_group` and `azurerm_service_plan`.

```hcl [17]
# main.tf
terraform {
 backend "local" {}
 required_providers {
  azurerm = {
   source  = "hashicorp/azurerm"
   version = "3.91.0"
   }
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
```

```hcl [3]
# webapp.tf
resource "azurerm_service_plan" "asp" {
  name                = module.naming.app_service_plan.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.web_app.service_plan_sku
}
```

9. Create a `./variables` folder and a sub file `dev.tfvars` with the inputs for the variables.

```hcl[2-10]
# variables/dev.tfvars
subscription_id = "####"
location        = "australiaEast"
naming = {
  org_code      = "lat"
  env_code      = "dev"
  loc_code      = "aue"
  wrk_code      = "tflab"
  lucky_numbers = [15, 03, 2024]
}
```

10. Run `terraform plan` and `terraform apply` with this new variables file.

```bash
terraform plan -var-file="variables/dev.tfvars"
terraform apply -var-file="variables/dev.tfvars"
```

## Part 2

11. Add a `provider` and `data` block to the `main.tf`

```hcl [9-12]
# main.tf
terraform {
  backend "local" {}
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
```

12. Create a `tfstate.tf` and add a `azurerm_storage_account` and `azurerm_storage_container`

```hcl[2-13]
# tfstate.tf
resource "azurerm_storage_account" "st" {
  name                     = join("", concat(local.prefix, ["st"], local.suffix, ["tfstate"]))
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
```

13. Deploy with `terraform apply -var-file="variables/dev.tfvars`

14. Create `dev.tfbackend` in the `variables/` folder, and add to the file:

```hcl [2-20]
# dev.tfbackend
resource_group_name  = "{theRgYouHaveBeenUsing}"
storage_account_name = "{theAccountYouJustMade}"
container_name       = "tfstate"
key                  = "dev.tfstate"
```

15. Change the `backend` from `local` to `azurerm`

```hcl [3]
# main.tf
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
```

15. In the Azure Portal, add your IP to the Access Control.  

![How to add your IP to Access Control](/_labs/lab-3/_img/add_ip_to_acl.png)

16. Execute the following to move your state file to Azure.

`terraform init -backend-config="variables/dev.tfbackend" --migrate-state`  

> [!note]  
>
> What we are doing here is making it so the Dev Terraform config manages its own state file, which creates a Chicken <--> Egg problem. I'd always recommend you either make the Storage Account by hand, or preferably in another Terraform project.
