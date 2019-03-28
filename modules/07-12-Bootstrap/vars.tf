variable "kubelet_node_names" {
  type        = "list"
  description = "Nodes that will have a kubelet client certificate generated"
}
variable "apiserver_node_names" {
  type        = "list"
  description = "Nodes that will have an apiserver certificate generated"
}
variable "apiserver_public_ip" {
  type        = "string"
  description = "Public IP address for the apiserver certificate"
}
variable "bastionIP" {
  type ="string"
  description = "Bastion's public IP address "
}
variable "node_user" {
  type ="string"
  description = "Node username to provision the certificates to the nodes"
}
variable "node_password" {
  type ="string"
  description = "Node passwoed to to provision the certificates to the nodes"
}
variable "NodeCount" {
  type ="string"
  default ="3"
  description = " Number of worker nodes"
}
variable "kubernetes_certs_null_ids" {
  type ="list"
}
variable "ca_cert_null_ids" {
  type ="list"
}
variable "service_account_null_ids" {
  type ="list"
}
variable "encryption_config_null_ids" {
  type ="list"
}
variable "worker_ca_null_ids" {
  type ="list"
}
variable "kubelet_crt_null_ids" {
  type ="list"
}
variable "kubelet_prov_null_ids" {
  type ="list"
}
variable "proxy_prov_null_ids" {
  type ="list"
}
variable "controller_prov_null_ids" {
  type ="list"
}
variable "scheduler_prov_null_ids" {
  type ="list"
}
variable "admin_prov_null_ids" {
  type ="list"
}