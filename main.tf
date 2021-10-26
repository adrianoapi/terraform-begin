terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = ">= 2.46"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

resource "azurerm_resource_group" "rg-aula-fs" {
  name     = "rg-aula-fs"
  location = "East US"
}

resource "azurerm_virtual_network" "vn-aula-fs" {
  name                = "vn-aula-fs"
  location            = azurerm_resource_group.rg-aula-fs.location
  resource_group_name = azurerm_resource_group.rg-aula-fs.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    faculdade = "Impacta"
  }
}


resource "azurerm_subnet" "sub-aula-fs" {
  name                 = "sub-aula-fs"
  resource_group_name  = azurerm_resource_group.rg-aula-fs.name
  virtual_network_name = azurerm_virtual_network.vn-aula-fs.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "ip-aula-fs" {
  name                = "ip-aula-fs"
  resource_group_name = azurerm_resource_group.rg-aula-fs.name
  location            = azurerm_resource_group.rg-aula-fs.location
  allocation_method   = "Static"
}

# firewqll
resource "azurerm_network_security_group" "nsg-aula-fs" {
  name                = "nsg-aula-fs"
  location            = azurerm_resource_group.rg-aula-fs.location
  resource_group_name = azurerm_resource_group.rg-aula-fs.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "ni-aula-fs" {
  name                = "ni-aula-fs"
  location            = azurerm_resource_group.rg-aula-fs.location
  resource_group_name = azurerm_resource_group.rg-aula-fs.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub-aula-fs.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ip-aula-fs.id
  }
}

resource "azurerm_network_interface_security_group_association" "nisga-aula-fs" {
    network_interface_id      = azurerm_network_interface.ni-aula-fs.id
    network_security_group_id = azurerm_network_security_group.nsg-aula-fs.id
}

# Mysql
resource "azurerm_mysql_server" "ms-aula-fs" {
  name                = "ms-aula-fs"
  location            = azurerm_resource_group.rg-aula-fs.location
  resource_group_name = azurerm_resource_group.rg-aula-fs.name

  administrator_login          = "adriano"
  administrator_login_password = "Acesso#01"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

# Mysql firewall open to 3306
resource "azurerm_mysql_firewall_rule" "mfr-aula-fs" {
  name                = "mfr-aula-fs"
  resource_group_name = azurerm_resource_group.rg-aula-fs.name
  server_name         = azurerm_mysql_server.ms-aula-fs.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_virtual_machine" "vm-aula-fs" {
  name                  = "vm-aula-fs"
  location              = azurerm_resource_group.rg-aula-fs.location
  resource_group_name   = azurerm_resource_group.rg-aula-fs.name
  network_interface_ids = [azurerm_network_interface.ni-aula-fs.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "dsk-aula-fs"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm-aula-fs"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}



output "public-ip-vm-aula-fs" {
  value = azurerm_public_ip.ip-aula-fs.ip_address
}