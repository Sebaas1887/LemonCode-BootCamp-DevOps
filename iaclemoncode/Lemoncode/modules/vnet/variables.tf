variable "rsg_name" {
  type        = string
  description = "RG name in Azure"
}
variable "location" {
  type        = string
  description = "RG region"
}
variable "env_name_lc" {
  type        = string
  description = "Environment Name lowercase"
  validation {
    condition     = contains(["dev"], var.env_name_lc)
    error_message = "Value must be one of: dev"
  }
}

variable "security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "Network security group rules"
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Virtual network address space"
}

variable "dns_servers" {
  type        = list(string)
  description = "Virtual network DNS servers"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name"
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "Subnet address prefixes"
}

variable "nsg_name" {
  type        = string
  description = "Network security group name"
}

variable "public_ip_name" {
  type        = string
  description = "Public IP name"
}
