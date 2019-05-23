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