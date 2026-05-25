terraform {
  backend "azurerm" {
    resource_group_name  = "LemonCode"
    storage_account_name = "lemoncode"
    container_name       = "tfstatelemon"
    key                  = "tfstatelemon"
  }
}

module "network" {
  source                  = "./modules/network"
  rsg_name                = var.rsg_name
  location                = var.location
  env_name_lc             = var.env_name_lc
  nsg_name                = "lemoncode-avm-nsg"
  vnet_name               = "lemoncode-avm-network"
  vnet_address_space      = ["10.0.0.0/16"]
  dns_servers             = []
  subnet_name             = "subnet1"
  subnet_address_prefixes = ["10.0.1.0/24"]
  public_ip_name          = "vm-avm-public-ip"
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
  source       = "./modules/vm"
  rsg_name     = var.rsg_name
  location     = var.location
  env_name_lc  = var.env_name_lc
  subnet_id    = module.network.subnet_id
  public_ip_id = module.network.public_ip_id
  vm_nic_name  = "vm-avm-nic"
  vm_name      = "lemon-avm-vm"
  vm_size      = "Standard_B1s"
}
