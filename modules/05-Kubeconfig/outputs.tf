output "kubelet_prov_null_ids" {
  value = "${null_resource.kubelet_provisioner.*.id}"
}
output "proxy_prov_null_ids" {
  value = "${null_resource.kube-proxy-provisioner.*.id}"
}
output "controller_prov_null_ids" {
  value = "${null_resource.kube-controller-manager-provisioner.*.id}"
}
output "scheduler_prov_null_ids" {
  value = "${null_resource.kube-scheduler-provisioner.*.id}"
}
output "admin_prov_null_ids" {
  value = "${null_resource.admin-provisioner.*.id}"
}
output "encryption_config_null_ids" {
  value = "${null_resource.encryption_config-provisioner.*.id}"
}
output "cloud_controller_prov_null_ids" {
  value = "${null_resource.cloud-manager-provisioner.*.id}"
}
output "azure_prov_null_ids" {
  value = "${null_resource.azure-provisioner.*.id}"
}
output "azure_worker_prov_null_ids" {
  value = "${null_resource.azure-provisioner-worker.*.id}"
}