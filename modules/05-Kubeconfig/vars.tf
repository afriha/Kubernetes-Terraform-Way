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
variable "kubelet_crt_pems" {
  type = "list"
}

variable "kubelet_key_pems" {
  type = "list"
}

variable "admin_crt_pem" {
}

variable "admin_key_pem" {
}

variable "kube-proxy_crt_pem" {
}

variable "kube-proxy_key_pem" {
}

variable "kube-scheduler_crt_pem" {
}

variable "kube-scheduler_key_pem" {
}

variable "kube-controller-manager_crt_pem" {
}
variable "kube-controller-manager_key_pem" {
}
variable "kube_ca_crt_pem" {
}
