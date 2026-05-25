output "vm_public_url" {
  value       = "Conectarse a esta IP: http://${module.vnet.public_ip_address}:80"
  description = "URL to connect to the VM on port 80"
}
