# Latency 2024 Terraform Demo

This is a demo of how to use Terraform to deploy resources to Azure, and lots of tricks and tips along the way that may not be obvious to the beginner.

A Github Codespaces environment is provided to allow you to run the code without needing to install anything on your local machine.
If you do wish to work locally, you will need to install the Azure CLI and Terraform.
Do note that I recommend using the Codespaces environment, as it is a consistent environment for everyone, and will make the workshop run smoother.

## Demo prep

1. Create a copy of this repository in your own Github account either by creating a Fork.
2. Ensure you have an Azure subscription, and your account is an Owner on the Subscription.

### Preparing your codespaces environment

1. Fork this Repo. You may need to make an account / Sign in.
2. Start the Codespaces by going `Code >> Codespaces >> Create codespace on main`
3. Run `az login --use-device-code` with the supplied credentials.
4. Execute `az account list` to test that you are logged in and everything is good to go.

### Preparing your local machine for the demo

1. Fork this Repo. You may need to make an account / Sign in.
2. Clone the repo to your local machine.
3. Install [AzCli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
4. Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
5. Run `az login --use-device-code` with the supplied credentials.
6. Execute `az account list` to test that you are logged in and everything is good to go.

## Handy Links

[My Linktree!](https://ryanroyals.cloud)  
[Arkahna Website](https://arkahna.io)

[Terraform Language Documentation](https://developer.hashicorp.com/terraform/language)  
[Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)  
[Terraform Azure Naming Module](https://registry.terraform.io/modules/Azure/naming/azurerm/latest)
[Terraform Http Provider](https://registry.terraform.io/providers/hashicorp/http/latest/docs)

[Azure Documentation](https://docs.microsoft.com/en-us/azure/)  
[Azure Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview)  
[Azure Defining your Naming Convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)  
[Azure Abbreviation Examples for Azure Resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)

[zombo.com](http://zombo.com)



<!-- TF DOCS, TF LINT -->