provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = "8359c8e6-f468-493a-b8af-0a5844bf3047" //comment it out before PUSHING TO GITHUB
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_B1s"
}

resource "azurerm_virtual_network" "example-vnet" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "annamalai-rg"
}

resource "azurerm_subnet" "example-subnet" {
  name                 = "internal-subnet"
  resource_group_name  = "annamalai-rg"
  virtual_network_name = azurerm_virtual_network.example-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example-ni-card" {
  name                = "example-nic"
  location            = "East US"
  resource_group_name = "annamalai-rg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example-vm" {
  name                = "example-machine"
  resource_group_name = "annamalai-rg"
  location            = "East US"
  size                = "Standard_B2ls_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example-ni-card.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/azure_corp_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}