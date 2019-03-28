# Kubernetes THW with Terraform (Bootstraping Kubernetes)

## This Terraform config

Bootstraps ETCD, Control plane and Worker Nodes and installs CoreDns. (Step 7 to 12)

## Main Vars

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