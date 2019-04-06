variable "kubelet_node_names" {
  type        = "list"
  description = "Nodes that will have a kubelet client certificate generated"
}
variable "kubelet_node_ips" {
  type        = "list"
  description = "Node IP addresses for the kubelet certificate SAN"
}
variable "apiserver_node_names" {
  type        = "list"
  description = "Nodes that will have an apiserver certificate generated"
}
variable "apiserver_master_ips" {
  type        = "list"
  description = "Node IP addresses for the apiserver certificate"
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