# Kubernetes THW with Terraform (Compute ressources)

1 - Provisions computes ressources and network configuration for kubernetes architecture - x masters and x workers (step 3) 

2 - Generates kubectl remote access bat and bash scripts.

## Main Vars

variable "RGName" {
type    = "string"
default = "RG-Kube"
}

variable "VMAdminName" {
type    = "string"
}

variable "VMAdminPassword" {
type    = "string"
}


variable "NodeCount" {
  type ="string"
  default = "3"
  description = "Number of worker nodes"
}

variable "ObjectID" {
type    = "string"
}

variable "AzurePublicSSHKey" {
type    = "string"
default = ""
}

variable "TagEnvironment" {
type    = "string"
default = "Kubernetes"
}

variable "TagUsage" {
type    = "string"
default = "Kubernetes THW"
}

variable "OSPublisher" {
  type    = "string"
  default = "Canonical"
}

variable "OSOffer" {
  type    = "string"
  default = "UbuntuServer"
}

variable "OSsku" {
  type    = "string"
  default = "18.04-LTS"
}

variable "OSversion" {
  type    = "string"
  default = "latest"
}

variable "VMSize" {
  type    = "string"
  default = "Standard_F1S"
}