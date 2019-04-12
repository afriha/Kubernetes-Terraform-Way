# Kubernetes The Terraform Way

## Automating Kubernetes The Hard Way Tutorial with Terraform.

- Module 03-Infra provisions computes ressources and network configuration for Kubernetes' architecture - x masters and x workers (step 3) - and generates kubectl remote access bat and bash scripts. 

- Module 04-Certs generates and provisions certificates for Kubernetes components (step 4)

- Module 05-Kubeconfig generates kubeconfig files, encryption config and Azure cloud config for Cloud-Controller-Manager.

- Module 07-Etcd bootstraps Etcd on master nodes (step 7)

- Module 08-Control-Plane bootstraps Kubernetes Control Plane on master nodes (step 8) and Cloud Controller Manager (as a systemd service) for K8S' integration with Azure cloud (not present in The Hard Way tutorial). The CCM binary was built from [cloud-provider-azure repo](https://github.com/kubernetes/cloud-provider-azure).

- Module 09-Worker-Nodes bootstraps Kubernetes Worker Nodes (step 9) with Kubelet configured for Azure cloud integration.

- Module 10-AddOns deploys the CoreDNS addon for Service Discovery in Kubernetes, and the Azure Disk CSI plugin for volumes provisioning with Azure Disk. K8S Dashboard is also added and can be accessed with the token present on the admin-user service account.

## Main Vars
### Variable defining Resource Group Name
variable "RGName" {
  type    = "string"
}
### Variable defining VM Admin Name
variable "VMAdminName" {
  type    = "string"
}
### Variable defining VM Admin password
variable "VMAdminPassword" {
  type    = "string"
}
### Variable Number of Master Nodes
variable "MasterCount" {
  type ="string"
  default ="3"
  description = " Number of master nodes"
}
### Variable Number of Worker Nodes
variable "NodeCount" {
  type ="string"
  default ="3"
}
### Service Principal credentials for authentication
variable "TenantID" {
  type    = "string"
}

variable "Subscription_ID" {
  type    = "string"
}

variable "Client_ID" {
  type    = "string"
}

variable "Client_Secret" {
  type    = "string"
}