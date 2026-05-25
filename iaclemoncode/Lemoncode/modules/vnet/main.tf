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

resource "azurerm_virtual_network" "vnetlemoncode" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.rsg_name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers

  tags = {
    environment = var.env_name_lc
  }
  depends_on = [
    azurerm_network_security_group.nsglemon
  ]
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet_name
  resource_group_name  = var.rsg_name
  virtual_network_name = azurerm_virtual_network.vnetlemoncode.name
  address_prefixes     = var.subnet_address_prefixes
  depends_on = [
    azurerm_virtual_network.vnetlemoncode
  ]
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.rsg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_subnet_network_security_group_association" "subnet1_nsg" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsglemon.id
}
