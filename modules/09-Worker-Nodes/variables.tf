variable "kubelet_node_names" {
  type = list(string)
}

variable "bastionIP" {
  type        = string
  description = "Bastion's public IP address "
}

variable "node_user" {
  type = string
}

variable "node_password" {
  type = string
}

variable "NodeCount" {
  type        = string
  default     = "3"
  description = " Number of worker nodes"
}

variable "etcd_server_null_ids" {
  type = list(string)
}

variable "control_plane_null_ids" {
  type = list(string)
}

variable "rbac_ccm_null_id" {
  type = string
}

variable "rbac_apiserver_null_id" {
  type = string
}

variable "worker_ca_null_ids" {
  type = list(string)
}

variable "kubelet_crt_null_ids" {
  type = list(string)
}

variable "kubelet_prov_null_ids" {
  type = list(string)
}

variable "proxy_prov_null_ids" {
  type = list(string)
}

variable "azure_worker_prov_null_ids" {
  type = list(string)
}

