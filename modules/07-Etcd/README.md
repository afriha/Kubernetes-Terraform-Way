# Kubernetes THW with Terraform (Bootstraping ETCD)

This module bootstraps ETCD on master nodes (step 7)

## Main Vars

variable "apiserver_node_names" {
  type        = "list"
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

variable "kubernetes_certs_null_ids" {
  type ="list"
}

variable "ca_cert_null_ids" {
  type ="list"
}