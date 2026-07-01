variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "rg-nsg-demo"
}

variable "username" {
  default = "kodekloud"
}

variable "password" {
  default   = "VMP@55w0rd"
  sensitive = true
}