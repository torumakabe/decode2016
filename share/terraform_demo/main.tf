# Define variables. Credentials and identifiers are loaded from terraform.tfvars
variable "subscription_id" {
}

variable "client_id" {
}

variable "client_secret" {
}

variable "tenant_id" {
}

variable "prefix" {
}

variable "admin_username" {
}

variable "admin_password" {
}

variable "workspace_id" {
}

variable "workspace_key" {
}

variable "vnet0_address_space" {
}

variable "vnet0_frontend_address_prefix" {
}

variable "vnet0_backend_address_prefix" {
}

variable "vnet0_bastion_address_prefix" {
}

variable "location" {
  default = "Japan West"
}

# Configure the Azure Resource Manager Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Create a resource group
resource "azurerm_resource_group" "tfdemo" {
  name     = "tfdemo"
  location = "${var.location}"
}

# Create a virtual network
module "network" {
  source                        = "./network"
  resource_group_name           = "${azurerm_resource_group.tfdemo.name}"
  location                      = "${var.location}"
  vnet0_address_space           = "${var.vnet0_address_space}"
  vnet0_frontend_address_prefix = "${var.vnet0_frontend_address_prefix}"
  vnet0_backend_address_prefix  = "${var.vnet0_backend_address_prefix}"
  vnet0_bastion_address_prefix  = "${var.vnet0_bastion_address_prefix}"
}

# Create a bastion VM
module "vm" {
  source              = "./vm"
  resource_group_name = "${azurerm_resource_group.tfdemo.name}"
  subnet_id           = "${module.network.bastion_subnet_id}"
  prefix              = "${var.prefix}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  workspace_id        = "${var.workspace_id}"
  workspace_key       = "${var.workspace_key}"
  location            = "${var.location}"
}
