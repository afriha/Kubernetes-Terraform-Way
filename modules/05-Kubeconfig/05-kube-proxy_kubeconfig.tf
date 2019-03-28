data "template_file" "kube-proxy_config_template" {
  template = "${file("${path.module}/kube-proxy_kubeconfig.tpl")}"

  vars {
    certificate-authority-data = "${base64encode(var.kube_ca_crt_pem)}"
    client-certificate-data    = "${base64encode(var.kube-proxy_crt_pem)}"
    client-key-data            = "${base64encode(var.kube-proxy_key_pem)}"
    
    apiserver_public_ip        = "${var.apiserver_public_ip}"
  }
}

resource "local_file" "kube-proxy_config" {
  content  = "${data.template_file.kube-proxy_config_template.rendered}"
  filename = "./generated/kube-proxy.kubeconfig"
}

resource "null_resource" "kube-proxy-provisioner" {
  count = "${var.NodeCount}"

  depends_on = ["local_file.kube-proxy_config"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.kubelet_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }

  provisioner "file" {
    source      = "./generated/kube-proxy.kubeconfig"
    destination = "~/kube-proxy.kubeconfig"
  }
}
