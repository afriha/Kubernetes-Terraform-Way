# Kubernetes THW with Terraform (Installing AddOns)

This module deploys the coreDNS addon for Service Discovery in Kubernetes, and the Azure Disk CSI plugin for volumes provisioning with Azure Disk.

K8S Dashboard is also added and can be access with a the token present on the admin-user service account.

## Main Vars

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
variable "etcd_server_null_ids" {
  type ="list"
}
variable "control_plane_null_ids" {
  type ="list"
}
variable "rbac_ccm_null_id" {
  type ="string"
}
variable "rbac_apiserver_null_id" {
  type ="string"
}
variable "worker_nodes_null_ids" {
  type ="list"
}