module "Infrastructure" {

    source = "modules/infra"

    #Module variable

    RGName                  = "RG-Kube"
    AzureRegion             = "Westeurope"
    VMAdminName             = "${var.VMAdminName}"
    VMAdminPassword         = "${var.VMAdminPassword}"
    TenantID                = "${var.TenantID}"
    ObjectID                = "${var.ObjectID}"
    AzurePublicSSHKey       = "${var.AzurePublicSSHKey}"
    
}
module "Bootstrap" {

    source = "modules/bootstrap"

    #Module variable

    kubelet_node_names       = "${module.Infrastructure.worker_names}"
    apiserver_node_names     = "${module.Infrastructure.controller_names}"

    kubelet_node_ips         = "${module.Infrastructure.Worker_VM_Private_IP}"
    kubelet_public_ips       = "${module.Infrastructure.Worker_VM_Public_IP}"
    
    apiserver_master_ips     = "${module.Infrastructure.Controller_VM_Private_IP}"
    apiserver_public_ip      = "${module.Infrastructure.Kubernetes_API_Public_IP}"
    bastionIP                = "${module.Infrastructure.Kubernetes_API_Public_IP}"
    
    node_user                = "${var.VMAdminName}"
    node_password            = "${var.VMAdminPassword}"
}