resource "azurerm_network_security_group" "nsglemon" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rsg_name

  dynamic "security_rule" {
    for_each = var.security_rules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = {
    environment = var.env_name_lc
  }
}

data "azurerm_resource_group" "lemon" {
  name = var.rsg_name
}

locals {
  dns_servers = length(var.dns_servers) > 0 ? {
    dns_servers = var.dns_servers
  } : null
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.1"

  name          = var.vnet_name
  location      = var.location
  parent_id     = data.azurerm_resource_group.lemon.id
  address_space = toset(var.vnet_address_space)
  dns_servers   = local.dns_servers

  subnets = {
    (var.subnet_name) = {
      name             = var.subnet_name
      address_prefixes = var.subnet_address_prefixes
      network_security_group = {
        id = azurerm_network_security_group.nsglemon.id
      }
    }
  }

  tags = {
    environment = var.env_name_lc
  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.rsg_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = var.env_name_lc
  }
}
