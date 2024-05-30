# main.tf

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "arg_samuel" {
  name     = "myResourceGroup"
  location = "East US"
}

resource "azurerm_virtual_network" "avn_samuel" {
  name                = "myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.arg_samuel.location
  resource_group_name = azurerm_resource_group.arg_samuel.name
}

resource "azurerm_subnet" "asbn_samuel" {
  name                 = "mySubnet"
  virtual_network_name = azurerm_virtual_network.avn_samuel.name
  resource_group_name  = azurerm_resource_group.arg_samuel.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "azni_samuel" {
  name                = "myNIC"
  location            = azurerm_resource_group.arg_samuel.location
  resource_group_name = azurerm_resource_group.arg_samuel.name

  ip_configuration {
    name                          = "myNICConfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = "myVM"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "adminuser"
    admin_password = "P@ssw0rd1234"
  }

  os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
