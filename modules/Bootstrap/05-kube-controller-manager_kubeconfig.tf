data "template_file" "kube-controller-manager_config_template" {
  template = "${file("${path.module}/kube-controller-manager_kubeconfig.tpl")}"

  vars {
    certificate-authority-data = "${base64encode(tls_self_signed_cert.kube_ca.cert_pem)}"
    client-certificate-data    = "${base64encode(tls_locally_signed_cert.kube_controller_manager.cert_pem)}"
    client-key-data            = "${base64encode(tls_private_key.kube_controller_manager.private_key_pem)}"
  }
}

resource "local_file" "kube-controller-manager_config" {
  content  = "${data.template_file.kube-controller-manager_config_template.rendered}"
  filename = "./generated/kube-controller-manager.kubeconfig"
}

resource "null_resource" "kube-controller-manager-provisioner" {
  count = 3

  depends_on = ["local_file.kube-controller-manager_config"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }

  provisioner "file" {
    source      = "./generated/kube-controller-manager.kubeconfig"
    destination = "~/kube-controller-manager.kubeconfig"
  }
}
