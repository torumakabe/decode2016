# Create a virtual network
resource "azurerm_virtual_network" "vnet0" {
  name                = "vnet0"
  address_space       = ["${var.vnet0_address_space}"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

# Create a frontend subnet
# "depends_on" arg is a workaround to avoid conflict with updating NSG rules 
resource "azurerm_subnet" "frontend" {
  name                      = "frontend"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet0.name}"
  address_prefix            = "${var.vnet0_frontend_address_prefix}"
  network_security_group_id = "${azurerm_network_security_group.frontend.id}"

  depends_on = [
    "azurerm_network_security_rule.fe_web80",
    "azurerm_network_security_rule.fe_web443",
    "azurerm_network_security_rule.fe_denyfrominternet",
  ]
}

# Create a backend subnet
# "depends_on" arg is a workaround to avoid conflict with updating NSG rules 
resource "azurerm_subnet" "backend" {
  name                      = "backend"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet0.name}"
  address_prefix            = "${var.vnet0_backend_address_prefix}"
  network_security_group_id = "${azurerm_network_security_group.backend.id}"

  depends_on = [
    "azurerm_network_security_rule.be_denyfrominternet",
  ]
}

# Create a bastion subnet
# "depends_on" arg is a workaround to avoid conflict with updating NSG rules 
resource "azurerm_subnet" "bastion" {
  name                      = "bastion"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet0.name}"
  address_prefix            = "${var.vnet0_bastion_address_prefix}"
  network_security_group_id = "${azurerm_network_security_group.bastion.id}"

  depends_on = [
    "azurerm_network_security_rule.bs_ssh",
    "azurerm_network_security_rule.bs_denyfrominternet",
    "azurerm_network_security_rule.bs_denyfromfe",
    "azurerm_network_security_rule.bs_denyfrombe",
  ]
}

output "bastion_subnet_id" {
  value = "${azurerm_subnet.bastion.id}"
}
