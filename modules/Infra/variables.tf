variable "AzureRegion" {
type    = "string"
default = "westeurope"
}
variable "RGName" {
type    = "string"
default = "RG-Kube"
}
# Variable defining VM Admin Name
variable "VMAdminName" {
type    = "string"
}
# Variable defining VM Admin password
variable "VMAdminPassword" {
type    = "string"
}
variable "TenantID" {
type    = "string"
}variable "ObjectID" {
type    = "string"
}
# Variable defining SSH Key
variable "AzurePublicSSHKey" {
type    = "string"
default = ""
}
# Variable to define the Tag
variable "TagEnvironment" {
type    = "string"
default = "Kubernetes"
}
variable "TagUsage" {
type    = "string"
default = "Kubernetes THW"
}
# Variables to define the OS Config
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
#variable defining VM size
variable "VMSize" {
  type    = "string"
  default = "Standard_F1S"
}