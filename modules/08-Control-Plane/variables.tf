variable "apiserver_node_names" {
  type = list(string)
}

variable "apiserver_public_ip" {
  type = string
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

variable "MasterCount" {
  type        = string
  default     = "3"
  description = " Number of master nodes"
}

variable "etcd_server_null_ids" {
  type = list(string)
}

variable "kubernetes_certs_null_ids" {
  type = list(string)
}

variable "ca_cert_null_ids" {
  type = list(string)
}

variable "service_account_null_ids" {
  type = list(string)
}

variable "encryption_config_null_ids" {
  type = list(string)
}

variable "controller_prov_null_ids" {
  type = list(string)
}

variable "scheduler_prov_null_ids" {
  type = list(string)
}

variable "admin_prov_null_ids" {
  type = list(string)
}

variable "cloud_controller_prov_null_ids" {
  type = list(string)
}

variable "azure_prov_null_ids" {
  type = list(string)
}

