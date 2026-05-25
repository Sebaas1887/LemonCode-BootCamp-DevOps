resource "azurerm_network_interface" "main" {
  name                = var.vm_nic_name
  location            = var.location
  resource_group_name = var.rsg_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
    public_ip_address_id          = var.public_ip_id
  }
}

resource "tls_private_key" "lemon_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "lemonvm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.rsg_name
  size                = var.vm_size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.lemon_ssh.public_key_openssh
  }

  custom_data = base64encode(<<-EOF
#cloud-config
package_update: true
packages:
  - docker.io

runcmd:
  - systemctl enable docker
  - systemctl start docker
  - usermod -aG docker adminuser
  - docker rm -f nginx-demo || true
  - docker run -d --restart unless-stopped --name nginx-demo -p 80:80 nginx
EOF
  )

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = {
    environment = var.env_name_lc
  }
  depends_on = [
    tls_private_key.lemon_ssh,
    azurerm_network_interface.main
  ]
}

resource "azurerm_virtual_machine_extension" "docker_nginx" {
  name                 = "${var.vm_name}-docker-nginx"
  virtual_machine_id   = azurerm_linux_virtual_machine.lemonvm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = "sudo bash -c 'set -e; mkdir -p /etc/systemd/resolved.conf.d; printf \"[Resolve]\\nDNS=168.63.129.16\\n\" > /etc/systemd/resolved.conf.d/azure-dns.conf; systemctl restart systemd-resolved; while fuser /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 10; done; rm -f /etc/apt/apt.conf.d/50command-not-found; rm -rf /var/lib/apt/lists/*; apt-get clean; apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io; systemctl enable docker; systemctl start docker; docker rm -f nginx-demo || true; docker run -d --restart unless-stopped --name nginx-demo -p 80:80 nginx'"
  })

  tags = {
    environment = var.env_name_lc
  }
}
