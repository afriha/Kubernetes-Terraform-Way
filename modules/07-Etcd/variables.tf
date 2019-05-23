variable "apiserver_node_names" {
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

variable "MasterCount" {
  type        = string
  default     = "3"
  description = " Number of master nodes"
}

variable "kubernetes_certs_null_ids" {
  type = list(string)
}

variable "ca_cert_null_ids" {
  type = list(string)
}

