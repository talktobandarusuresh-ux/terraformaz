resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-workloads"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "workload_a" {
  name                 = "snet-workload-a"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_subnet" "workload_b" {
  name                 = "snet-workload-b"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.2.0/24"]
}

locals {
  workload_a = {
    vm1 = azurerm_subnet.workload_a.id
    vm2 = azurerm_subnet.workload_a.id
  }

  workload_b = {
    vm1 = azurerm_subnet.workload_b.id
    vm2 = azurerm_subnet.workload_b.id
  }
}

resource "azurerm_public_ip" "pip_a" {
  for_each            = local.workload_a
  name                = "pip-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip_b" {
  for_each            = local.workload_b
  name                = "pip-b-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_a" {
  for_each            = local.workload_a
  name                = "nic-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_a[each.key].id
  }
}

resource "azurerm_network_interface" "nic_b" {
  for_each            = local.workload_b
  name                = "nic-b-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_b[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm_a" {
  for_each            = local.workload_a
  name                = "workload-a-${each.key}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_a[each.key].id
  ]

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
}

resource "azurerm_linux_virtual_machine" "vm_b" {
  for_each            = local.workload_b
  name                = "workload-b-${each.key}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_b[each.key].id
  ]

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
}