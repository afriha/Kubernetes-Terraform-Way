variable "apiserver_node_names" {
  type        = "list"
}
variable "apiserver_public_ip" {
  type        = "string"
}
variable "bastionIP" {
  type ="string"
  description = "Bastion's public IP address "
}
variable "node_user" {
  type ="string"
}
variable "node_password" {
  type ="string"
}
variable "MasterCount" {
  type ="string"
  default ="3"
  description = " Number of master nodes"
}
variable "etcd_server_null_ids" {
  type ="list"
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
variable "controller_prov_null_ids" {
  type ="list"
}
variable "scheduler_prov_null_ids" {
  type ="list"
}
variable "admin_prov_null_ids" {
  type ="list"
}
variable "cloud_controller_prov_null_ids" {
  type ="list"
}
variable "azure_prov_null_ids" {
  type ="list"
}