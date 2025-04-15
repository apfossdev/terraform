#Providers

# There are 3 ways to configure providers

# 1. In the root module -> use if you are going to use only a single provider
provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

# 2. In a child module -> use this if you want to reuse the same provider configuration in multiple resources
# Write this after learning about modules

# 3. In the required_providers block -> Useful if you want to make sure a specific provider version is used
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}