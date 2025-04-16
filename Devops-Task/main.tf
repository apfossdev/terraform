provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = "8359c8e6-f468-493a-b8af-0a5844bf3047" //comment it out before PUSHING TO GITHUB
}

resource "azurerm_virtual_network" "example-vnet" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "annamalai-rg"
}

resource "azurerm_subnet" "example-subnet" {
  name                 = "internal_subnet"
  resource_group_name  = "annamalai-rg"
  virtual_network_name = azurerm_virtual_network.example-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example-public-ip" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = "annamalai-rg"
  location            = "East US"
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "example-ni-card" {
  name                = "example-nic"
  location            = "East US"
  resource_group_name = "annamalai-rg"

  ip_configuration {
    name                          = "internal-nic-ip"
    subnet_id                     = azurerm_subnet.example-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example-public-ip.id
  }
}

resource "azurerm_network_security_group" "example-nsg" {
  name                = "example-network-security-gp"
  location            = "East US"
  resource_group_name = "annamalai-rg"

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"    # The port on the client that traffic is coming from (usually ephemeral/random ports like 49152–65535, so "*" is fine here)
    destination_port_range     = "22" # The port on your VM that traffic is going to.
    source_address_prefix      = "*"  # Or specific IP like "YOUR_IP/32"
    destination_address_prefix = "*"  # Usually *
  }

    security_rule {
    name                       = "http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-sga" {
  subnet_id                 = azurerm_subnet.example-subnet.id
  network_security_group_id = azurerm_network_security_group.example-nsg.id
}

resource "azurerm_linux_virtual_machine" "example-vm" {
  name                = "example-virtual-machine"
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

  connection {
    type     = "ssh"
    user     = "adminuser"
    private_key = file("~/.ssh/azure_corp_key")
    host        = azurerm_public_ip.example-public-ip.ip_address
  }

  # File provisioner to copy a file from local to the remote VM on Azure
  provisioner "file" {
    source      = "/home/apfossdev_corp/Terraform/Devops-Task/app.py"  # Replace with the path to your local file as WSL can use path like this itself
    destination = "/home/adminuser/app.py"  # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
  inline = [
    "echo 'Hello from the remote instance'",
    "sudo apt-get update -y", // use apt get instead of apt in remote execs
    "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip", //very important step running in non interactive mode changed everything it Tells apt not to prompt the user for any input during the installation process. This is useful for scripts or automation (e.g. in CI/CD or provisioning).
    "cd /home/adminuser",
    "sudo pip3 install flask",
    "sudo nohup python3 app.py > app.log 2>&1 &"
  ]
}

}

