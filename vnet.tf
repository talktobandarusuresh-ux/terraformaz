# Virtual Network Configuration. the script to create a virtual network and subnets in Azure using Terraform.
resource "azurerm_virtual_network" "BandaruVnet" {
  name                = "BandaruVnet"
  address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.BandaruRG.location
    resource_group_name = azurerm_resource_group.BandaruRG.name
    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_subnet" "BandaruSubnet" {
  name                 = "BandaruSubnet"
  resource_group_name  = azurerm_resource_group.BandaruRG.name
  virtual_network_name = azurerm_virtual_network.BandaruVnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "BandaruSubnet2" {
  name                 = "BandaruSubnet2"
  resource_group_name  = azurerm_resource_group.BandaruRG.name
  virtual_network_name = azurerm_virtual_network.BandaruVnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
   