# subscription_id = "8359c8e6-f468-493a-b8af-0a5844bf3047"
# admin_username  = "testadmin"
# admin_password  = "Password1234!"

# when using modules you don't pass through the terraform.tfvars file instead you can pass the sensitive values
# while calling the modules itself, see the outer main.tf for reference

# in fact you don't even need this file

# module "module_for_creating_an_azure_vm" {
#   source          = "./modules/azure_vm" #if the module here is in a different github repository you need to provide that here
#   subscription_id = "8359c8e6-f468-493a-b8af-0a5844bf3047"
#   admin_username  = "testadmin"
#   admin_password  = "Password1234!"
# }

# Paste the above module code in the outer main.tf to get modules working, am keeping it here as don't want to push it to GitHub