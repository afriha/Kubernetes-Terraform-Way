resource "azurerm_virtual_network" "vNET-Kubernetes" {

    name = "vNET-Kubernetes"
    resource_group_name = "${var.RGName}"
    address_space = ["10.240.0.0/24"]
    location = "${var.AzureRegion}"

    tags {
    environment = "${var.TagEnvironment}"
    usage       = "${var.TagUsage}"
    }   
}

######################################################################
# Network security, NSG and subnet
######################################################################

# Creating Subnet Kubernetes

resource "azurerm_subnet" "Subnet-Kubernetes" {
    name = "Subnet-Kubernetes"
    resource_group_name         = "${var.RGName}"
    virtual_network_name        = "${azurerm_virtual_network.vNET-Kubernetes.name}"
    address_prefix              = "10.240.0.0/24"
    route_table_id              = "${azurerm_route_table.KTHWRouteTable.id}"
    network_security_group_id   = "${azurerm_network_security_group.NSG-Subnet-Kubernetes.id}"
}
# Creating NSG for Kubernetes
resource "azurerm_network_security_group" "NSG-Subnet-Kubernetes" {
    name = "NSG-Subnet-Kubernetes"
    location = "${var.AzureRegion}"
    resource_group_name = "${var.RGName}"
}
# Security Group assocication with subnet
resource "azurerm_subnet_network_security_group_association" "KTHW-NSG-Association" {
  subnet_id                 = "${azurerm_subnet.Subnet-Kubernetes.id}"
  network_security_group_id = "${azurerm_network_security_group.NSG-Subnet-Kubernetes.id}"
}
##RULES##
#Rule for kube services
resource "azurerm_network_security_rule" "Kube-service-OK" {

    name                        = "Kube-service-OK"
    priority                    = 1102
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "TCP"
    source_port_range           = "*"
    destination_port_range      = "30000-32767"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = "${var.RGName}"
    network_security_group_name = "${azurerm_network_security_group.NSG-Subnet-Kubernetes.name}"

}
#Rule for kube-apiserver
resource "azurerm_network_security_rule" "Kube-API-OK" {

    name                        = "Kube-API-OK"
    priority                    = 1101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "TCP"
    source_port_range           = "*"
    destination_port_range      = "6443"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = "${var.RGName}"
    network_security_group_name = "${azurerm_network_security_group.NSG-Subnet-Kubernetes.name}"

}
# Rule for incoming SSH
resource "azurerm_network_security_rule" "SSH-OK" {

    name                       = "SSH"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    resource_group_name         = "${var.RGName}"
    network_security_group_name = "${azurerm_network_security_group.NSG-Subnet-Kubernetes.name}"

}

#Public IPs creation
resource "random_string" "PublicIPfqdnprefixFE" {
    length = 5
    special = false
    upper = false
    number = false
}
#Kubernetes LoadBalancer Public IP
resource "azurerm_public_ip" "PublicIP-FrontEndKubernetes" {
    name                            = "PublicIP-FrontEndKubernetes"
    location                        = "${var.AzureRegion}"
    resource_group_name             = "${var.RGName}"
    allocation_method               = "Static"
    sku                             = "standard"
    domain_name_label               = "${random_string.PublicIPfqdnprefixFE.result}dvtweb"
    tags {
        environment = "${var.TagEnvironment}"
        usage       = "${var.TagUsage}"
    }
}
#Kubernetes' Masters Public IPs
resource "azurerm_public_ip" "PublicIP-ControllerIP" {
  count                           = 3
  name                            = "PublicIP-ControllerKubernetes${count.index+1}"
  location                        = "${var.AzureRegion}"
  resource_group_name             = "${var.RGName}"
  allocation_method               = "Static"
  sku                             = "standard"
  tags {
    Environment       = "${var.TagEnvironment}"
    Usage             = "${var.TagUsage}"
  }
}
#Kubernetes' Workers Public IPs
resource "azurerm_public_ip" "PublicIP-WorkerIP" {
  count                        = 3
  name                         = "PublicIP-WorkerKubernetes${count.index+1}"
  location                     = "${var.AzureRegion}"
  resource_group_name          = "${var.RGName}"
  allocation_method            = "Static"

  tags {
    Environment       = "${var.TagEnvironment}"
    Usage             = "${var.TagUsage}"
  }
}
#Kubernetes LoadBalancer for Controllers config
resource "azurerm_lb" "LB-FrontEndKubernetes" {
    name                        = "LB-FrontEndKubernetes"
    location                    = "${var.AzureRegion}"
    resource_group_name         = "${var.RGName}"
    sku                         = "standard"
    frontend_ip_configuration {
        name                    = "lbkubernetes"
        public_ip_address_id    = "${azurerm_public_ip.PublicIP-FrontEndKubernetes.id}"
    }
    tags {
        environment = "${var.TagEnvironment}"
        usage       = "${var.TagUsage}"
    }
}
resource "azurerm_lb_backend_address_pool" "LB-KubernetesPool" {
    name                = "LB-KubernetesPool"
    resource_group_name = "${var.RGName}"
    loadbalancer_id     = "${azurerm_lb.LB-FrontEndKubernetes.id}"
}
resource "azurerm_network_interface_backend_address_pool_association" "KTHW-LB-BP-Association" {
  count                   = 3
  network_interface_id    = "${element(azurerm_network_interface.ControllerNIC.*.id, count.index)}"
  ip_configuration_name   = "ConfigIP-NIC${count.index + 1}-Controller${count.index + 1}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.LB-KubernetesPool.id}"
}
resource "azurerm_lb_rule" "LB-API-Rule" {
  name                           = "kubernetes-apiserver-rule"
  resource_group_name            = "${var.RGName}"
  loadbalancer_id                = "${azurerm_lb.LB-FrontEndKubernetes.id}"
  protocol                       = "tcp"
  probe_id                       = "${azurerm_lb_probe.KubeHealthzProbe.id}"
  frontend_port                  = 6443
  frontend_ip_configuration_name = "lbkubernetes"
  backend_port                   = 6443
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.LB-KubernetesPool.id}"
}
resource "azurerm_lb_rule" "LB-SSH-Rule" {
  name                           = "kubernetes-ssh-rule"
  resource_group_name            = "${var.RGName}"
  loadbalancer_id                = "${azurerm_lb.LB-FrontEndKubernetes.id}"
  protocol                       = "tcp"
  frontend_port                  = 22
  frontend_ip_configuration_name = "lbkubernetes"
  backend_port                   = 22
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.LB-KubernetesPool.id}"
}
resource "azurerm_lb_probe" "KubeHealthzProbe" {
  resource_group_name = "${var.RGName}"
  loadbalancer_id     = "${azurerm_lb.LB-FrontEndKubernetes.id}"
  name                = "kubernetes-apiserver-probe"
  port                = 6443
  protocol            = "https"
  request_path        = "/healthz"
}

#Routing for Pods
resource "azurerm_route_table" "KTHWRouteTable" {
  name                = "THWRoutetable"
  location            = "${var.AzureRegion}"
  resource_group_name = "${var.RGName}"
}

resource "azurerm_route" "PODS_Routes" {
  count                  = 3
  name                   = "PodNet${count.index + 1}-route"
  resource_group_name    = "${var.RGName}"
  route_table_name       = "${azurerm_route_table.KTHWRouteTable.name}"
  address_prefix         = "10.200.${count.index + 1}.0/24"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.240.0.2${count.index + 1}"
}
resource "azurerm_subnet_route_table_association" "KTHW" {
  subnet_id      = "${azurerm_subnet.Subnet-Kubernetes.id}"
  route_table_id = "${azurerm_route_table.KTHWRouteTable.id}"
}