terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "demo_rg" {
  name     = var.demo_rg
  location = var.demo_location
}

# Virtual Network
resource "azurerm_virtual_network" "demo_vnet" {
  name                = "${var.demo_vnet_name}-vnet"
  resource_group_name = azurerm_resource_group.demo_rg.name
  location            = azurerm_resource_group.demo_rg.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "demo_subnet" {
  name                 = "${var.demo_vnet_name}-subnet"
  resource_group_name  = azurerm_resource_group.demo_rg.name
  virtual_network_name = azurerm_virtual_network.demo_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "demo_nic" {
  name                = "${var.demo_vnet_name}-nic"
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "demo_nic_assoc" {
  network_interface_id      = azurerm_network_interface.demo_nic.id
  network_security_group_id = azurerm_network_security_group.demo_nsg.id
}

# Network Security Group
resource "azurerm_network_security_group" "demo_nsg" {
  name                = "${var.demo_vnet_name}-nsg"
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name

  # Allow SSH security rule
  security_rule {
    name                       = "allow_ssh"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTP security rule
  security_rule {
    name                       = "allow_http"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "demo_nsg_assoc" {
  subnet_id                 = azurerm_subnet.demo_subnet.id
  network_security_group_id = azurerm_network_security_group.demo_nsg.id
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "demo_vm" {
  name                = var.demo_vm_name
  resource_group_name = azurerm_resource_group.demo_rg.name
  location            = azurerm_resource_group.demo_rg.location
  size                = "Standard_B1s"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.demo_nic.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key)
  }

  os_disk {
    name                 = "${var.demo_vm_name}-osdisk"
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

# Public IP Address
resource "azurerm_public_ip" "demo_public_ip" {
  name                = "${var.demo_vnet_name}-PublicIp"
  resource_group_name = azurerm_resource_group.demo_rg.name
  location            = azurerm_resource_group.demo_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


