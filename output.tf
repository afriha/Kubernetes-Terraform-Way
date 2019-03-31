#####################################################################################
# Output
#####################################################################################
output "Kubernetes_API_Public_IP" {
  value = "${module.Infrastructure.Kubernetes_API_Public_IP}"
}
output "Kubernetes_API_FQDN" {
  value = "${module.Infrastructure.Kubernetes_API_FQDN}"
}
output "Worker_VM_Public_IP" {
  value = "${module.Infrastructure.Worker_VM_Public_IP}"
}
output "Controller_VM_Public_IP" {
  value = "${module.Infrastructure.Controller_VM_Public_IP}"
}
output "Worker_VM_Private_IP" {
  value = "${module.Infrastructure.Worker_VM_Private_IP}"
}
output "Controller_VM_Private_IP" {
  value = "${module.Infrastructure.Controller_VM_Private_IP}"
}