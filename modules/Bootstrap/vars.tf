variable "kubelet_node_names" {
  type        = "list"
  description = "The list of nodes that will have a kubelet client certificate generated"
}
variable "kubelet_node_ips" {
  type        = "list"
  description = "The list of node IP addresses for the kubelet certificate SAN"
}
variable "kubelet_public_ips" {
  type        = "list"
  description = "The list of node public IP addresses for the kubelet certificate SAN"  
}
variable "apiserver_node_names" {
  type        = "list"
  description = "The list of nodes that will have an apiserver certificate generated"
}

variable "apiserver_master_ips" {
  type        = "list"
  description = "The list of node IP addresses for the apiserver certificate"
}
variable "apiserver_public_ip" {
  type        = "string"
  description = "The public IP address for the apiserver certificate"
}
variable "bastionIP" {
  type ="string"
  description = "Bastion's public IP address "
}
variable "node_user" {
  type ="string"
  description = "The node user name to use for provision the certificates to the nodes"
}
variable "node_password" {
  type ="string"
  description = "The node user name to use for provision the certificates to the nodes"
}
