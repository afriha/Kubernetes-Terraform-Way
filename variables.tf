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
#TenantID and ObjectID variables for Vault
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