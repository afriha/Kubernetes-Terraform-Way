# Kubernetes THW with Terraform (Bootstraping Worker Nodes)

This module bootstraps Kubernetes Worker Nodes (step 9) with Kubelet configured for Azure cloud integration.

## Main Vars

variable "kubelet_node_names" {
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

variable "NodeCount" {
  type ="string"
  default ="3"
  description = " Number of worker nodes"
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

variable "azure_worker_prov_null_ids" {
  type ="list"
}