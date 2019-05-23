# Availability Set for Controller VMs

resource "azurerm_availability_set" "Controller-AS" {
  name                = "Controller-AS"
  location            = var.AzureRegion
  managed             = "true"
  resource_group_name = var.RGName
  tags = {
    environment = var.TagEnvironment
    usage       = var.TagUsage
  }
}

# Availability Set for Worker VMs

resource "azurerm_availability_set" "Worker-AS" {
  name                = "Worker-AS"
  location            = var.AzureRegion
  managed             = "true"
  resource_group_name = var.RGName
  tags = {
    environment = var.TagEnvironment
    usage       = var.TagUsage
  }
}

