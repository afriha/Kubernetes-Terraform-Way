output "kubelet_crt_pems" {
  value = "${tls_locally_signed_cert.kubelet.*.cert_pem}"
}

output "kubelet_key_pems" {
  value = "${tls_private_key.kubelet.*.private_key_pem}"
}
output "admin_crt_pem" {
  value = "${tls_locally_signed_cert.kube_admin.cert_pem}"
}

output "admin_key_pem" {
  value = "${tls_private_key.kube_admin.private_key_pem}"
}

output "kube-proxy_crt_pem" {
  value = "${tls_locally_signed_cert.kube_proxy.cert_pem}"
}

output "kube-proxy_key_pem" {
  value = "${tls_private_key.kube_proxy.private_key_pem}"
}

output "kube-scheduler_crt_pem" {
  value = "${tls_locally_signed_cert.kube_scheduler.cert_pem}"
}

output "kube-scheduler_key_pem" {
  value = "${tls_private_key.kube_scheduler.private_key_pem}"
}

output "kube-controller-manager_crt_pem" {
  value = "${tls_locally_signed_cert.kube_controller_manager.cert_pem}"
}

output "kube-controller-manager_key_pem" {
  value = "${tls_private_key.kube_controller_manager.private_key_pem}"
}
output "kube_ca_crt_pem" {
  value = "${tls_self_signed_cert.kube_ca.cert_pem}"
}

output "kubernetes_certs_null_ids" {
  value = "${null_resource.kubernetes_certs.*.id}"
}

output "ca_cert_null_ids" {
  value = "${null_resource.ca_certs.*.id}"
}
output "service_account_null_ids" {
  value = "${null_resource.service-account_certs.*.id}"
}
output "worker_ca_null_ids" {
  value = "${null_resource.worker_ca_cert.*.id}"
}
output "kubelet_ca_null_ids" {
  value = "${null_resource.kubelet_certs.*.id}"
}
output "cloud-manager_crt_pem" {
  value = "${tls_locally_signed_cert.cloud_manager.cert_pem}"
}
output "cloud-manager_key_pem" {
  value = "${tls_private_key.cloud_manager.private_key_pem}"
}