output "subnet_id" {
  value       = azurerm_subnet.subnet1.id
  description = "subnet id output for subnet 1"
}
output "public_ip_id" {
  value       = azurerm_public_ip.vm_public_ip.id
  description = "public ip id for vm"
}

output "public_ip_address" {
  value       = azurerm_public_ip.vm_public_ip.ip_address
  description = "public ip address for vm"
}
