terraform {
  backend "azurerm" {
    resource_group_name  = "LemonCode"    #RG containing the TF state
    storage_account_name = "lemoncode"    #Storage account containing the TF state
    container_name       = "tfstatelemon" #Container name containing the TF state
    key                  = "tfstatelemon" #terraform state name, can be anything
  }
}

module "vnet" {
  source                  = "../Lemoncode/modules/vnet"
  rsg_name                = var.rsg_name
  location                = var.location
  env_name_lc             = var.env_name_lc
  nsg_name                = "lemoncode-nsg"
  vnet_name               = "lemoncode-network"
  vnet_address_space      = ["10.0.0.0/16"]
  dns_servers             = []
  subnet_name             = "subnet1"
  subnet_address_prefixes = ["10.0.1.0/24"]
  public_ip_name          = "vm-public-ip"
  security_rules = [
    {
      name                       = "port80"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.1.10"
    },
    {
      name                       = "port22"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "190.246.194.41"
      destination_address_prefix = "10.0.1.10"
    }
  ]
}

module "vm" {
  source       = "../Lemoncode/modules/vm"
  rsg_name     = var.rsg_name
  location     = var.location
  env_name_lc  = var.env_name_lc
  subnet_id    = module.vnet.subnet_id
  public_ip_id = module.vnet.public_ip_id
  vm_nic_name  = "vm-nic"
  vm_name      = "lemon-vm"
  vm_size      = "Standard_B1s"
}
