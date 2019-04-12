terraform {
    backend "azurerm" {
    }
}

provider "azurerm" {
  subscription_id = "${var.Subscription_ID}"
  tenant_id       = "${var.TenantID}"
  client_id       = "${var.Client_ID}"
  client_secret   = "${var.Client_Secret}"
}

data "azurerm_resource_group" "AEK-K8S" {
  name = "${var.RGName}"
}
module "Infrastructure" {

    source = "modules/03-Infra"

    #Module variable

    RGName                              = "${data.azurerm_resource_group.AEK-K8S.name}"
    AzureRegion                         = "${data.azurerm_resource_group.AEK-K8S.location}"
    VMAdminName                         = "${var.VMAdminName}"
    VMAdminPassword                     = "${var.VMAdminPassword}"
    AzurePublicSSHKey                   = "${var.AzurePublicSSHKey}"
    MasterCount                         = "${var.MasterCount}"
    NodeCount                           = "${var.NodeCount}"
    
}
module "Certificates" {

    source = "modules/04-Certs"

    #Module variable
    MasterCount                         = "${var.MasterCount}" 
    NodeCount                           = "${var.NodeCount}"   
    kubelet_node_names                  = "${module.Infrastructure.Worker_Names}"
    kubelet_node_ips                    = "${module.Infrastructure.Worker_VM_Private_IP}"
    
    apiserver_node_names                = "${module.Infrastructure.Controller_Names}"   
    apiserver_master_ips                = "${module.Infrastructure.Controller_VM_Private_IP}"
    apiserver_public_ip                 = "${module.Infrastructure.Kubernetes_API_Public_IP}"

    bastionIP                           = "${module.Infrastructure.Kubernetes_API_Public_IP}"
    node_user                           = "${module.Infrastructure.VMS_User}"
    node_password                       = "${module.Infrastructure.VMS_Password}"
}
module "Kubeconfig" {

    source = "modules/05-Kubeconfig"

    #Module variable

    MasterCount                         = "${var.MasterCount}"    
    NodeCount                           = "${var.NodeCount}"

    kubelet_crt_pems                    = "${module.Certificates.kubelet_crt_pems}"
    kubelet_key_pems                    = "${module.Certificates.kubelet_key_pems}"
    admin_crt_pem                       = "${module.Certificates.admin_crt_pem}"
    admin_key_pem                       = "${module.Certificates.admin_key_pem}"
    kube-proxy_crt_pem                  = "${module.Certificates.kube-proxy_crt_pem}"
    kube-proxy_key_pem                  = "${module.Certificates.kube-proxy_key_pem}"
    kube-scheduler_crt_pem              = "${module.Certificates.kube-scheduler_crt_pem}"
    kube-scheduler_key_pem              = "${module.Certificates.kube-scheduler_key_pem}"
    kube-controller-manager_crt_pem     = "${module.Certificates.kube-controller-manager_crt_pem}"
    kube-controller-manager_key_pem     = "${module.Certificates.kube-controller-manager_key_pem}"
    kube_ca_crt_pem                     = "${module.Certificates.kube_ca_crt_pem}"
    cloud-manager_crt_pem               = "${module.Certificates.cloud-manager_crt_pem}"
    cloud-manager_key_pem               = "${module.Certificates.cloud-manager_key_pem}"

    MasterCount                         = "${var.MasterCount}"    
    NodeCount                           = "${var.NodeCount}"

    kubelet_node_names                  = "${module.Infrastructure.Worker_Names}"
    apiserver_node_names                = "${module.Infrastructure.Controller_Names}"
    apiserver_public_ip                 = "${module.Infrastructure.Kubernetes_API_Public_IP}"
    bastionIP                           = "${module.Infrastructure.Kubernetes_API_Public_IP}"
    node_user                           = "${module.Infrastructure.VMS_User}"
    node_password                       = "${module.Infrastructure.VMS_Password}"

    #Azure config varibles
    TenantID                            = "${var.TenantID}"
    Subscription_ID                     = "${var.Subscription_ID}"
    Client_ID                           = "${var.Client_ID}"
    Client_Secret                       = "${var.Client_Secret}"
    RGName                              = "${data.azurerm_resource_group.AEK-K8S.name}"
    Location                            = "${data.azurerm_resource_group.AEK-K8S.location}"
    vnetResourceGroup                   = "${data.azurerm_resource_group.AEK-K8S.name}"
    vnetName                            = "${module.Infrastructure.Vnet_Name}"
    subnetName                          = "${module.Infrastructure.Subnet_Name}"
    securityGroupName                   = "${module.Infrastructure.SecurityG_Name}"
    routeTableName                      = "${module.Infrastructure.RouteTable_Name}"
    primaryAvailabilitySetName          = "${module.Infrastructure.AS_Name}"
    loadBalancerSku                     = "Basic"

}
module "Etcd" {

    source = "modules/07-Etcd"

    #Module variable

    MasterCount                         = "${var.MasterCount}"

    apiserver_node_names                = "${module.Infrastructure.Controller_Names}"
    bastionIP                           = "${module.Infrastructure.Kubernetes_API_Public_IP}"    
    node_user                           = "${module.Infrastructure.VMS_User}"
    node_password                       = "${module.Infrastructure.VMS_Password}"

    kubernetes_certs_null_ids           = "${module.Certificates.kubernetes_certs_null_ids}"
    ca_cert_null_ids                    = "${module.Certificates.ca_cert_null_ids}"

}
module "Control_Plane" {

    source = "modules/08-Control-Plane"

    #Module variable

    MasterCount                         = "${var.MasterCount}"

    apiserver_node_names                = "${module.Infrastructure.Controller_Names}"
    apiserver_public_ip                 = "${module.Infrastructure.Kubernetes_API_Public_IP}"
    bastionIP                           = "${module.Infrastructure.Kubernetes_API_Public_IP}"    
    node_user                           = "${module.Infrastructure.VMS_User}"
    node_password                       = "${module.Infrastructure.VMS_Password}"

    kubernetes_certs_null_ids           = "${module.Certificates.kubernetes_certs_null_ids}"
    ca_cert_null_ids                    = "${module.Certificates.ca_cert_null_ids}"
    service_account_null_ids            = "${module.Certificates.service_account_null_ids}"
    
    encryption_config_null_ids          = "${module.Kubeconfig.encryption_config_null_ids}" 
    controller_prov_null_ids            = "${module.Kubeconfig.controller_prov_null_ids}" 
    scheduler_prov_null_ids             = "${module.Kubeconfig.scheduler_prov_null_ids}"
    admin_prov_null_ids                 = "${module.Kubeconfig.admin_prov_null_ids}"
    cloud_controller_prov_null_ids      = "${module.Kubeconfig.cloud_controller_prov_null_ids}"
    azure_prov_null_ids                 = "${module.Kubeconfig.azure_prov_null_ids}"

    etcd_server_null_ids                = "${module.Etcd.etcd_server_null_ids}"

}

module "Worker_Nodes" {

    source = "modules/09-Worker-Nodes"
    
    #Module variable

    NodeCount                           = "${var.NodeCount}"

    kubelet_node_names                  = "${module.Infrastructure.Worker_Names}"
    bastionIP                           = "${module.Infrastructure.Kubernetes_API_Public_IP}"    
    node_user                           = "${module.Infrastructure.VMS_User}"
    node_password                       = "${module.Infrastructure.VMS_Password}"
    
    worker_ca_null_ids                  = "${module.Certificates.worker_ca_null_ids}" 
    kubelet_crt_null_ids                = "${module.Certificates.kubelet_ca_null_ids}"

    kubelet_prov_null_ids               = "${module.Kubeconfig.kubelet_prov_null_ids}" 
    proxy_prov_null_ids                 = "${module.Kubeconfig.proxy_prov_null_ids}"
    azure_worker_prov_null_ids          = "${module.Kubeconfig.azure_worker_prov_null_ids}"

    etcd_server_null_ids                = "${module.Etcd.etcd_server_null_ids}"
    control_plane_null_ids              = "${module.Control_Plane.control_plane_null_ids}"
    rbac_ccm_null_id                    = "${module.Control_Plane.rbac_ccm_null_id}"
    rbac_apiserver_null_id              = "${module.Control_Plane.rbac_apiserver_null_id}"

}

module "AddOns" {

  source = "modules/10-AddOns"

    apiserver_public_ip                 = "${module.Infrastructure.Kubernetes_API_Public_IP}"
    bastionIP                           = "${module.Infrastructure.Kubernetes_API_Public_IP}"    
    node_user                           = "${module.Infrastructure.VMS_User}"
    node_password                       = "${module.Infrastructure.VMS_Password}"

    etcd_server_null_ids                = "${module.Etcd.etcd_server_null_ids}"
    control_plane_null_ids              = "${module.Control_Plane.control_plane_null_ids}"
    rbac_ccm_null_id                    = "${module.Control_Plane.rbac_ccm_null_id}"
    rbac_apiserver_null_id              = "${module.Control_Plane.rbac_apiserver_null_id}"
    worker_nodes_null_ids               = "${module.Worker_Nodes.worker_nodes_null_ids}"
  
}