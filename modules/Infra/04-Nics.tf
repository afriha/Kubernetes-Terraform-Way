# NIC Creation for Controllers
resource "azurerm_network_interface" "ControllerNIC" {
    count                   = 3
    name                    = "Controller${count.index +1}-NIC"
    location                = "${var.AzureRegion}"
    resource_group_name     = "${var.RGName}"
    enable_ip_forwarding    = "true"
    ip_configuration {
        name                                        = "ConfigIP-NIC${count.index + 1}-Controller${count.index + 1}"
        subnet_id                                   = "${azurerm_subnet.Subnet-Kubernetes.id}"
        private_ip_address                          = "10.240.0.1${count.index + 1}"
        private_ip_address_allocation               = "static"
        public_ip_address_id                        = "${element(azurerm_public_ip.PublicIP-ControllerIP.*.id,count.index)}"
    }
    tags {
        environment = "${var.TagEnvironment}"
        usage       = "${var.TagUsage}"
    }
}

# NIC Creation for Workers
resource "azurerm_network_interface" "WorkerNIC" {
    count                   = 3
    name                    = "Worker${count.index +1}-NIC"
    location                = "${var.AzureRegion}"
    resource_group_name     = "${var.RGName}"
    enable_ip_forwarding    = "true"
    ip_configuration {
        name                                        = "ConfigIP-NIC${count.index + 1}-Worker${count.index + 1}"
        subnet_id                                   = "${azurerm_subnet.Subnet-Kubernetes.id}"
        private_ip_address                          = "10.240.0.2${count.index + 1}"
        private_ip_address_allocation               = "static"
        public_ip_address_id                        = "${element(azurerm_public_ip.PublicIP-WorkerIP.*.id,count.index)}"
    }
    tags {
        environment = "${var.TagEnvironment}"
        usage       = "${var.TagUsage}"
        pod-cidr    = "10.200.${count.index + 1}.0/24"
    }
}