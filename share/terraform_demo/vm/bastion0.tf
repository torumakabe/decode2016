resource "azurerm_public_ip" "bastion0" {
  name                         = "bastion0PublicIp0"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${var.prefix}bastion0"
}

resource "azurerm_network_interface" "bastion0" {
  name                = "bastion0Nic0"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "bastion0NicConfig0"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.bastion0.id}"
  }
}

resource "azurerm_storage_account" "bastion0" {
  name                = "${var.prefix}sabastion0"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "bastion0" {
  name                  = "vhds"
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.bastion0.name}"
  container_access_type = "private"
}

resource "azurerm_virtual_machine" "bastion0" {
  name                  = "${var.prefix}bastion0"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.bastion0.id}"]
  vm_size               = "Standard_D1"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "14.04.4-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "osdisk0"
    vhd_uri       = "${azurerm_storage_account.bastion0.primary_blob_endpoint}${azurerm_storage_container.bastion0.name}/osdisk0.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.prefix}bastion0"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = "${azurerm_public_ip.bastion0.ip_address}"
      user     = "${var.admin_username}"
      password = "${var.admin_password}"
    }

    inline = [
      "sudo apt-get update",
      "sudo timedatectl set-timezone Asia/Tokyo",
      "sudo wget https://github.com/Microsoft/OMS-Agent-for-Linux/releases/download/v1.1.0-28/omsagent-1.1.0-28.universal.x64.sh",
      "sudo sh ./omsagent-1.1.0-28.universal.x64.sh --upgrade -w ${var.workspace_id} -s ${var.workspace_key}",
    ]
  }
}
