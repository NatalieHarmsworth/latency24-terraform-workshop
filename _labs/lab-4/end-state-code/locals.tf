locals {
  luckiest_number = sum(var.naming.lucky_numbers)
  prefix          = [var.naming.org_code]
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