# VM Creation
# Controller VM
resource "azurerm_virtual_machine" "ControllerVM" {
    count                   = 3
    name                    = "controller${count.index +1}"
    location                = "${var.AzureRegion}"
    resource_group_name     = "${var.RGName}"
    network_interface_ids   = ["${element(azurerm_network_interface.ControllerNIC.*.id, count.index)}"]
    vm_size                 = "${var.VMSize}"
    delete_os_disk_on_termination = "true"
    availability_set_id     = "${azurerm_availability_set.Controller-AS.id}"

    storage_image_reference {
        publisher   = "${var.OSPublisher}"
        offer       = "${var.OSOffer}"
        sku         = "${var.OSsku}"
        version     = "${var.OSversion}"
    }
    storage_os_disk {
        name                = "Controller-${count.index + 1}-OSDisk"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Standard_LRS"
    }
    storage_data_disk {
        name                = "${element(azurerm_managed_disk.ControllerManagedDisk.*.name, count.index)}"
        managed_disk_id     = "${element(azurerm_managed_disk.ControllerManagedDisk.*.id, count.index)}"
        create_option       = "Attach"
        lun                 = 0
        disk_size_gb        = "${element(azurerm_managed_disk.ControllerManagedDisk.*.disk_size_gb, count.index)}"
    }    
    os_profile {
        computer_name   = "controller${count.index + 1}"
        admin_username  = "${var.VMAdminName}"
        admin_password  = "${azurerm_key_vault_secret.kubesecret.value}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
     tags {
        environment = "${var.TagEnvironment}"
        usage       = "${var.TagUsage}"
    }
}

# Worker VM
resource "azurerm_virtual_machine" "WorkerVM" {
    count                   = "${var.NodeCount}"
    name                    = "worker${count.index +1}"
    location                = "${var.AzureRegion}"
    resource_group_name     = "${var.RGName}"
    network_interface_ids   = ["${element(azurerm_network_interface.WorkerNIC.*.id, count.index)}"]
    vm_size                 = "${var.VMSize}"
    delete_os_disk_on_termination = "true"
    availability_set_id     = "${azurerm_availability_set.Worker-AS.id}"

    storage_image_reference {
        publisher   = "${var.OSPublisher}"
        offer       = "${var.OSOffer}"
        sku         = "${var.OSsku}"
        version     = "${var.OSversion}"
    }

    storage_os_disk {
        name                = "worker-${count.index + 1}-OSDisk"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Premium_LRS"
    }

    storage_data_disk {
        name                = "${element(azurerm_managed_disk.WorkerManagedDisk.*.name, count.index)}"
        managed_disk_id     = "${element(azurerm_managed_disk.WorkerManagedDisk.*.id, count.index)}"
        create_option       = "Attach"
        lun                 = 0
        disk_size_gb        = "${element(azurerm_managed_disk.WorkerManagedDisk.*.disk_size_gb, count.index)}"
    }
    os_profile {
        computer_name   = "worker${count.index + 1}"
        admin_username  = "${var.VMAdminName}"
        admin_password  = "${azurerm_key_vault_secret.kubesecret.value}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
    tags {
        pod-cidr    = "10.200.${count.index + 1}.0/24"
    }
}