module "Infrastructure" {

    source = "modules/03-Infra"

    #Module variable

    RGName                  = "${var.RGName}"
    AzureRegion             = "${var.AzureRegion}"
    VMAdminName             = "${var.VMAdminName}"
    VMAdminPassword         = "${var.VMAdminPassword}"
    TenantID                = "${var.TenantID}"
    ObjectID                = "${var.ObjectID}"
    AzurePublicSSHKey       = "${var.AzurePublicSSHKey}"
    NodeCount               = "${var.NodeCount}"
    
}
module "Certificates" {

    source = "modules/04-Certs"

    #Module variable
    
    NodeCount                = "${var.NodeCount}"   
    kubelet_node_names       = "${module.Infrastructure.Worker_Names}"
    kubelet_node_ips         = "${module.Infrastructure.Worker_VM_Private_IP}"
    kubelet_public_ips       = "${module.Infrastructure.Worker_VM_Public_IP}"
    
    apiserver_node_names     = "${module.Infrastructure.Controller_Names}"   
    apiserver_master_ips     = "${module.Infrastructure.Controller_VM_Private_IP}"
    apiserver_public_ip      = "${module.Infrastructure.Kubernetes_API_Public_IP}"

    bastionIP                = "${module.Infrastructure.Kubernetes_API_Public_IP}"
    node_user                = "${var.VMAdminName}"
    node_password            = "${module.Infrastructure.VMS_Password}"
}
module "Kubeconfig" {

    source = "modules/05-Kubeconfig"

    #Module variable

    kubelet_crt_pems                = "${module.Certificates.kubelet_crt_pems}"
    kubelet_key_pems                = "${module.Certificates.kubelet_key_pems}"
    admin_crt_pem                   = "${module.Certificates.admin_crt_pem}"
    admin_key_pem                   = "${module.Certificates.admin_key_pem}"
    kube-proxy_crt_pem              = "${module.Certificates.kube-proxy_crt_pem}"
    kube-proxy_key_pem              = "${module.Certificates.kube-proxy_key_pem}"
    kube-scheduler_crt_pem          = "${module.Certificates.kube-scheduler_crt_pem}"
    kube-scheduler_key_pem          = "${module.Certificates.kube-scheduler_key_pem}"
    kube-controller-manager_crt_pem = "${module.Certificates.kube-controller-manager_crt_pem}"
    kube-controller-manager_key_pem = "${module.Certificates.kube-controller-manager_key_pem}"
    kube_ca_crt_pem                 = "${module.Certificates.kube_ca_crt_pem}"

    NodeCount                       = "${var.NodeCount}"       
    kubelet_node_names              = "${module.Infrastructure.Worker_Names}"
    apiserver_node_names            = "${module.Infrastructure.Controller_Names}"
    apiserver_public_ip             = "${module.Infrastructure.Kubernetes_API_Public_IP}"

    bastionIP                       = "${module.Infrastructure.Kubernetes_API_Public_IP}"
    node_user                       = "${var.VMAdminName}"
    node_password                   = "${module.Infrastructure.VMS_Password}"

}
module "Bootstrap" {

    source = "modules/07-12-Bootstrap"

    #Module variable

    NodeCount                   = "${var.NodeCount}"
    kubelet_node_names          = "${module.Infrastructure.Worker_Names}"
    apiserver_node_names        = "${module.Infrastructure.Controller_Names}"
    apiserver_public_ip         = "${module.Infrastructure.Kubernetes_API_Public_IP}"

    bastionIP                   = "${module.Infrastructure.Kubernetes_API_Public_IP}"    
    node_user                   = "${var.VMAdminName}"
    node_password               = "${module.Infrastructure.VMS_Password}"

    kubernetes_certs_null_ids   = "${module.Certificates.kubernetes_certs_null_ids}"
    ca_cert_null_ids            = "${module.Certificates.ca_cert_null_ids}"
    service_account_null_ids    = "${module.Certificates.service_account_null_ids}"
    encryption_config_null_ids  = "${module.Kubeconfig.encryption_config_null_ids}" 
    worker_ca_null_ids          = "${module.Certificates.worker_ca_null_ids}" 
    kubelet_crt_null_ids        = "${module.Certificates.kubelet_ca_null_ids}"
    kubelet_prov_null_ids       = "${module.Kubeconfig.kubelet_prov_null_ids}" 
    proxy_prov_null_ids         = "${module.Kubeconfig.proxy_prov_null_ids}" 
    controller_prov_null_ids    = "${module.Kubeconfig.controller_prov_null_ids}" 
    scheduler_prov_null_ids     = "${module.Kubeconfig.scheduler_prov_null_ids}"
    admin_prov_null_ids         = "${module.Kubeconfig.admin_prov_null_ids}"
}