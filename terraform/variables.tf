variable "admin_username" {
  default = "azureuser"
}

variable "demo_location" {
  default = "East US"
}

variable "demo_vnet_name" {
  default = "demo"
}

variable "demo_vm_name" {
  default = "mini-finance-vm"
}

variable "demo_rg" {
  default = "mini-finance-rg"
}

variable "ssh_public_key" {
  description = "Path to your SSH Public Key"
  default     = "~/.ssh/id_rsa.pub"
}
