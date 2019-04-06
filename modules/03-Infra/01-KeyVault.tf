# KeyVault for Kubernetes VMs

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "Kube" {
  name                        = "Kube-THW"
  location                    = "${var.AzureRegion}"
  resource_group_name         = "${var.RGName}"
  enabled_for_disk_encryption = true
  enabled_for_deployment      = true
  tenant_id                   = "${data.azurerm_client_config.current.tenant_id}"


  sku {
    name = "standard"
  }

  access_policy {
    tenant_id       = "${data.azurerm_client_config.current.tenant_id}"
    object_id       = "${data.azurerm_client_config.current.service_principal_object_id}"

    certificate_permissions = [
      "create","delete","deleteissuers",
      "get","getissuers","import","list",
      "listissuers","managecontacts","manageissuers",
      "setissuers","update",
    ]

    key_permissions = [
      "backup","create","decrypt","delete","encrypt","get",
      "import","list","purge","recover","restore","sign",
      "unwrapKey","update","verify","wrapKey",
    ]

    secret_permissions = [
      "backup","delete","get","list","purge","recover","restore","set",
    ]
  }

  tags {
    environment = "Kube THW"
  }
}
#Secret for Kubernetes VMs
resource "azurerm_key_vault_secret" "kubesecret" {
  name     = "kube-secret"
  value    = "${var.VMAdminPassword}"
  key_vault_id = "${azurerm_key_vault.Kube.id}"

  tags {
    environment = "Kube THW"
  }
}