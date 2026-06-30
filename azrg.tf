terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.79.0"
    }
  }
}

provider "azurerm" {
  features {}
}
# Create Resource Group
resource "azurerm_resource_group" "BandaruRG" {
  location = "east us"
  name = "BandaruRG"
}
# # Create Resource Group 
# resource "azurerm_resource_group" "my_demo_rg1" {
#   location = "eastus"
#   name = "my-demo-rg1"  
# }

# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "4.79.0"
#     }
#   }
# }

# provider "azurerm" {
#   # Configuration options
# }