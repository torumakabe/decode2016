# Create a network security group
resource "azurerm_network_security_group" "bastion" {
  name                = "bastion"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

# Create network security group rules

# You should define source address prefix as specific IP, if you can
resource "azurerm_network_security_rule" "bs_ssh" {
  name                        = "bs_ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}

resource "azurerm_network_security_rule" "bs_denyfrominternet" {
  name                        = "bs_denyfrominternet"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}

resource "azurerm_network_security_rule" "bs_denyfromfe" {
  name                        = "bs_denyfromfe"
  priority                    = 201
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${var.vnet0_frontend_address_prefix}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}

resource "azurerm_network_security_rule" "bs_denyfrombe" {
  name                        = "bs_denyfrombe"
  priority                    = 202
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${var.vnet0_backend_address_prefix}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}
