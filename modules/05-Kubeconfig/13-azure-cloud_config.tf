data "template_file" "azure_config_template" {
  template = file("${path.module}/azurecloud_config.tpl")

  vars = {
    TenantId                   = var.TenantID
    SubscriptionId             = var.Subscription_ID
    ClientId                   = var.Client_ID
    ClientSecret               = var.Client_Secret
    resourceGroup              = var.RGName
    location                   = var.Location
    subnetName                 = var.subnetName
    securityGroupName          = var.securityGroupName
    vnetName                   = var.vnetName
    vnetResourceGroup          = var.vnetResourceGroup
    routeTableName             = var.routeTableName
    primaryAvailabilitySetName = var.primaryAvailabilitySetName
    loadBalancerSku            = var.loadBalancerSku
  }
}

resource "local_file" "azure_config" {
  content  = data.template_file.azure_config_template.rendered
  filename = "./generated/azure.json"
}

resource "null_resource" "azure-provisioner" {
  count = var.MasterCount

  depends_on = [local_file.azure_config]

  connection {
    type         = "ssh"
    user         = var.node_user
    host         = element(var.apiserver_node_names, count.index)
    password     = var.node_password
    bastion_host = var.bastionIP
  }

  provisioner "file" {
    source      = "./generated/azure.json"
    destination = "~/azure.json"
  }
}

resource "null_resource" "azure-provisioner-worker" {
  count = var.MasterCount

  depends_on = [local_file.azure_config]

  connection {
    type         = "ssh"
    user         = var.node_user
    host         = element(var.kubelet_node_names, count.index)
    password     = var.node_password
    bastion_host = var.bastionIP
  }

  provisioner "file" {
    source      = "./generated/azure.json"
    destination = "~/azure.json"
  }
}

