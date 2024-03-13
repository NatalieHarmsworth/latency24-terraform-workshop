# Lab 1 - Creating Your First HCL Files and Looking around

1. Create a `main.tf` file and add a `terraform` block.

```hcl[2-4]
# main.tf
terraform {
 backend "local" {}
}
```

> [!warning]  
> If I ever hear about you using `local` for anything beyond a scratch environment I will be very upset.

2. Add `required_providers` and a `providers` block

```hcl[4-10,12-15]
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
  subscription_id = "########-####-####-####-############"
}
```

3. Add a `resource` block

```hcl [12-15]
# main.tf
terraform {
 backend "local" {}
}
required_providers {
 azurerm = {
  source  = "hashicorp/azurerm"
  version = "3.91.0"
  }
 }
}
resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = "australiaEast"
}
```

> [!note]  
> Keep names unique, otherwise you may overrun with someone else in the room

4. Add another `resource` block in `webapp.tf`

```hcl [2-8]
# webapp.tf
resource "azurerm_service_plan" "asp" {
  name                = "my-web-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}
```

> [!Tip]  
> When calling `resource` blocks, you use `{resourceType}.{identifier}.{attribute}`  
> All good Terraform code does this constantly, everywhere, all the time
