provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = "8359c8e6-f468-493a-b8af-0a5844bf3047" //comment it out before PUSHING TO GITHUB
}

provider "vault" {
  address = "http://20.83.173.100:8200" //vm ip address as prefix
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "29236f9e-f3d9-236f-c935-3c1f933185bc" //we get this from the terminal after executing the .md file commands
      secret_id = "5e3d7670-27e5-7dbf-c102-6b07b05da169"
    }
  }
}
data "vault_kv_secret_v2" "example" {
  mount = "kv"             #vault_mount.kvv2.path
  name  = "test-secret"    #vault_kv_secret_v2.example.name
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-network-11"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "annamalai-rg"

  tags = {
    secret = data.vault_kv_secret_v2.example.data["username"]
  }
}