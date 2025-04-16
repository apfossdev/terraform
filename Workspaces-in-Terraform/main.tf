provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = "8359c8e6-f468-493a-b8af-0a5844bf3047" //comment it out before PUSHING TO GITHUB
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_B1s" # Replace with a default value if needed
}

module "az_vm" {
  source = "./modules/azure_vm"
  vm_size = var.vm_size
  # below if variables are used inside the module then here is where you write their values to use them
}