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