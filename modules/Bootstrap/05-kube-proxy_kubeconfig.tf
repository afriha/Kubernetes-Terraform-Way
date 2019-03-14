data "template_file" "kube-proxy_config_template" {
  template = "${file("${path.module}/kube-proxy_kubeconfig.tpl")}"

  vars {
    certificate-authority-data = "${base64encode(tls_self_signed_cert.kube_ca.cert_pem)}"
    client-certificate-data    = "${base64encode(tls_locally_signed_cert.kube_proxy.cert_pem)}"
    client-key-data            = "${base64encode(tls_private_key.kube_proxy.private_key_pem)}"
    apiserver_public_ip        = "${var.apiserver_public_ip}"
  }
}

resource "local_file" "kube-proxy_config" {
  content  = "${data.template_file.kube-proxy_config_template.rendered}"
  filename = "./generated/kube-proxy.kubeconfig"
}

resource "null_resource" "kube-proxy-provisioner" {
  count = 3

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
