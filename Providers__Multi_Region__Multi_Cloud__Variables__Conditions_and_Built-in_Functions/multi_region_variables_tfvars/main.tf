# the below is really useful when you have multiple providers as given below and they each have various subscription ids then it makes sense to use these
# else you need not use aliases and simply go ahead with the normal approach

provider "azurerm" {
  alias           = "eastus"
  features {}
  subscription_id = var.subscription_id
}

provider "azurerm" {
  alias           = "westeurope"
  features {}
  subscription_id = var.subscription_id
}

variable "prefix" {
  default = "first-company-again"
}

variable "use_default_address_space" {
  description = "Flag to determine whether to use the default address space"
  type        = bool
  default     = true
}

resource "azurerm_virtual_network" "main1" {
  name                = "${var.prefix}-eastus-network"
  address_space       = var.use_default_address_space ? ["10.0.0.0/16"] : ["192.168.0.0/16"] # Conditional expression
  location            = "East US"
  resource_group_name = "annamalai-rg"
  provider            = azurerm.eastus # when we have only one provider we do not need to explicitly set the provider here
}

resource "azurerm_virtual_network" "main2" {
  name                = "${var.prefix}-westeurope-network"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "annamalai-rg"
  provider            = azurerm.westeurope # when we have only one provider we do not need to explicitly set the provider here
}

output "eastus_virtual_network_name" { # gives the name of the resource once created i.e. after apply, these output values can be seen in the terminal
  description = "Name of the East US virtual network"
  value       = azurerm_virtual_network.main1.name
}

output "westeurope_virtual_network_name" {
  description = "Name of the West Europe virtual network"
  value       = azurerm_virtual_network.main2.name
}


