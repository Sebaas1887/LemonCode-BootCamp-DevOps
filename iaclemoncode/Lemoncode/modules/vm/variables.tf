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
variable "subnet_id" {
  type        = string
  description = "Subnet ID for vm"
}
variable "public_ip_id" {
  type        = string
  description = "Public ip ID for vm"
}
variable "vm_nic_name" {
  type        = string
  description = "VM network interface name"
}
variable "vm_name" {
  type        = string
  description = "VM name"
}

variable "vm_size" {
  type        = string
  description = "VM size"
}
