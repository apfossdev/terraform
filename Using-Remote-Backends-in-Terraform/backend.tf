# # you can get a similar block to below based on your provider and type of login from here https://developer.hashicorp.com/terraform/language/backend/azurerm

terraform {
  backend "azurerm" {
    # use_cli              = true                                    # Can also be set via `ARM_USE_CLI` environment variable.
    use_azuread_auth     = true                                    # Can also be set via `ARM_USE_AZUREAD` environment variable.
    tenant_id            = "18967005-dfca-49c1-9912-0c68eb379e0b"  # Can also be set via `ARM_TENANT_ID` environment variable. Azure CLI will fallback to use the connected tenant ID if not supplied.
    subscription_id      = "9434bd90-a97c-4f5c-932a-8fc12772c970"  # Your subscription ID
    storage_account_name = "annamalaistorageacc112"                   # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "content"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "dev.terraform.tfstate"                 # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    # key refers to the name of the blob where our tfstate file will be stored
    # the key as a convention must refer to the file stored so -> prod.terraform.tfstate is a good name, 
    # you can also use dev.terraform.tfstate and staging.terraform.tfstate as and when needed
  }
}



