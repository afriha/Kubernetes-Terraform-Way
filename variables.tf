variable "AzureRegion" {
  type    = "string"
  default = "westeurope"
}
variable "RGName" {
  type    = "string"
}
# Variable defining VM Admin Name
variable "VMAdminName" {
  type    = "string"
}
# Variable defining VM Admin password
variable "VMAdminPassword" {
  type    = "string"
}
# Variable Number of Worker Nodes
variable "NodeCount" {
  type ="string"
  default ="3"
}
#TenantID and ObjectID variables for Vault
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
# Variable defining SSH Key
variable "AzurePublicSSHKey" {
  type    = "string"
  default = ""
}