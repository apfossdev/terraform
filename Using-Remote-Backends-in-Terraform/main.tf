provider "azurerm" {
  features {}
  
  subscription_id = var.subscription_id
  tenant_id       = "18967005-dfca-49c1-9912-0c68eb379e0b"
}

resource "azurerm_virtual_network" "main" {
  name                = "zigzag-network-1"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "new-resource-group"
}

resource "azurerm_storage_account" "example_storage_account" {
  name                     = "annamalaistorageacc112" # this name must be unique globally across the world
  resource_group_name      = "new-resource-group"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = "false"
}

resource "azurerm_storage_container" "example_storage_container" {
  name                  = "content"
  storage_account_id    = azurerm_storage_account.example_storage_account.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "my-awesome-content-2.zip"
  storage_account_name   = azurerm_storage_account.example_storage_account.name
  storage_container_name = azurerm_storage_container.example_storage_container.name
  type                   = "Block"
  # source                 = "some-local-file.zip" #specifies the path of the file that you want to upload to your blob storage,
  # the source key here above is optional, you can create an empty blob storage as well
}



