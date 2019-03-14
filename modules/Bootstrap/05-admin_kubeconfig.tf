data "template_file" "admin_config_template" {
  template = "${file("${path.module}/admin_kubeconfig.tpl")}"

  vars {
    certificate-authority-data = "${base64encode(tls_self_signed_cert.kube_ca.cert_pem)}"
    client-certificate-data    = "${base64encode(tls_locally_signed_cert.kube_admin.cert_pem)}"
    client-key-data            = "${base64encode(tls_private_key.kube_admin.private_key_pem)}"
  }
}

resource "local_file" "admin_config" {
  content  = "${data.template_file.admin_config_template.rendered}"
  filename = "./generated/admin.kubeconfig"
}

resource "null_resource" "admin-provisioner" {
  count = 3

  depends_on = ["local_file.admin_config"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }

  provisioner "file" {
    source      = "./generated/admin.kubeconfig"
    destination = "~/admin.kubeconfig"
  }
}
