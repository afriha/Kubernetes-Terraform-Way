#####################################################################################
# Output
#####################################################################################
output "Kubernetes_API_Public_IP" {
  value = "${azurerm_public_ip.PublicIP-FrontEndKubernetes.ip_address}"
}
output "Kubernetes_API_FQDN" {
  value = "${azurerm_public_ip.PublicIP-FrontEndKubernetes.fqdn}"
}
output "Worker_VM_Private_IP" {
  value = "${azurerm_network_interface.WorkerNIC.*.private_ip_address}"
}
output "Controller_VM_Private_IP" {
  value = "${azurerm_network_interface.ControllerNIC.*.private_ip_address}"
}
output "Worker_Names" {
  value = "${azurerm_virtual_machine.WorkerVM.*.name}"
}
output "Controller_Names" {
  value = "${azurerm_virtual_machine.ControllerVM.*.name}"
}
output "VMS_Password" {
  value = "${azurerm_key_vault_secret.kubesecret.value}"
}
output "Vnet_Name" {
  value = "${azurerm_virtual_network.vNET-Kubernetes.name}"
}
output "Subnet_Name" {
  value = "${azurerm_subnet.Subnet-Kubernetes.name}"
}
output "RouteTable_Name" {
  value = "${azurerm_route_table.KTHWRouteTable.name}"
}
output "AS_Name" {
  value = "${azurerm_availability_set.Worker-AS.name}"
}
output "SecurityG_Name" {
  value = "${azurerm_network_security_group.NSG-Subnet-Kubernetes.name}"
}


